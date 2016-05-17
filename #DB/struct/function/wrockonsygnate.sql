CREATE FUNCTION wrockonsygnate(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idpz ALIAS FOR $1;
 _idks INT;
 _iloscprzed NUMERIC;
 _iloscpo NUMERIC;
 _iloscks NUMERIC;
BEGIN
 
 ---------Znajdz ID konsygnaty
 _idks=(SELECT tel_idpzam FROM tg_realizacjapzam WHERE tel_idelemsrc=_idpz AND rm_powod=14);
 IF (_idks IS NULL) THEN
  RAISE EXCEPTION 'Brak dokumentu KS dla %s ',_idpz;
 END IF;

 _iloscks=(SELECT sum(rc_ilosc) FROM tg_ruchy WHERE tel_idelem=_idks);
 _iloscprzed=nullZero((SELECT sum(rc_ilosc) FROM tg_ruchy WHERE tel_idelem=_idpz));

 -------Ustaw cene na PZ taka jak na konsygnacie
 PERFORM zmienCenePZ(_idpz,
                     (SELECT tel_cenawal FROM tg_transelem WHERE tel_idelem=_idks),
		     (SELECT tel_walutawal FROM tg_transelem WHERE tel_idelem=_idks)
		    );
 PERFORM gm.zmianaCenyPZ(_idpz);

 --------------------Przepisz ruchy z PZ na konsygnate
 UPDATE tg_ruchy SET tel_idelem=_idks,tr_idtrans=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=_idks) WHERE tel_idelem=_idpz;

 ------------Usun pozycje konsygnaty - przeniosa sie ilosci
 DELETE FROM tg_transelem WHERE tel_idelem=_idpz;

 _iloscpo=nullZero((SELECT sum(rc_ilosc) FROM tg_ruchy WHERE tel_idelem=_idks));

 IF (_iloscks+_iloscprzed<>_iloscpo) THEN
  RAISE EXCEPTION 'Blad przy cofaniu konsygnaty % % % (% %)',_iloscks,_iloscprzed,_iloscpo,_idpz,_idks;
 END IF;
 
 RETURN TRUE;
END;
$_$;
