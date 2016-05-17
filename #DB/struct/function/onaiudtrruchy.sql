CREATE FUNCTION onaiudtrruchy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  DELETE FROM tg_transelem WHERE tel_newflaga&(64|128)<>0 AND tel_ilosc=0 AND tel_idelem=OLD.tel_idelemsrc;
  DELETE FROM tg_transelem WHERE tel_newflaga&(64|128)<>0 AND tel_ilosc=0 AND tel_idelem=OLD.tel_idelemdst;

  DELETE FROM tr_dyspozycjamag WHERE dmag_iddyspozycji=OLD.dmag_iddyspozycji AND dmag_wplywmag=-1;  
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
