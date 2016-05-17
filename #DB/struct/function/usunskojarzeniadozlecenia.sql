CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---argumentem zlecenia do ktorego maja byc usuniete skojarzenia, 
DECLARE
 plan RECORD;
BEGIN
 FOR plan IN SELECT pz_idplanu FROM tg_planzlecenia WHERE zl_idzlecenia=$1 AND pz_idref>0 ORDER BY pz_idref DESC
 LOOP
  ---- usuwamy najpier plan zagniezdzony
  DELETE FROM tg_planzlecenia WHERE pz_idplanu=plan.pz_idplanu;
 END LOOP;
 
 DELETE FROM tg_planzlecenia WHERE zl_idzlecenia=$1;
 DELETE FROM tg_klientzlecenia WHERE zl_idzlecenia=$1;
 DELETE FROM tg_hotelezlecen WHERE zl_idzlecenia=$1;
 DELETE FROM tg_etapyzlecen WHERE zl_idzlecenia=$1;
 DELETE FROM tg_przejazdy WHERE zl_idzlecenia=$1;
 DELETE FROM tb_zdarzenia WHERE zl_idzlecenia=$1 AND (zd_flaga&1)=1;

 UPDATE tg_prace SET zl_idzlecenia=NULL, pr_flaga=pr_flaga&(~1) WHERE zl_idzlecenia=$1;
 UPDATE tg_transakcje SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 UPDATE kh_platnosci SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 UPDATE tg_towary SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 UPDATE tb_kontakt SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 UPDATE tb_todo SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 UPDATE tb_zdarzenia SET zl_idzlecenia=null WHERE zl_idzlecenia=$1;
 RETURN 1;
END;
$_$;
