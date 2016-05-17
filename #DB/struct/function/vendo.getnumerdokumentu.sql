CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN vendo.getNumerDokumentu($1,$2,NULL,$3,$4);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN vendo.getNumerDokumentu($1,$2,$3,$4,$5,NULL);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN COALESCE($1,0)||
        '/'||trim($2)||
		(CASE WHEN COALESCE($3,'')='' THEN '' ELSE '/'||$3 END)||
		'/'||mylpad($4,2,'0')||
		'/'||vendo.getSkrotRodzajuTransakcji($5)||
		(CASE WHEN $6 IS NULL THEN '' ELSE '/'||$6 END)
		; --''
END;
$_$;
