CREATE FUNCTION onbiudstrukturakonstrukcyjna() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 rec RECORD;
 _fm_indextab INT;
 aktualnastruktura INT:=NULL;
BEGIN
    
 IF (TG_OP='INSERT') THEN
  IF (NEW.sk_flaga&(1<<6)=0) THEN
   PERFORM oznacztowarstruktura(NEW.ttw_idtowaru,1);
   IF (NEW.sk_idzrodla>0) THEN
   ---mamy strukture jako kolejna wersje - musimy ustawic odpowiednia sekwencje oraz wersjalp
    SELECT max(sk_wersjalp) AS sk_wersjalp, sk_seq INTO rec FROM tr_strukturakonstrukcyjna WHERE sk_seq=(SELECT sk_seq FROM tr_strukturakonstrukcyjna WHERE sk_idstruktury=NEW.sk_idzrodla) GROUP BY sk_seq;
    NEW.sk_seq=rec.sk_seq;
    NEW.sk_wersjalp=NullZero(rec.sk_wersjalp)+1;
   END IF;
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  IF (NEW.sk_flaga&16384=16384) THEN
   ---nie wywolujemy trigerow wiec zerujemy ten bit i wychodzimy
   NEW.sk_flaga=NEW.sk_flaga&(~16384);
   RETURN NEW;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.ttw_idtowaru!=OLD.ttw_idtowaru AND NEW.sk_flaga&(1<<6)=0) THEN  
   ---zmiana wyrobu lub aktywnosci
   PERFORM oznacztowarstruktura(NEW.ttw_idtowaru,1);
   PERFORM oznacztowarstruktura(OLD.ttw_idtowaru,(SELECT count(*)::int FROM tr_strukturakonstrukcyjna WHERE sk_idstruktury!=OLD.sk_idstruktury AND ttw_idtowaru=OLD.ttw_idtowaru ));

   IF (NEW.sk_idzrodla>0) THEN
   ---struktura byla jako kolejna wersja a wiec musimy wyzerowac wersjalp oraz nadac nowa sekwencje, kasujemy rowniez powiazanie do zrodla
    NEW.sk_idzrodla=NULL;
    NEW.sk_wersjalp=1;
    NEW.sk_seq=nextval('tr_strukturakon_wersja'::regclass);
   END IF;
  END IF;

  IF (NEW.sk_flaga&1=1 AND OLD.sk_flaga&1=0) THEN
   ----zatwierdzenie struktury
   NEW.sk_flaga=NEW.sk_flaga|32;
  END IF;

  IF (NEW.sk_flaga&1=0 AND OLD.sk_flaga&1=1 AND NEW.sk_flaga&32=32 AND NEW.sk_flaga&(1<<6)=0) THEN
   ----otwieramy strukture ktora byla zatwierdzona ostania dla danego towaru
   NEW.sk_flaga=NEW.sk_flaga&(~32);
   SELECT sk_idstruktury INTO rec FROM tr_strukturakonstrukcyjna WHERE ttw_idtowaru=NEW.ttw_idtowaru AND sk_flaga&1=1  AND sk_idstruktury!=NEW.sk_idstruktury  ORDER BY sk_dataakceptacji DESC LIMIT 1;
   UPDATE tr_strukturakonstrukcyjna SET sk_flaga=sk_flaga|(16384+32), sk_dataobowiazywania=null WHERE sk_idstruktury=rec.sk_idstruktury;
   ---uaktualniamy na karcie towaru nowa aktualna strukture
   _fm_indextab=(SELECT fm_idindextab FROM tb_firma WHERE fm_index=NEW.fm_idcentrali);
   UPDATE tg_towary SET  ttw_strukturakonstrukcyjna[_fm_indextab]=rec.sk_idstruktury WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;

  IF (NEW.sk_flaga&32=32 AND OLD.sk_flaga&32=0 AND NEW.sk_flaga&(1<<6)=0) THEN
   ---mamy ostatnio zatwierdzona strukture, wiec przenosimy ja na karte towaru
   UPDATE tr_strukturakonstrukcyjna SET sk_flaga=(sk_flaga|16384)&(~32), sk_dataobowiazywania=now()  WHERE ttw_idtowaru=NEW.ttw_idtowaru AND sk_flaga&1=1 AND sk_idstruktury!=NEW.sk_idstruktury AND sk_flaga&32=32;
   _fm_indextab=(SELECT fm_idindextab FROM tb_firma WHERE fm_index=NEW.fm_idcentrali);
   UPDATE tg_towary SET  ttw_strukturakonstrukcyjna[_fm_indextab]=NEW.sk_idstruktury WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.sk_flaga&(1<<6)=0) THEN
   PERFORM oznaczTowarTechnologia(OLD.ttw_idtowaru,(SELECT count(*)::int FROM tr_strukturakonstrukcyjna WHERE sk_idstruktury!=OLD.sk_idstruktury AND ttw_idtowaru=OLD.ttw_idtowaru ));
   _fm_indextab=(SELECT fm_idindextab FROM tb_firma WHERE fm_index=OLD.fm_idcentrali);

   IF (OLD.sk_flaga&1=1 AND OLD.sk_flaga&32=32 AND OLD.sk_flaga&(1<<6)=0) THEN ---usuwana struktura byla zatwierdzona ostatnio wiec trzeba znalesc inna i ustawic odpowidni bit
    SELECT sk_idstruktury INTO rec FROM tr_strukturakonstrukcyjna WHERE ttw_idtowaru=OLD.ttw_idtowaru AND sk_flaga&1=1  AND sk_idstruktury!=OLD.sk_idstruktury ORDER BY sk_dataakceptacji DESC LIMIT 1;
    UPDATE tr_strukturakonstrukcyjna SET sk_flaga=sk_flaga|(16384+32), sk_dataobowiazywania=null WHERE sk_idstruktury=rec.sk_idstruktury;
    aktualnastruktura=rec.sk_idstruktury;
    UPDATE tg_towary SET  ttw_strukturakonstrukcyjna[_fm_indextab]=aktualnastruktura WHERE ttw_idtowaru=OLD.ttw_idtowaru;
   END IF;

  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.sk_flaga&(1<<6)=0) THEN
   PERFORM oznacztowarstruktura(OLD.ttw_idtowaru,(SELECT count(*)::int FROM tr_strukturakonstrukcyjna WHERE sk_idstruktury!=OLD.sk_idstruktury AND ttw_idtowaru=OLD.ttw_idtowaru ));
  END IF;
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
