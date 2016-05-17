CREATE FUNCTION minimalnawielkoscmozliwejkompletacjiwgzestawu(integer, integer, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 _typ ALIAS FOR $2; ----typ funkcji, jaki stan bierzemy pod uwage przy wyliczeniu 0 - stan rzeczywisty, 1 - stan handlowy, 2 - stan handlowy - zapotrzebowanie
 _tmg_idmagazyn ALIAS FOR $3;
 _fm_idcentrali ALIAS FOR $4;

 wynik NUMERIC:=0;
 receptura RECORD;
BEGIN
  
 IF (_tmg_idmagazyn<0) THEN
  return minimalnawielkoscmozliwejKompletacjiWgZestawuDlaCentrali(_ttw_idtowaru,_typ,_fm_idcentrali);
 END IF;

 IF (_typ=0) THEN --stan rzeczywisty
  wynik=(SELECT min(NullZero(ttm_stan)/sz_ilosc) FROM tg_skladnikizestawu AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=_tmg_idmagazyn) WHERE pr.ttw_idtowarusrc=_ttw_idtowaru AND sz_flaga&3=0);
 ELSE 
  IF (_typ=1) THEN --stan hanlowy
   wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja)/sz_ilosc) FROM tg_skladnikizestawu AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=_tmg_idmagazyn) WHERE pr.ttw_idtowarusrc=_ttw_idtowaru AND sz_flaga&3=0);
  ELSE 
   IF (_typ=2) THEN
    wynik=(SELECT min(NullZero(ttm_stan-ttm_rezerwacja-ttm_bkorderminus)/sz_ilosc) FROM tg_skladnikizestawu AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=_tmg_idmagazyn) WHERE pr.ttw_idtowarusrc=_ttw_idtowaru AND sz_flaga&3=0);

    IF (wynik<0) THEN ---jak ponizej zera to i tak zwracamy zero
     wynik=0;
    END IF;
    ---koniec dla ifa 2 
   END IF;
   ---koniec dla ifa 1
  END IF;
  ---koniec dla ifa 0
 END IF;

 RETURN wynik;
END;
$_$;
