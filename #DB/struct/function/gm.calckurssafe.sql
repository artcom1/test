CREATE FUNCTION calckurssafe(mulvalue numeric, divvalue numeric) RETURNS public.mpq
    LANGUAGE sql
    AS $$
 SELECT (CASE WHEN divValue=0 AND mulValue=0 THEN 0 ELSE mulValue::mpq/divValue END);
$$;
