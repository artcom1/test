CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STABLE
    AS $$
 --- Dla setid=NULL zwraca TRUE jesli oznaczony jest jakakowliek ruch
 --- Dla setid=value zwraca TRUE jesli oznaczony jest ruch o konkretnym SETID
 SELECT (vendo.getTParamI('ANYOZNACZONYRUCHCNT'||COALESCE(setid::text,''),0)<>0);
$$;
