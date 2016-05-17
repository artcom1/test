CREATE FUNCTION getkursdladokumentu(integer, integer) RETURNS mpq
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _waluta ALIAS FOR $2;
 kurs MPQ;
BEGIN

 kurs=(SELECT tr_przelicznik FROM tg_transakcje WHERE tr_idtrans=_idtrans AND wl_idwaluty=_waluta);
 IF (kurs IS NOT NULL) THEN RETURN kurs; END IF;

 kurs=(SELECT kd_kurs FROM tg_kursdok WHERE tr_idtrans=_idtrans AND wl_idwaluty=_waluta);
 IF (kurs IS NOT NULL) THEN RETURN kurs; END IF;

 kurs=(SELECT tel_kurswal FROM tg_transelem WHERE tr_idtrans=_idtrans AND tel_walutawal=_waluta AND tel_flaga&1024=0 ORDER BY tel_lp ASC LIMIT 1);
 IF (kurs IS NOT NULL) THEN RETURN kurs; END IF;

 kurs=(SELECT kw_przelicznik FROM tg_kursywalut WHERE wl_idwaluty=_waluta AND tw_idtabeli=1 AND kw_islast=true);
 IF (kurs IS NOT NULL) THEN RETURN kurs; END IF;

 RETURN 1;
END
$_$;
