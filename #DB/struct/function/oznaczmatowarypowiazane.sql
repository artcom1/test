CREATE FUNCTION oznaczmatowarypowiazane(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ----funkcja zaznacza lub anuluje oznaczenie czy towar posiada towary powiazane
 _idtowaru ALIAS FOR $1; ---id towaru
 _typ ALIAS FOR $2; ----jezeli wieksze od zera to towar ma towary powiazane, 0 lub ujemne ze nie ma towarow powiazanych
BEGIN

 IF (_typ>0) THEN
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga|(1<<12) WHERE ttw_idtowaru=_idtowaru;
 ELSE
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga&(~(1<<12)) WHERE ttw_idtowaru=_idtowaru;
 END IF;

 RETURN 1;
END
$_$;
