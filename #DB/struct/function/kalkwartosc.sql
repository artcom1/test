CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 flaga ALIAS FOR $1;
 value ALIAS FOR $2;
BEGIN
 IF ((flaga&63)=0) OR ((flaga&63)=1) THEN
  RETURN value;
 END IF;
 IF ((flaga&63)=2) THEN
  RETURN (SELECT ttw_klucz FROM tg_towary WHERE ttw_idtowaru=value::int2);
 END IF;
 IF ((flaga&63)=3) THEN
  RETURN (SELECT es_text FROM tg_elslownika WHERE es_idelem=value::int2);
 END IF;
 IF ((flaga&63)=4) THEN
  RETURN (SELECT tb_nazwa FROM tg_tabele WHERE tb_idtabeli=value::int2);
 END IF;
 RETURN '';
END; $_$;
