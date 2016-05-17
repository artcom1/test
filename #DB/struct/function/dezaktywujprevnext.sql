CREATE FUNCTION dezaktywujprevnext(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu        ALIAS FOR $1;  
 _knpn_idelem_org    INT;
 _record             RECORD;
 _return             INT:=0;
 
 _knpn_idelem_tmp  INT;
 
 _0_insert           BOOLEAN;
 _0_knpn_x_licznik   NUMERIC;
 _0_knpn_x_mianownik NUMERIC;
 _0_knpn_fromnext    NUMERIC;
 _0_knpn_x_wspc      NUMERIC;
 
 _4_insert           BOOLEAN;
 _4_knpn_x_licznik   NUMERIC;
 _4_knpn_x_mianownik NUMERIC;
 _4_knpn_fromnext    NUMERIC;
 _4_knpn_x_wspc      NUMERIC;
BEGIN

 FOR _record IN
 WITH
 _prev AS (SELECT _kwe_idelemu AS kwe_idelemu, knpn_flaga, knpn_idelem, kwe_idprev, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext FROM tr_kkwnodprevnext WHERE kwe_idnext=_kwe_idelemu),
 _next AS (SELECT _kwe_idelemu AS kwe_idelemu, knpn_flaga, knpn_idelem, kwe_idnext, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext FROM tr_kkwnodprevnext WHERE kwe_idprev=_kwe_idelemu) 
 SELECT
 2 AS kierunek,
 _prev.knpn_idelem      AS _prev_knpn_idelem,       _next.knpn_idelem      AS _next_knpn_idelem,
 kwe_idprev,                                        kwe_idnext, 
 _prev.knpn_flaga       AS _prev_knpn_flaga,        _next.knpn_flaga       AS _next_knpn_flaga,
 _prev.knpn_x_licznik   AS _prev_knpn_x_licznik,    _next.knpn_x_licznik   AS _next_knpn_x_licznik,
 _prev.knpn_x_mianownik AS _prev_knpn_x_mianownik,  _next.knpn_x_mianownik AS _next_knpn_x_mianownik,
 _prev.knpn_x_wspc      AS _prev_knpn_x_wspc,       _next.knpn_x_wspc      AS _next_knpn_x_wspc,
 _prev.knpn_fromnext    AS _prev_knpn_fromnext,     _next.knpn_fromnext    AS _next_knpn_fromnext
 FROM _prev
 CROSS JOIN _next
 UNION
 SELECT
 -1 AS kierunek,
 _prev.knpn_idelem      AS _prev_knpn_idelem,       NULL AS _next_knpn_idelem,
 kwe_idprev,                                        NULL AS kwe_idnext,
 _prev.knpn_flaga       AS _prev_knpn_flaga,        NULL AS _next_knpn_flaga,
 _prev.knpn_x_licznik   AS _prev_knpn_x_licznik,    NULL AS _next_knpn_x_licznik,
 _prev.knpn_x_mianownik AS _prev_knpn_x_mianownik,  NULL AS _next_knpn_x_mianownik,
 _prev.knpn_x_wspc      AS _prev_knpn_x_wspc,       NULL AS _next_knpn_x_wspc,
 _prev.knpn_fromnext    AS _prev_knpn_fromnext,     NULL AS _next_knpn_fromnext
 FROM _prev
 LEFT JOIN _next ON (_prev.kwe_idelemu=_next.kwe_idelemu) WHERE _next.kwe_idelemu IS NULL
 UNION
 SELECT
 1 AS kierunek,
 NULL AS _prev_knpn_idelem,       _next.knpn_idelem      AS _next_knpn_idelem,
 NULL AS kwe_idprev,              kwe_idnext,
 NULL AS _prev_knpn_flaga,        _next.knpn_flaga       AS _next_knpn_flaga,
 NULL AS _prev_knpn_x_licznik,    _next.knpn_x_licznik   AS _next_knpn_x_licznik,
 NULL AS _prev_knpn_x_mianownik,  _next.knpn_x_mianownik AS _next_knpn_x_mianownik,
 NULL AS _prev_knpn_x_wspc,       _next.knpn_x_wspc      AS _next_knpn_x_wspc,
 NULL AS _prev_knpn_fromnext,     _next.knpn_fromnext    AS _next_knpn_fromnext
 FROM _next
 LEFT JOIN _prev ON (_prev.kwe_idelemu=_next.kwe_idelemu) WHERE _prev.kwe_idelemu IS NULL
 
 LOOP
  _return=_return+1;
  --RAISE NOTICE '%. Dzialam na % Usuwam: %, %, %, %, %, %, (%)',
  --_return, _kwe_idelemu, _record._prev_knpn_idelem, _record._next_knpn_idelem, _record.kwe_idprev, _record.kwe_idnext, _record._prev_knpn_flaga, _record._next_knpn_flaga, _record.kierunek;

  -- 0 bit  (1) - Nastepnik nieaktywny
  -- 1 bit  (2) - Poprzednik nieaktywny
  -- 2,3,4 (28) - Rodzaj liczenia wagi galezi powiazania:
  --            0 - Liczenie od ilosci nastepnika
  --            4 - Liczenie od ilosci wyrobu
  -- 5     (32) - Powiazanie tymczasowe
 
  -- Dezaktywuje poprzednika
  IF (_record._prev_knpn_idelem IS NOT NULL) THEN
   IF ((_record._prev_knpn_flaga&(1<<5))=(1<<5)) THEN
    --RAISE NOTICE '%. Dzialam na % DELETE prev', _return, _kwe_idelemu;
    DELETE FROM tr_kkwnodprevnext WHERE knpn_idelem=_record._prev_knpn_idelem;
   ELSE
    --RAISE NOTICE '%. Dzialam na % UPDATE prev', _return, _kwe_idelemu;
    UPDATE tr_kkwnodprevnext SET knpn_flaga=knpn_flaga|((1<<0)|(1<<16)) WHERE knpn_idelem=_record._prev_knpn_idelem;
   END IF;
  END IF;
 
 -- Dezaktywuje nastepnika
  IF (_record._next_knpn_idelem IS NOT NULL) THEN
   IF ((_record._next_knpn_flaga&(1<<5))=(1<<5)) THEN
    --RAISE NOTICE '%. Dzialam na % DELETE next', _return, _kwe_idelemu;
    DELETE FROM tr_kkwnodprevnext WHERE knpn_idelem=_record._next_knpn_idelem;
   ELSE
    --RAISE NOTICE '%. Dzialam na % UPDATE next', _return, _kwe_idelemu;
    UPDATE tr_kkwnodprevnext SET knpn_flaga=knpn_flaga|((1<<1)|(1<<16)) WHERE knpn_idelem=_record._next_knpn_idelem;
   END IF;
  END IF;
   
  -- Tworze/updatuje tymczasowe powiazanie
  IF (
	  _record._prev_knpn_idelem IS NOT NULL AND
      _record._next_knpn_idelem IS NOT NULL AND 
	  (_record._prev_knpn_flaga&(1<<1))=0   AND
	  (_record._next_knpn_flaga&(1<<0))=0   AND
	  1=1
	 ) THEN

   _0_insert=FALSE;
   _4_insert=FALSE;

   IF (_record._prev_knpn_flaga&(7<<2)=(1<<2) AND _record._next_knpn_flaga&(7<<2)=(1<<2)) THEN -- obie relacje mam: Liczenie od ilosci wyrobu
                                                                                               -- a=a1, b=b1, c=c1, fn=fn1?
    --RAISE NOTICE '%. Dzialam na % INSERT new 4 4', _return, _kwe_idelemu;
    _4_knpn_x_licznik=   _record._prev_knpn_x_licznik;
    _4_knpn_x_mianownik= _record._prev_knpn_x_mianownik;
    _4_knpn_x_wspc=      _record._prev_knpn_x_wspc;
    _4_knpn_fromnext=    _record._prev_knpn_fromnext;
	_4_insert=TRUE;
   END IF;	

   IF (_record._prev_knpn_flaga&(7<<2)=(0<<2) AND _record._next_knpn_flaga&(7<<2)=(0<<2)) THEN -- obie relacje mam: Liczenie od ilosci nastepnika
                                                                                               -- a=a1*a2, b=b1*b2, c=c2, fn=fn1?
    --RAISE NOTICE '%. Dzialam na % INSERT new 0 0', _return, _kwe_idelemu;
    _0_knpn_x_licznik=   _record._prev_knpn_x_licznik*_record._next_knpn_x_licznik;
    _0_knpn_x_mianownik= _record._prev_knpn_x_mianownik*_record._next_knpn_x_mianownik;
    _0_knpn_x_wspc=      _record._next_knpn_x_wspc;
    _0_knpn_fromnext=    _record._prev_knpn_fromnext;
	_0_insert=TRUE;
   END IF;

   IF (_record._prev_knpn_flaga&(7<<2)=(0<<2) AND _record._next_knpn_flaga&(7<<2)=(1<<2)) THEN -- obie relacje mam rozne 0 4
   
    --RAISE NOTICE '%. Dzialam na % INSERT new 0 4', _return, _kwe_idelemu;
	_0_knpn_x_licznik=   _record._prev_knpn_x_licznik;
    _0_knpn_x_mianownik= _record._prev_knpn_x_mianownik;
    _0_knpn_x_wspc=      _record._prev_knpn_x_wspc;
    _0_knpn_fromnext=    _record._prev_knpn_fromnext;
	_0_insert=TRUE;

	_4_knpn_x_licznik=   _record._next_knpn_x_licznik;
    _4_knpn_x_mianownik= _record._next_knpn_x_mianownik;
    _4_knpn_x_wspc=      _record._next_knpn_x_wspc;
    _4_knpn_fromnext=    _record._next_knpn_fromnext;
	_4_insert=TRUE;
   END IF;
	
   IF (_record._prev_knpn_flaga&(7<<2)=(1<<2) AND _record._next_knpn_flaga&(7<<2)=(0<<2)) THEN -- obie relacje mam rozne 4 0
	
    --RAISE NOTICE '%. Dzialam na % INSERT new 4 0', _return, _kwe_idelemu;
	_0_knpn_x_licznik=   _record._next_knpn_x_licznik;
    _0_knpn_x_mianownik= _record._next_knpn_x_mianownik;
    _0_knpn_x_wspc=      _record._next_knpn_x_wspc;
    _0_knpn_fromnext=    _record._next_knpn_fromnext;
	_0_insert=TRUE;

	_4_knpn_x_licznik=   _record._prev_knpn_x_licznik;
    _4_knpn_x_mianownik= _record._prev_knpn_x_mianownik;
    _4_knpn_x_wspc=      _record._prev_knpn_x_wspc;
    _4_knpn_fromnext=    _record._prev_knpn_fromnext;
	_4_insert=TRUE;
   END IF;

   IF (_0_insert) THEN
    _knpn_idelem_tmp=NULL;
    _knpn_idelem_org=(SELECT knpn_idelem FROM tr_kkwnodprevnext WHERE kwe_idprev=_record.kwe_idprev AND kwe_idnext=_record.kwe_idnext AND (knpn_flaga&((7<<2)|(1<<5)))=((0<<2)|(0<<5)));
    IF (_knpn_idelem_org IS NOT NULL) THEN
     --RAISE NOTICE '%. Dzialam na % UPDATE 0 org %', _return, _kwe_idelemu, _knpn_idelem_org;
     UPDATE tr_kkwnodprevnext SET knpn_flaga=knpn_flaga|((3<<0)|(1<<16)) WHERE knpn_idelem=_knpn_idelem_org;
	 
	 INSERT INTO tr_kkwnodprevnext
	 ( kwe_idprev, kwe_idnext, knpn_flaga, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext )
	 ( SELECT kwe_idprev, kwe_idnext, ((1<<5)|(1<<16)), knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext FROM tr_kkwnodprevnext WHERE knpn_idelem=_knpn_idelem_org);	 
	 _knpn_idelem_tmp=( SELECT currval('tr_kkwnodprevnext_s') );
     --RAISE NOTICE '%. Dzialam na % INSERT 0 jak org %=>%', _return, _kwe_idelemu, _knpn_idelem_org, _knpn_idelem_tmp;
    END IF;
   
    IF (_knpn_idelem_tmp IS NULL) THEN
     _knpn_idelem_tmp=(SELECT knpn_idelem FROM tr_kkwnodprevnext WHERE kwe_idprev=_record.kwe_idprev AND kwe_idnext=_record.kwe_idnext AND (knpn_flaga&((7<<2)|(1<<5))=((0<<2)|(1<<5))));
	END IF;
	
    IF (_knpn_idelem_tmp IS NOT NULL) THEN
     --RAISE NOTICE '%. Dzialam na % UPDATE new 0: knpn_idelem=%, knpn_x_licznik+=%, knpn_x_mianownik+=%, knpn_x_wspc+=%, knpn_fromnext+=%', 
	 -- _return, _kwe_idelemu, _knpn_idelem_tmp, _0_knpn_x_licznik, _0_knpn_x_mianownik, _0_knpn_x_wspc, _0_knpn_fromnext;

     UPDATE tr_kkwnodprevnext SET 
	 knpn_x_licznik=COALESCE(num((knpn_x_licznik::mpq/knpn_x_mianownik)+(_0_knpn_x_licznik::mpq/_0_knpn_x_mianownik)),0),
	 knpn_x_mianownik=COALESCE(den((knpn_x_licznik::mpq/knpn_x_mianownik)+(_0_knpn_x_licznik::mpq/_0_knpn_x_mianownik)),1),
	 knpn_x_wspc=knpn_x_wspc+_0_knpn_x_wspc,
	 knpn_fromnext=knpn_fromnext+_0_knpn_fromnext
	 WHERE 
	 knpn_idelem=_knpn_idelem_tmp;    
	 
    ELSE
     --RAISE NOTICE '%. Dzialam na % INSERT new 0: kwe_idprev=%, kwe_idnext=%, knpn_flaga=%, knpn_x_licznik=%, knpn_x_mianownik=%, knpn_x_wspc=%, knpn_fromnext=%', 
	 --_return, _kwe_idelemu, _record.kwe_idprev, _record.kwe_idnext, (1<<5), _0_knpn_x_licznik, _0_knpn_x_mianownik, _0_knpn_x_wspc, _0_knpn_fromnext;
     INSERT INTO tr_kkwnodprevnext
     ( kwe_idprev, kwe_idnext, knpn_flaga, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext )
     VALUES
     ( _record.kwe_idprev, _record.kwe_idnext, ((1<<5)|(1<<16)), _0_knpn_x_licznik, _0_knpn_x_mianownik, _0_knpn_x_wspc, _0_knpn_fromnext );
	 
	 _knpn_idelem_tmp=( SELECT currval('tr_kkwnodprevnext_s') );
     --RAISE NOTICE '%. Dzialam na % INSERT 0 =>%', _return, _kwe_idelemu, _knpn_idelem_tmp;
    END IF;
   END IF;

   IF (_4_insert) THEN
    _knpn_idelem_tmp=NULL;
    _knpn_idelem_org=(SELECT knpn_idelem FROM tr_kkwnodprevnext WHERE kwe_idprev=_record.kwe_idprev AND kwe_idnext=_record.kwe_idnext AND (knpn_flaga&((7<<2)|(1<<5)))=((1<<2)|(0<<5)));
    IF (_knpn_idelem_org IS NOT NULL) THEN
     --RAISE NOTICE '%. Dzialam na % UPDATE 4 org %', _return, _kwe_idelemu, _knpn_idelem_org;
     UPDATE tr_kkwnodprevnext SET knpn_flaga=knpn_flaga|((3<<0)|(1<<16)) WHERE knpn_idelem=_knpn_idelem_org;
	 
	 INSERT INTO tr_kkwnodprevnext
	 ( kwe_idprev, kwe_idnext, knpn_flaga, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext )
	 ( SELECT kwe_idprev, kwe_idnext, ((1<<2)|(1<<5)|(1<<16)), knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext FROM tr_kkwnodprevnext WHERE knpn_idelem=_knpn_idelem_org);
	 
	 _knpn_idelem_tmp=( SELECT currval('tr_kkwnodprevnext_s') );
     --RAISE NOTICE '%. Dzialam na % INSERT 4 jak org %=>%', _return, _kwe_idelemu, _knpn_idelem_org, _knpn_idelem_tmp;
    END IF;
	
	IF (_knpn_idelem_tmp IS NULL) THEN
     _knpn_idelem_tmp=(SELECT knpn_idelem FROM tr_kkwnodprevnext WHERE kwe_idprev=_record.kwe_idprev AND kwe_idnext=_record.kwe_idnext AND (knpn_flaga&((7<<2)|(1<<5))=((1<<2)|(1<<5))));
	END IF;
	
    IF (_knpn_idelem_tmp IS NOT NULL) THEN
     --RAISE NOTICE '%. Dzialam na % UPDATE new 4: knpn_idelem=%, knpn_x_licznik+=%, knpn_x_mianownik+=%, knpn_x_wspc+=%, knpn_fromnext+=%', 
	 --_return, _kwe_idelemu, _knpn_idelem_tmp, _4_knpn_x_licznik, _4_knpn_x_mianownik, _4_knpn_x_wspc, _4_knpn_fromnext;

     UPDATE tr_kkwnodprevnext SET 
	 knpn_x_licznik=COALESCE(num((knpn_x_licznik::mpq/knpn_x_mianownik)+(_4_knpn_x_licznik::mpq/_4_knpn_x_mianownik)),0),
	 knpn_x_mianownik=COALESCE(den((knpn_x_licznik::mpq/knpn_x_mianownik)+(_4_knpn_x_licznik::mpq/_4_knpn_x_mianownik)),1),
	 knpn_x_wspc=knpn_x_wspc+_4_knpn_x_wspc,
	 knpn_fromnext=knpn_fromnext+_4_knpn_fromnext
	 WHERE 
	 knpn_idelem=_knpn_idelem_tmp;    
	 
    ELSE
     --RAISE NOTICE '%. Dzialam na % INSERT new 4: kwe_idprev=%, kwe_idnext=%, knpn_flaga=%, knpn_x_licznik=%, knpn_x_mianownik=%, knpn_x_wspc=%, knpn_fromnext=%',
	 --_return, _kwe_idelemu, _record.kwe_idprev, _record.kwe_idnext, ((1<<2)|(1<<5)), _4_knpn_x_licznik, _4_knpn_x_mianownik, _4_knpn_x_wspc, _4_knpn_fromnext;
     INSERT INTO tr_kkwnodprevnext
     ( kwe_idprev, kwe_idnext, knpn_flaga, knpn_x_licznik, knpn_x_mianownik, knpn_x_wspc, knpn_fromnext )
     VALUES
     ( _record.kwe_idprev, _record.kwe_idnext, ((1<<2)|(1<<5)|(1<<16)), _4_knpn_x_licznik, _4_knpn_x_mianownik, _4_knpn_x_wspc, _4_knpn_fromnext );
	 
	 _knpn_idelem_tmp=( SELECT currval('tr_kkwnodprevnext_s') );
     --RAISE NOTICE '%. Dzialam na % INSERT 4 =>%', _return, _kwe_idelemu, _knpn_idelem_tmp;
    END IF;
   END IF;
  END IF;
 END LOOP;

 RETURN _return;
END;
$_$;
