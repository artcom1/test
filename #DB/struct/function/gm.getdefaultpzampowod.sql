CREATE FUNCTION getdefaultpzampowod(new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN ((new2flaga>>15)&(3|60))=(1|(3<<2)) THEN 18 WHEN ((new2flaga>>11)&1)!=0 THEN 16 ELSE NULL END);
$$;
