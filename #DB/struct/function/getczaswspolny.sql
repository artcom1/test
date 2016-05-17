CREATE FUNCTION getczaswspolny(_czasstart1 timestamp without time zone, _czasstop1 timestamp without time zone, _czasstart2 timestamp without time zone, _czasstop2 timestamp without time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (_czasStart1 IS NULL OR _czasStop1 IS NULL OR _czasStart2 IS NULL OR _czasStop2 IS NULL) THEN
  RETURN 0;
 END IF;

 return max(0,(EXTRACT(epoch FROM min(_czasStop1,_czasStop2)-max(_czasStart1,_czasStart2))/3600)::NUMERIC);
END;
$$;
