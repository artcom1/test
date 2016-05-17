CREATE FUNCTION upewnijstan(integer, numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowmag ALIAS FOR $1;
 _stan ALIAS FOR $2;
 r RECORD;
 niedomiar NUMERIC;
 ile NUMERIC;
BEGIN
 
 niedomiar=(SELECT sum(rc_iloscpoz-(rc_iloscrez-rc_iloscrezzr)) FROM tg_ruchy WHERE isPZet(rc_flaga) AND NOT isBlockedPZ(rc_flaga) AND ttm_idtowmag=_idtowmag);
 niedomiar=_stan-niedomiar;
 IF (niedomiar<=0) THEN RETURN TRUE; END IF;

 FOR r IN SELECT rc_idruchu,rc_iloscrez FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND rc_iloscrez>0 AND ttm_idtowmag=_idtowmag ORDER BY rc_data DESC,rc_dataop DESC FOR UPDATE
 LOOP
  ile=min(r.rc_iloscrez,niedomiar);
  IF (ile=0) THEN RETURN TRUE; END IF;
  UPDATE tg_ruchy SET rc_iloscpoz=max(rc_iloscpoz-ile,rc_iloscrezzr) WHERE rc_idruchu=r.rc_idruchu;
  niedomiar=niedomiar-ile;
 END LOOP;

 RETURN TRUE;
END;
$_$;
