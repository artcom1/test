CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rc_idruchu ALIAS FOR $1;
 _in         ALIAS FOR $2;
BEGIN

 INSERT INTO gm.tg_rezstack
             (rc_idruchu,
	      tel_idelem_new,tel_idelem_old,
	      prt_idpartii_new,prt_idpartii_old,
	      rc_flaga_old,
	      rc_recver_old,rc_recver_new,
	      tex_idelem_new,tex_idelem_old
	     )
	VALUES
	     (_rc_idruchu,
	      _in.tel_idelem_new,_in.tel_idelem_old,
	      _in.prt_idpartii_new,_in.prt_idpartii_old,
	      _in.rc_flaga_old,
	      _in.rc_recver_old,_in.rc_recver_new,
	      _in.tex_idelem_new,_in.tex_idelem_old
	     );

 RETURN currval('gm.tg_rezstack_s');
END;
$_$;
