CREATE FUNCTION minimalnawielkoscmozliwejprodukcjiwgrec(integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tsk_idreceptury ALIAS FOR $1;
 _typ ALIAS FOR $2; ----typ funkcji, jaki stan bierzemy pod uwage przy wyliczeniu 0 - stan rzeczywisty, 1 - stan handlowy, 2 - stan handlowy - zapotrzebowanie

 wynik NUMERIC:=0;
 receptura RECORD;
BEGIN

  SELECT wyr.tsk_idreceptury AS tsk_idskladnika, wyr.tsk_ilosc INTO receptura FROM tg_produkcja AS wyr WHERE  wyr.tsk_idreceptury=_tsk_idreceptury;

  IF (receptura.tsk_idskladnika>0) THEN
   IF (_typ=0) THEN --stan rzeczywisty
    wynik=(SELECT min(NullZero(ttm_stan)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);
   ELSE 
    IF (_typ=1) THEN --stan hanlowy
     wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);
    ELSE 
     IF (_typ=2) THEN
      wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja-ttm_bkorderminus)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);

      IF (wynik<0) THEN ---jak ponizej zera to i tak zwracamy zero
       wynik=0;
      END IF;
     END IF;
    END IF;
   END IF;
  ELSE
   return NULL;
  END IF;

---  RAISE NOTICE 'dane %s, %s, %s',receptura.tsk_idskladnika,receptura.tsk_ilosc,wynik;
  RETURN wynik;
END;
$_$;


--
--

CREATE FUNCTION minimalnawielkoscmozliwejprodukcjiwgrec(integer, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 _fm_idcentrali ALIAS FOR $2;
 _typ ALIAS FOR $3; ----typ funkcji, jaki stan bierzemy pod uwage przy wyliczeniu 0 - stan rzeczywisty, 1 - stan handlowy, 2 - stan handlowy - zapotrzebowanie

 wynik NUMERIC:=0;
 receptura RECORD;
BEGIN

  SELECT nag.tsk_idskladnika, wyr.tsk_ilosc INTO receptura FROM tg_produkcja AS wyr JOIN tg_produkcja AS nag ON (nag.tsk_idskladnika=wyr.tsk_idreceptury) WHERE  ((nag.tsk_flaga&(3+512))=2) AND wyr.fm_idcentrali=_fm_idcentrali AND ((nag.tsk_flaga&64)=64) AND ((nag.tsk_flaga&48)=16) AND ( wyr.ttw_idtowaru=_ttw_idtowaru) AND ((wyr.tsk_flaga&(3+512))=1)  ORDER BY tsk_idskladnika;

  IF (receptura.tsk_idskladnika>0) THEN
   IF (_typ=0) THEN --stan rzeczywisty
    wynik=(SELECT min(NullZero(ttm_stan)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);
   ELSE 
    IF (_typ=1) THEN --stan hanlowy
     wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);
    ELSE 
     IF (_typ=2) THEN
      wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja-ttm_bkorderminus)*receptura.tsk_ilosc/tsk_ilosc) FROM tg_produkcja AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=pr.tmg_idmagazynu) WHERE tsk_idreceptury=receptura.tsk_idskladnika AND tsk_flaga&3=0);

      IF (wynik<0) THEN ---jak ponizej zera to i tak zwracamy zero
       wynik=0;
      END IF;
     END IF;
    END IF;
   END IF;
  ELSE
   return NULL;
  END IF;

---  RAISE NOTICE 'dane %s, %s, %s',receptura.tsk_idskladnika,receptura.tsk_ilosc,wynik;
  RETURN wynik;
END;
$_$;
