CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rc_idruchu_src ALIAS FOR $1;
 _rc_idruchu_dst ALIAS FOR $2;
 _rc_recvertmp   ALIAS FOR $3;
 ---r RECORD;
BEGIN
  
 ---RAISE NOTICE 'Kopiuje stos z % do % (tmp %)',$1,$2,$3;

 INSERT INTO gm.tg_rezstack
              (rc_idruchu,
	       tel_idelem_new,tel_idelem_old,
	       prt_idpartii_new,prt_idpartii_old,
	       rc_flaga_old,
	       rc_recver_old,rc_recver_new,
	       tex_idelem_new,tex_idelem_old
	      )
 SELECT _rc_idruchu_dst,
        rs.tel_idelem_new,rs.tel_idelem_old,
	rs.prt_idpartii_new,rs.prt_idpartii_old,
	rs.rc_flaga_old,
	rs.rc_recver_old,(CASE WHEN rsc.rs_id IS NULL THEN COALESCE(_rc_recvertmp,r.rc_recver) ELSE rs.rc_recver_new END),
	rs.tex_idelem_new,rs.tex_idelem_old
 FROM tg_ruchy AS r,gm.tg_rezstack AS rs
 LEFT OUTER JOIN gm.tg_rezstack AS rsc ON (rsc.rc_idruchu=rs.rc_idruchu AND rsc.rc_recver_old=rs.rc_recver_new)
 WHERE rs.rc_idruchu=_rc_idruchu_src AND r.rc_idruchu=_rc_idruchu_dst;
          
 ---SELECT * INTO r FROM gm.tg_rezstack WHERE rc_idruchu=_rc_idruchu_dst;	   
 ---RAISE NOTICE 'Skopiowalem % ',r;
	       
 RETURN TRUE;
END;
$_$;
