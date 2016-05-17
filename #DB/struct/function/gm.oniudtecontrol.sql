CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
 pomn NUMERIC;
 iloscf NUMERIC;
 
 r RECORD;
 ilosczrealizowana NUMERIC;
BEGIN

 IF (vendo.getconfigvalue('CONTROLREZBYPLANZLECENIA')='1') AND (TG_OP!='DELETE') THEN
  id=NEW.tel_idelem;
  ---Pobierz dane z zamilosci
  SELECT * INTO r FROM tg_zamilosci WHERE tel_idelem=id;
  ---Pobierz ilosc pierwotna na zamowieniu
  iloscf=COALESCE(r.zmi_if_pierw,(SELECT tel_iloscf FROM tg_transelem WHERE tel_idelem=id));
  
  ---Tyle zrealizowano
  ilosczrealizowana=COALESCE(r.zmi_if_zreal,0);
  ---Odejmij od tego to co bylo do zrealizowania bez zlecenia
  ilosczrealizowana=ilosczrealizowana-max(iloscf-NEW.tec_pz_ilosc,0);
  ---W wyniku musi byc co najmniej 0
  ilosczrealizowana=max(ilosczrealizowana,0);
  
  ---Pomniejszyc rezerwacje trzeba o ilosc oczekujaca na wyprodukowanie
  pomn=min(NEW.tec_pz_ilosc,iloscf)-max(NEW.tec_pz_ilosczrealclosed-ilosczrealizowana,0);
    
  ---Zrob aktualizacje rekordu
  UPDATE tg_transelem SET
   tel_iloscdorezerwacji=max(0,min(tel_iloscf,iloscf-pomn)),
   tel_flaga=tel_flaga&(~256),
   tel_new2flaga=tel_new2flaga|(1<<22)
  WHERE
   tel_idelem=id AND tel_iloscdorezerwacji!=max(0,min(tel_iloscf,iloscf-pomn)) AND
   ((tel_flaga&256=256) OR (tel_new2flaga&(1<<22))!=0);   
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END
$$;
