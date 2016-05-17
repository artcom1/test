CREATE FUNCTION setncena(integer, integer, numeric, numeric, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN setncena($1,$2,$3,$4,$5,0,NULL);
END;
$_$;


--
--

CREATE FUNCTION setncena(integer, integer, numeric, numeric, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN setncena($1,$2,$3,$4,$5,$6,NULL);
END;
$_$;


--
--

CREATE FUNCTION setncena(integer, integer, numeric, numeric, integer, numeric, integer, integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru     ALIAS FOR $1;
 _idgrupycen   ALIAS FOR $2;
 _value        ALIAS FOR $3;
 _valuebrt     ALIAS FOR $4;
 _idwaluty     ALIAS FOR $5;
 _punkty       ALIAS FOR $6;
 _idpracownika ALIAS FOR $7;
 _dokladnosc   ALIAS FOR $8;
 cenabrt     NUMERIC;
 id           INT;
 isdefault    BOOL:=false;
BEGIN

 IF (_dokladnosc IS NULL) THEN
  _dokladnosc=(SELECT ttw_dokladnoscflags&15 FROM tg_towary WHERE ttw_idtowaru=_idtowaru);
 END IF;

 cenabrt=_valuebrt;
 IF (cenabrt IS NULL) THEN
  cenabrt=round(Net2Brt(_value,(SELECT ttw_vats FROM tg_towary WHERE ttw_idtowaru=_idtowaru)),_dokladnosc);
 END IF;

 id=(SELECT tcn_idceny FROM tg_ceny WHERE ttw_idtowaru=_idtowaru AND tgc_idgrupy=_idgrupycen);
 IF (id IS NULL) THEN
  IF ((SELECT count(*) FROM tg_ceny WHERE ttw_idtowaru=_idtowaru)=0) THEN
   isdefault=TRUE;
  END IF;
  INSERT INTO tg_ceny
   (ttw_idtowaru,tgc_idgrupy,tcn_value,tcn_valuebrt,tcn_idwaluty,tcn_isdefault,tcn_punkty,p_idpracownika,tcn_dokladnosc)
  VALUES
   (_idtowaru,_idgrupycen,_value,cenabrt,COALESCE(_idwaluty,1),isdefault,_punkty,_idpracownika,_dokladnosc);
  id=(SELECT currval('tg_ceny_s'));
 ELSE
  UPDATE tg_ceny SET tcn_value=_value,
                     tcn_valuebrt=cenabrt,
					 tcn_idwaluty=COALESCE(_idwaluty,tcn_idwaluty),
					 tcn_punkty=_punkty, 
					 p_idpracownika=_idpracownika,
					 tcn_dokladnosc=_dokladnosc
					 WHERE tcn_idceny=id;
 END IF;

 RETURN id;
END;
$_$;
