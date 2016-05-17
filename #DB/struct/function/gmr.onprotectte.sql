CREATE FUNCTION onprotectte() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ---Ustawiamy to czego nie chronimy
 flagmask INT:=(1<<4)|(1<<8);
 flag2mask INT:=(1<<22);----(1<<25);
 r RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (gm.istriggerfunctionactive('MARKTEASSAFEFORCHANGE',NEW.tel_idelem)=TRUE) THEN
   RAISE EXCEPTION '53|%|Niedozwolone dodanie chronionego rekordu',NEW.tel_idelem;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (
      NEW.tel_iloscpkor IS DISTINCT FROM OLD.tel_iloscpkor OR
	  NEW.tel_stvat IS DISTINCT FROM OLD.tel_stvat OR
	  NEW.tel_wartoscclo IS DISTINCT FROM OLD.tel_wartoscclo OR
	  NEW.tel_cenabdok IS DISTINCT FROM OLD.tel_cenabdok OR
	  NEW.tel_clo IS DISTINCT FROM OLD.tel_clo OR
	  ---NEW.tel_iloscwyd IS DISTINCT FROM OLD.tel_iloscwyd OR 
	  NEW.tel_rabatdb IS DISTINCT FROM OLD.tel_rabatdb OR
	  ---NEW.tel_kosztnabycia IS DISTINCT FROM OLD.tel_kosztnabycia OR
	  (NEW.tel_flaga&(~flagmask)) IS DISTINCT FROM (OLD.tel_flaga&(~flagmask)) OR
	  NEW.tel_ilosc IS DISTINCT FROM OLD.tel_ilosc OR
	  NEW.tel_cena0 IS DISTINCT FROM OLD.tel_cena0 OR
	  NEW.tel_cenawal IS DISTINCT FROM OLD.tel_cenawal OR
	  NEW.tel_walutawal IS DISTINCT FROM OLD.tel_walutawal OR
	  NEW.tel_cenadok IS DISTINCT FROM OLD.tel_cenadok OR
	  NEW.tjn_idjedn IS DISTINCT FROM OLD.tjn_idjedn OR
	  NEW.tel_iloscop IS DISTINCT FROM OLD.tel_iloscop OR
	  NEW.tjn_opakow IS DISTINCT FROM OLD.tjn_opakow OR
	  NEW.tel_grupacen IS DISTINCT FROM OLD.tel_grupacen OR
	  NEW.tel_skojarzony IS DISTINCT FROM OLD.tel_skojarzony OR
	  NEW.tel_kurswal IS DISTINCT FROM OLD.tel_kurswal OR
	  ---NEW.tel_koszt IS DISTINCT FROM OLD.tel_koszt OR
	  NEW.tel_skojlog IS DISTINCT FROM OLD.tel_skojlog OR
	  ---NEW.tel_idklienta IS DISTINCT FROM OLD.tel_idklienta OR
	  NEW.tel_nrzam IS DISTINCT FROM OLD.tel_nrzam OR
	  NEW.tel_cenabwal IS DISTINCT FROM OLD.tel_cenabwal OR
	  NEW.tel_cecha IS DISTINCT FROM OLD.tel_cecha OR
	  ---NEW.tel_lp IS DISTINCT FROM OLD.tel_lp OR
	  NEW.tel_iloscf IS DISTINCT FROM OLD.tel_iloscf OR
	  NEW.tel_kursdok IS DISTINCT FROM OLD.tel_kursdok OR
	  NEW.tel_narzut IS DISTINCT FROM OLD.tel_narzut OR
	  ---NEW.tel_ilosckomp IS DISTINCT FROM OLD.tel_ilosckomp OR
	  ---NEW.tel_wartosczakupu IS DISTINCT FROM OLD.tel_wartosczakupu OR
	  NEW.tel_uwagi IS DISTINCT FROM OLD.tel_uwagi OR
	  NEW.tel_nadmiarzam IS DISTINCT FROM OLD.tel_nadmiarzam OR
	  NEW.tel_zaokraglenia IS DISTINCT FROM OLD.tel_zaokraglenia OR
	  NEW.tel_datawazn IS DISTINCT FROM OLD.tel_datawazn OR
	  ---NEW.tel_oidklienta IS DISTINCT FROM OLD.tel_oidklienta OR
	  NEW.tel_newflaga IS DISTINCT FROM OLD.tel_newflaga OR
	  ---NEW.p_idpracownika IS DISTINCT FROM OLD.p_idpracownika OR
	  NEW.tel_skojzestaw IS DISTINCT FROM OLD.tel_skojzestaw OR
	  NEW.opk_idosrodka IS DISTINCT FROM OLD.opk_idosrodka OR
	  NEW.st_idstatusu IS DISTINCT FROM OLD.st_idstatusu OR
	  NEW.a_idakcji IS DISTINCT FROM OLD.a_idakcji OR
	  NEW.tel_wnettodok IS DISTINCT FROM OLD.tel_wnettodok OR
	  NEW.tel_wnettowal IS DISTINCT FROM OLD.tel_wnettowal OR
	  ---NEW.tel_datauklienta IS DISTINCT FROM OLD.tel_datauklienta OR
	  ---NEW.tel_iloscdorezerwacji IS DISTINCT FROM OLD.tel_iloscdorezerwacji OR
	  NEW.tel_przelnilosci IS DISTINCT FROM OLD.tel_przelnilosci OR
	  NEW.tel_przelnopakow IS DISTINCT FROM OLD.tel_przelnopakow OR
	  NEW.tel_opishtml IS DISTINCT FROM OLD.tel_opishtml OR
	  NEW.tel_cenakgodok IS DISTINCT FROM OLD.tel_cenakgodok OR
	  ---NEW.tel_lpprefix IS DISTINCT FROM OLD.tel_lpprefix OR
	  (NEW.tel_new2flaga&(~flag2mask)) IS DISTINCT FROM (OLD.tel_new2flaga&(~flag2mask)) OR
	  NEW.tel_iloscfresttoex IS DISTINCT FROM OLD.tel_iloscfresttoex OR
	  NEW.prt_idpartii IS DISTINCT FROM OLD.prt_idpartii OR
	  NEW.tel_nrpartii IS DISTINCT FROM OLD.tel_nrpartii OR
	  ---NEW.tel_datazam IS DISTINCT FROM OLD.tel_datazam OR
	  NEW.pz_idplanusrc IS DISTINCT FROM OLD.pz_idplanusrc OR
	  NEW.tel_cenanettods IS DISTINCT FROM OLD.tel_cenanettods OR
	  NEW.tel_walutads IS DISTINCT FROM OLD.tel_walutads OR
	  NEW.tel_cenanettoto IS DISTINCT FROM OLD.tel_cenanettoto OR
	  NEW.tel_walutato IS DISTINCT FROM OLD.tel_walutato OR
	  NEW.tel_procodlvat IS DISTINCT FROM OLD.tel_procodlvat OR
	  NEW.tel_dokladnoscflags IS DISTINCT FROM OLD.tel_dokladnoscflags OR
	  NEW.tel_skojzamtex IS DISTINCT FROM OLD.tel_skojzamtex OR
	  NEW.th_idtechnologii IS DISTINCT FROM OLD.th_idtechnologii OR
	  NEW.tel_iloscpotr IS DISTINCT FROM OLD.tel_iloscpotr OR
	  NEW.rmp_idsposobu IS DISTINCT FROM OLD.rmp_idsposobu 
     )
  THEN 
   IF (gm.istriggerfunctionactive('MARKTEASSAFEFORCHANGE',NEW.tel_idelem)=TRUE) THEN
    NEW.tel_flaga=NEW.tel_flaga&(~flagmask);
	OLD.tel_flaga=OLD.tel_flaga&(~flagmask);
    NEW.tel_new2flaga=NEW.tel_new2flaga&(~flag2mask);
	OLD.tel_new2flaga=OLD.tel_new2flaga&(~flag2mask);
	FOR r IN SELECT o.*,n.value AS newvalue FROM each(hstore(OLD)) AS o JOIN each(hstore(NEW)) AS n ON (n.key=o.key) WHERE o.value IS DISTINCT FROM n.value
	LOOP
	  RAISE NOTICE 'Changed: % (% -> %)',r.key,COALESCE(r.value::text,'<NULL>'),COALESCE(r.newvalue::text,'<NULL>');
	END LOOP;
    RAISE EXCEPTION '53|%|Niedozwolona zmiana na chronionym rekordzie',NEW.tel_idelem;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
