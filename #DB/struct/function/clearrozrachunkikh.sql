CREATE FUNCTION clearrozrachunkikh(integer, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelzapisu ALIAS FOR $1;
 _wn ALIAS FOR $2;
BEGIN
 UPDATE kr_rozrachunki SET zp_idelzapisu=NULL WHERE zp_idelzapisu=_idelzapisu AND rr_iswn=_wn;
 RETURN TRUE;
END; $_$;
