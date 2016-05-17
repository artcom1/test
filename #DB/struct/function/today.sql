CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN (SELECT (date_part('Year',now())||' '||date_part('Month',now())||' '||date_part('Day',now()))::date);
END; $$;
