CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
  
 IF (TG_OP='UPDATE') THEN
  IF (
      NEW.szd_typplanowania<>OLD.szd_typplanowania OR
      NEW.szd_opznieniedatazak<>OLD.szd_opznieniedatazak OR  
  NEW.szd_opznienietermin<>OLD.szd_opznienietermin OR
  NEW.szd_typograniczenia<>OLD.szd_typograniczenia  
 ) THEN
   
   UPDATE tb_tplprojektu SET
   plt_flaga=((plt_flaga&(~(3<<1)))|(CASE WHEN NEW.szd_typplanowania=0 THEN (1<<1) ELSE (0<<1) END)),
   plt_opoznienie=NEW.szd_opznieniedatazak,
   plt_czastrwania=NEW.szd_opznienietermin,
   plt_startstoptype=(CASE WHEN NEW.szd_typograniczenia=0 THEN 0 ELSE 1 END)
   WHERE
   plt_szd_idszablonu = NEW.szd_idszablonu AND
   plt_id IN 
   (
    SELECT subplt.plt_id
FROM tb_tplprojektu AS subplt
JOIN tb_relacjaprojektu AS ll ON (ll.plt_id=subplt.plt_id) 
JOIN tb_etapprojektu AS pt ON (pt.pt_idetapu=ll.pt_idetapu_src) 
JOIN ts_statuszlecenia AS szl ON ((szl.szl_idstatusu=pt.szl_idstatusu))
   );
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
