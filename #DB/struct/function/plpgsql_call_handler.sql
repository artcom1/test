CREATE OR REPLACE FUNCTION 
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';
