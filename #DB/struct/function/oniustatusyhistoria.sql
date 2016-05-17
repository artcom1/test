CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 query TEXT;
 r RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN

  UPDATE tg_statusyhistoria SET sh_aktualny=FALSE WHERE sh_idref=NEW.sh_idref AND sh_type=NEW.sh_type AND sh_aktualny=TRUE;

  IF (NEW.sh_type=8) THEN
   UPDATE tg_transakcje SET st_idstatusu=NEW.st_idstatusu,tr_zamknieta=tr_zamknieta|16384 WHERE tr_idtrans=NEW.sh_idref;
   RETURN NEW;
  END IF;

  IF (NEW.sh_type=17) THEN
   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,1,te.tel_idelem) FROM tg_transelem AS te WHERE (tel_idelem=NEW.sh_idref OR tel_skojzestaw=NEW.sh_idref) AND gmr.gettypzestawu(tel_new2flaga) IN (3);
   UPDATE tg_transelem SET st_idstatusu=NEW.st_idstatusu, tel_flaga=tel_flaga|16384 WHERE tel_idelem=NEW.sh_idref OR (tel_skojzestaw=NEW.sh_idref AND gmr.gettypzestawu(tel_new2flaga) IN (3));
   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,-1,te.tel_idelem) FROM tg_transelem AS te WHERE (tel_idelem=NEW.sh_idref OR tel_skojzestaw=NEW.sh_idref) AND gmr.gettypzestawu(tel_new2flaga) IN (3);
   RETURN NEW;
  END IF;

  SELECT * INTO r FROM vendo.tm_tableinfo WHERE tid_datatype=NEW.sh_type;
  IF (r.tid_datatype IS NULL) THEN
   RAISE EXCEPTION 'Brak informacji o typie %',NEW.sh_type;
  END IF;

  query='UPDATE '||r.tid_tablename||' SET st_idstatusu='||NEW.st_idstatusu||' WHERE '||r.tid_tablepkey||'='||NEW.sh_idref;

  EXECUTE query;  
 END IF;

 RETURN NEW;
END;
$$;
