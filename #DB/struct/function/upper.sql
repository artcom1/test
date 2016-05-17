CREATE FUNCTION upper(boolean) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $_$BEGIN RETURN $1; END;$_$;


--
--

CREATE FUNCTION upper(double precision) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$BEGIN RETURN $1; END;$_$;


--
--

CREATE FUNCTION upper(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$BEGIN RETURN $1; END;$_$;


--
--

CREATE FUNCTION upper(bigint) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$BEGIN RETURN $1; END;$_$;


--
--

CREATE FUNCTION upper(numeric) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$BEGIN RETURN $1; END;$_$;
