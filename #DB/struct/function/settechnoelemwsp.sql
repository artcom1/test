CREATE FUNCTION settechnoelemwsp(integer, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtechnologii   ALIAS FOR $1;
 _idtechnoelem    ALIAS FOR $2;
 _wsp             ALIAS FOR $3;
 id		  INT;
BEGIN

 id=(SELECT knwp_idwspolczynnika FROM tr_technoelemwsp WHERE the_idelem=_idtechnoelem );
 IF (id IS NULL) THEN
  INSERT INTO tr_technoelemwsp
   (th_idtechnologii, the_idelem, knwp_wspolczynik)
  VALUES
   (_idtechnologii,_idtechnoelem,round(_wsp,0));
 ELSE
  UPDATE tr_technoelemwsp SET knwp_wspolczynik=knwp_wspolczynik+round(_wsp,0) WHERE knwp_idwspolczynnika=id;
 END IF;

 RETURN id;
END;
$_$;
