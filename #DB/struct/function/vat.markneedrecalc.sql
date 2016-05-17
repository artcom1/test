CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParamI('DRCS_'||$1,vendo.getTParamI('DRCS_'||$1,0)+1);
$_$;
