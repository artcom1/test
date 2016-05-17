CREATE FUNCTION blockpzet(integer, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN

 IF ($2=TRUE) THEN
  PERFORM vendo.setTParam('BLOCKREZSEARCH',(COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')::int+1)::text);
  UPDATE tg_ruchy SET rc_flaga=rc_flaga|(1<<20) WHERE rc_idruchu=$1;
 ELSE
  PERFORM vendo.setTParam('BLOCKREZSEARCH',(COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')::int-1)::text);
  UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~(1<<20)) WHERE rc_idruchu=$1;
 END IF;

 RETURN TRUE;
END
$_$;
