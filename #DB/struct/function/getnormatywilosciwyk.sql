CREATE FUNCTION getnormatywilosciwyk(_wydajnosc numeric, _tpj numeric, _czas numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 wynik NUMERIC:=0;
BEGIN
 IF (_tpj!=0) THEN
  wynik=_wydajnosc*_czas;
  wynik=wynik/(_tpj/60);
  wynik=Round(wynik,4);
 END IF; 
 RETURN wynik;
END;
$$;


--
--

CREATE FUNCTION getnormatywilosciwyk(_wydajnosc numeric, _tpj numeric, _czasstart timestamp without time zone, _czasstop timestamp without time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN getNormatywIlosciWyk(_wydajnosc, _tpj, (EXTRACT(epoch FROM _czasStop-_czasStart)/3600)::NUMERIC);
END;
$$;
