CREATE FUNCTION kolejnawartoscsekwencji(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _id ALIAS FOR $1;
 _wartosc INTEGER;
BEGIN
 _wartosc = (SELECT skw_wartosc FROM tc_sekwencje WHERE skw_id=_id FOR UPDATE);

 IF (_wartosc IS NOT NULL) THEN
  _wartosc = _wartosc + 1;
  UPDATE tc_sekwencje SET skw_wartosc=_wartosc WHERE skw_id=_id;
 END IF;

 RETURN _wartosc;
END;
$_$;


--
--

CREATE FUNCTION kolejnawartoscsekwencji(integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rodzaj ALIAS FOR $1;
 _klucz ALIAS FOR $2;
 _id INTEGER;
BEGIN
 _id = (SELECT skw_id FROM tc_sekwencje WHERE skw_rodzaj=_rodzaj AND skw_klucz=_klucz);

 IF (_id IS NULL) THEN
  RETURN NULL;
 END IF;

 RETURN (SELECT KolejnaWartoscSekwencji(_id));
END;
$_$;
