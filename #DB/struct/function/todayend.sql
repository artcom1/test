CREATE FUNCTION todayend() RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN (SELECT (date_part('Year',now())||' '||date_part('Month',now())||' '||date_part('Day',now()))::date||' 23:59'));
END; $$;
