CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN (tr_flaga&512)=512 THEN -1 ELSE 1 END)*(CASE WHEN (tr_newflaga&(1<<21))!=0 THEN -1 ELSE 1 END);
$$;
