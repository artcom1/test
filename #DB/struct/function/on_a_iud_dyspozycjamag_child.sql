CREATE FUNCTION on_a_iud_dyspozycjamag_child() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltai_dysp v.delta;
 deltaimag_dysp v.delta;
 deltaimagc_dysp v.delta;
 
 _dmag_idparent    INT;
BEGIN
 IF (TG_OP<>'INSERT') THEN
  deltai_dysp.value_old=OLD.dmag_ilosc;
  deltaimag_dysp.value_old=OLD.dmag_iloscwmag;
  deltaimagc_dysp.value_old=OLD.dmag_iloscwmagclosed;
   
  _dmag_idparent=OLD.dmag_idparent;
 END IF;
  
 IF (TG_OP<>'DELETE') THEN 
  deltai_dysp.value_new=NEW.dmag_ilosc;
  deltaimag_dysp.value_new=NEW.dmag_iloscwmag;
  deltaimagc_dysp.value_new=NEW.dmag_iloscwmagclosed;
   
  _dmag_idparent=NEW.dmag_idparent;
 END IF;
    
 IF ((v.deltavalueold(deltai_dysp)<>0 OR v.deltavalueold(deltaimag_dysp)<>0 OR v.deltavalueold(deltaimagc_dysp)<>0) AND COALESCE(_dmag_idparent)>0) THEN  
   UPDATE tr_dyspozycjamag SET 
   dmag_ilosc=dmag_ilosc-v.deltavalueold(deltai_dysp),
   dmag_iloscwmag=dmag_iloscwmag-v.deltavalueold(deltaimag_dysp),
   dmag_iloscwmagclosed=dmag_iloscwmagclosed-v.deltavalueold(deltaimagc_dysp) 
   WHERE (dmag_iddyspozycji=_dmag_idparent);
 END IF;
    
 IF ((v.deltavaluenew(deltai_dysp)<>0 OR v.deltavaluenew(deltaimag_dysp)<>0 OR v.deltavaluenew(deltaimagc_dysp)<>0) AND COALESCE(_dmag_idparent)>0) THEN  
   UPDATE tr_dyspozycjamag SET 
   dmag_ilosc=dmag_ilosc+v.deltavaluenew(deltai_dysp),
   dmag_iloscwmag=dmag_iloscwmag+v.deltavaluenew(deltaimag_dysp),
   dmag_iloscwmagclosed=dmag_iloscwmagclosed+v.deltavaluenew(deltaimagc_dysp) 
   WHERE (dmag_iddyspozycji=_dmag_idparent);
 END IF;
   
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
 
END;
$$;
