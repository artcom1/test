CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 rrez tg_ruchy;
 r2 tg_ruchy;
BEGIN    
 RAISE EXCEPTION 'Wymiana %<>% w ilosci % ',idruchu1,idruchu2,ilosc;
 RETURN TRUE;
END;
$$;
