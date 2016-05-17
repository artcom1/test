CREATE FUNCTION przepiszskojarzeniadozlecenia(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
---od zlecenia o pierwszym argumecie przepinamy dokumenty do drugiego zlecenia 
DECLARE
 zl_id ALIAS FOR $1;
 zl_id_new ALIAS FOR $2;
 
BEGIN
--- UPDATE tg_planzlecenia  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
--- UPDATE tg_klientzlecenia  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
--- UPDATE tg_hotelezlecen  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
---- UPDATE tg_etapyzlecen  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
---- UPDATE tg_przejazdy  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
---- UPDATE tg_prace  SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;

 UPDATE tg_transakcje SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
 UPDATE kh_platnosci SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
 UPDATE tg_towary SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
 UPDATE tb_kontakt SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
 UPDATE tb_todo SET zl_idzlecenia=zl_id_new WHERE zl_idzlecenia=zl_id;
 UPDATE tg_pliki SET tpl_ref=zl_id_new WHERE tpl_flaga!=2 AND tpl_ref=zl_id AND tag_id IN ( SELECT tag_id FROM tb_tag WHERE tag_flag=tag_flag|16 AND tag_datatype=32 AND tag_subdatatype=2 ) ;
 RETURN 1;
END;
$_$;
