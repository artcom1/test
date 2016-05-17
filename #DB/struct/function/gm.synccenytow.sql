CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowarusrc ALIAS FOR $1;
 _idtowarudst ALIAS FOR $2;
 hs HSTORE;
 r RECORD;
 rnew tg_ceny;
 cmd TEXT;
 nid INT;
BEGIN
 ---Zablokuj trigger do synchronizacji
 PERFORM vendo.settparami('XREFSYNCCENY',vendo.gettparami('XREFSYNCCENY',0)+1);
 ---Kolejnosc sortowania (trzeba miec ja pewna zeby nie bylo przez chwile niedozwolonej sytuacji w ktorej sa dwie domyslne ceny)
 ---1. Upewnij sie ze najpierw ida rekordy ktore sa w celu,
 ---2. Upewnij sie ze najpierw sa docelowe rekordy z domyslna cena
 ---3. Upewnij sie ze zrodlowa domyslna cena bedzie na koncu
 ---4. Warunek sortowania normalny  
 FOR r IN SELECT src.hsrc,src.tcn_idceny,dst.tcn_idceny AS idcenydst
          FROM 
		   (SELECT *,hstore(srci) AS hsrc FROM tg_ceny AS srci WHERE srci.ttw_idtowaru=_idtowarusrc) AS src
		  FULL JOIN
		   (SELECT *,hstore(dsti) AS hdst FROM tg_ceny AS dsti WHERE dsti.ttw_idtowaru=_idtowarudst) AS dst 
		  USING (tgc_idgrupy)
		  WHERE hsrc IS DISTINCT FROM (hdst || hstore('tcn_idceny',src.tcn_idceny::text) || hstore('ttw_idtowaru',src.ttw_idtowaru::text) || hstore('tcn_lastchange',src.tcn_lastchange::text))
		  ORDER BY (dst.tcn_idceny IS NOT NULL) DESC,dst.tcn_isdefault DESC,src.tcn_isdefault ASC,src.tcn_idceny ASC
 LOOP
  ----RAISE NOTICE '1-----------------------------------------------------------------------';
  ------------------------------------------------------------------
  IF (r.tcn_idceny IS NULL AND r.idcenydst IS NOT NULL) THEN
   ----RAISE NOTICE 'Usuniecie ceny %',r.idcenydst;
   DELETE FROM tg_ceny WHERE tcn_idceny=r.idcenydst;
   PERFORM vendo.toLog('Usuniecie ceny przy aktualizacji z nadindeksem','tg_ceny',r.idcenydst); 
   CONTINUE;
  END IF;
  ------------------------------------------------------------------
  ---Usun z HSTORE pola ktorych nie ruszamy wogole
  hs=r.hsrc;
  hs=delete(hs,ARRAY['tcn_idceny','tcn_lastchange','ttw_idtowaru']);
  ---RAISE NOTICE 'HSTORE: %',hs;
  ------------------------------------------------------------------
  IF (r.idcenydst IS NULL) THEN
   ---RAISE NOTICE 'Dodanie nowej ceny na wzor % ',r.tcn_idceny;
   ---Updatujemy wartosci na nowe
   nid=nextval('tg_ceny_s');
   hs=hs || hstore('tcn_idceny',nid::text);
   hs=hs || hstore('ttw_idtowaru',_idtowarudst::text);
   hs=hs || hstore('tcn_lastchange',now()::text);
   cmd='INSERT INTO tg_ceny ('||vendo.fieldNames(rnew)||') VALUES '||vendo.record2string(populate_record(rnew,hs));
   ----RAISE NOTICE 'CMD %',cmd;
   EXECUTE cmd;
   PERFORM vendo.toLog('Przeniesienie ceny z nadindeksu','tg_ceny',nid); 
   CONTINUE;
  END IF;
  ------------------------------------------------------------------
  ----RAISE NOTICE 'Update ceny %->%',r.tcn_idceny,r.idcenydst;
  ---Na HSTORE aktualizujemy na nim tylko ID ceny i ID towaru
  hs=hs || hstore('tcn_idceny',r.idcenydst::text);
  hs=hs || hstore('ttw_idtowaru',_idtowarudst::text);
  ---Zwijamy HSTORE do tg_ceny
  rnew=populate_record(NULL::tg_ceny,hs);  
  ---Zapytanie
  cmd='UPDATE tg_ceny SET ('||vendo.fieldNames(rnew)||') = '||vendo.record2string(rnew)||' WHERE tcn_idceny='||r.idcenydst;
  ---RAISE NOTICE 'CMD %',cmd;
  EXECUTE cmd;
  
  PERFORM vendo.toLog('Aktualizacja ceny z nadindeksu','tg_ceny',r.idcenydst); 
 END LOOP;

 ---Odblokuj trigger do synchronizacji
 PERFORM vendo.settparami('XREFSYNCCENY',vendo.gettparami('XREFSYNCCENY',0)-1);
 
 RETURN TRUE;
END
$_$;
