CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kooperacja ALIAS FOR $1;
 
 _iloscprzyjec INT:=0;
 
 _knw_idelemu INT:=0;
 _p_idpracownika INT:=0;
 _kwk_przyjetodobrych NUMERIC:=0;
 _kwk_przyjetobrakow NUMERIC:=0;
 _kwk_dataprzyjecia TIMESTAMP WITH TIME ZONE;
 _kwk_flaga INT:=0 ;
BEGIN 
 IF (kooperacja.knw_flaga&(1<<7)=0) THEN 
  RAISE NOTICE 'Zla flaga!';
  RETURN 0;
 END IF;
 
 _knw_idelemu=kooperacja.knw_idelemu;
 _iloscprzyjec=(SELECT COUNT(*) FROM tr_kkwnodwykdetkooperacja WHERE knw_idelemu=_knw_idelemu);
 IF (_iloscprzyjec>0) THEN 
  RAISE NOTICE 'Jest juz % przyjec!',_iloscprzyjec;
  RETURN 0;
 END IF;
  
 _p_idpracownika=(SELECT lg_uid FROM tg_log WHERE lg_typeref=153 AND lg_ref=lg_ref AND lg_txt ILIKE 'Utworzenie rekordu%' LIMIT 1);
   
 IF (COALESCE(_p_idpracownika,0)<=0) THEN 
  _p_idpracownika=(SELECT MIN(p_idpracownika) FROM tb_pracownicy WHERE p_idpracownika>0);
  RAISE NOTICE 'Nie znaleziono pracownika w logach, biore %!',_p_idpracownika;
 END IF;
 
 _kwk_przyjetodobrych=kooperacja.knw_iloscwyk;
 _kwk_przyjetobrakow=kooperacja.knw_iloscbrakow;
 _kwk_dataprzyjecia=kooperacja.knw_datawyk;
  
 RAISE NOTICE 'Dodaje % % % % % %',_knw_idelemu,_p_idpracownika,_kwk_przyjetodobrych,_kwk_przyjetobrakow,_kwk_dataprzyjecia,_kwk_flaga;
 
 INSERT INTO tr_kkwnodwykdetkooperacja
 (knw_idelemu,p_idpracownika,kwk_przyjetodobrych,kwk_przyjetobrakow,kwk_dataprzyjecia,kwk_flaga) 
 VALUES 
 (_knw_idelemu,_p_idpracownika,_kwk_przyjetodobrych,_kwk_przyjetobrakow,_kwk_dataprzyjecia,_kwk_flaga);
 
 RETURN 1;
END;
$_$;
