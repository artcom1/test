CREATE FUNCTION oznacztowartechnologia(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN oznacztowartechnologia($1,$2,1);
END;
$_$;


--
--

CREATE FUNCTION oznacztowartechnologia(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _idtowaru ALIAS FOR $1;   	--- id towaru
 _typ ALIAS FOR $2;        	--- jezeli wieksze od zera - towar ma technologie
							--- 0 lub mniejsze - nie ma technologii
 _typ_techno ALIAS FOR $3; 	--- rodzaj technologii
							---  TECHNO_PRODUKCJA  = 1
							---  TECHNO_SERWIS     = 2
							---  TECHNO_BADANIA    = 3
 _ttw_bitflagi INT:=-1;
BEGIN

 IF (_typ_techno=1) THEN _ttw_bitflagi=0; END IF; --- Produkcja
 IF (_typ_techno=2) THEN _ttw_bitflagi=17; END IF; --- Serwis 
 IF (_typ_techno=3) THEN _ttw_bitflagi=18; END IF; --- Badania

 IF (_ttw_bitflagi<0) THEN
  RETURN 0;
 END IF;
 
 IF (_typ>0) THEN
  UPDATE tg_towary SET ttw_newflaga=(ttw_newflaga|(1<<_ttw_bitflagi)) WHERE ttw_idtowaru=_idtowaru AND (ttw_newflaga&(1<<_ttw_bitflagi))=0;
 ELSE
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga&(~(1<<_ttw_bitflagi)) WHERE ttw_idtowaru=_idtowaru AND (ttw_newflaga&(1<<_ttw_bitflagi))=(1<<_ttw_bitflagi);
 END IF;  

 RETURN 1;
END;
$_$;
