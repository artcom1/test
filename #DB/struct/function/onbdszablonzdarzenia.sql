CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 podpieteplt INT;
BEGIN
 
 IF (TG_OP='DELETE') THEN
  podpieteplt=(
               SELECt count(*)
			   FROM tb_tplprojektu AS subplt
			   JOIN tb_relacjaprojektu AS ll ON (ll.plt_id=subplt.plt_id)
			   JOIN tb_etapprojektu AS pt ON (pt.pt_idetapu=ll.pt_idetapu_src)
			   JOIN ts_statuszlecenia AS szl ON ((szl.szl_idstatusu=pt.szl_idstatusu))
			   WHERE
			   subplt.plt_szd_idszablonu = OLD.szd_idszablonu
			  );
			  
  IF (podpieteplt>0) THEN
   RAISE EXCEPTION 'Nie mozna usunac szablonu (%)!', podpieteplt;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
