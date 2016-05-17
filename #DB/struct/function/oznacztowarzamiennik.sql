CREATE FUNCTION oznacztowarzamiennik(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ----funkcja zaznacza lub anuluje oznaczenie zamiennika na karcie towaru
 _idtowaru ALIAS FOR $1; ---id towaru
 _typ ALIAS FOR $2; ----jezeli wieksze od zera to towar ma zamiennik, 0 lub ujemne ze nie ma zamiennika
BEGIN

 IF (_typ>0) THEN
  UPDATE tg_towary SET ttw_flaga=ttw_flaga|(1<<31) WHERE ttw_idtowaru=_idtowaru;
 ELSE
  UPDATE tg_towary SET ttw_flaga=ttw_flaga&(~(1<<31)) WHERE ttw_idtowaru=_idtowaru;
 END IF;

 RETURN 1;
END
$_$;
