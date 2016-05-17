CREATE FUNCTION oznacztowarstruktura(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ----funkcja zaznacza lub anuluje oznaczenie zamiennika na karcie towaru
 _idtowaru ALIAS FOR $1; ---id towaru
 _typ ALIAS FOR $2; ----jezeli wieksze od zera to towar ma strukture, 0 lub ujemne ze nie ma struktury
BEGIN

 IF (_typ>0) THEN
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga|(1<<15) WHERE ttw_idtowaru=_idtowaru AND ttw_newflaga&(1<<15)=0;
 ELSE
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga&(~((1<<15))) WHERE ttw_idtowaru=_idtowaru AND ttw_newflaga&(1<<15)<>0;
 END IF;

 RETURN 1;
END
$_$;
