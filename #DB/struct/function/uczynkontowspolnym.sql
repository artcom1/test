CREATE FUNCTION uczynkontowspolnym(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _idkonta ALIAS FOR $1;
  _idklienta ALIAS FOR $2;
BEGIN

 RAISE NOTICE 'Update 1';
 UPDATE kh_konta SET kt_flaga=kt_flaga|4 WHERE kt_idkonta=_idkonta;                                   --- Uczyn konto rozrachunkowym
 RAISE NOTICE 'Update 2';
 UPDATE kh_konta SET kt_flaga=kt_flaga|(1<<12),k_idklienta=_idklienta WHERE kt_idkonta=_idkonta;      --- Wspolnym z kontrahentem

 ---Zrob update na zapisach
 RAISE NOTICE 'Update 3';
 UPDATE kh_zapisyelem SET zp_flaga=zp_flaga|(2|64|256) WHERE kt_idkontawn=_idkonta;
 RAISE NOTICE 'Update 4';
 UPDATE kh_zapisyelem SET zp_flaga=zp_flaga|(4|128|512) WHERE kt_idkontama=_idkonta;

 --Skonwertuj zapisy
 RAISE NOTICE 'Update 5';
 PERFORM przepiszRozrachunki(zp_idelzapisu,true) FROM kh_zapisyelem WHERE kt_idkontawn=_idkonta;
 RAISE NOTICE 'Update 6';
 PERFORM przepiszRozrachunki(zp_idelzapisu,false) FROM kh_zapisyelem WHERE kt_idkontama=_idkonta;

 UPDATE kr_rozrachunki SET k_idklienta=_idklienta WHERE k_idklienta IS NULL AND kt_idkonta=_idkonta;
--- UPDATE kr_salda SET k_idklienta=_idklienta WHERE k_idklienta IS NULL and kt_idkonta=_idkonta;

 RETURN TRUE;
END;
$_$;
