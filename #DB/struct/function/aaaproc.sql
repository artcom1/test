CREATE FUNCTION aaaproc() RETURNS opaque
    LANGUAGE plpgsql
    AS $$BEGIN; RETURN NEW; $$;
