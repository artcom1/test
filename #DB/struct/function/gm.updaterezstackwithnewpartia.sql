CREATE FUNCTION updaterezstackwithnewpartia(idruchu integer, idpartiiold integer, idpartiinew integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
 UPDATE gm.tg_rezstack SET prt_idpartii_new=(CASE WHEN prt_idpartii_new=idpartiiold THEN idpartiinew ELSE prt_idpartii_new END),
                           prt_idpartii_old=(CASE WHEN prt_idpartii_old=idpartiiold THEN idpartiinew ELSE prt_idpartii_old END)
		       WHERE rc_idruchu=idruchu;

 RETURN TRUE;
END;
$$;
