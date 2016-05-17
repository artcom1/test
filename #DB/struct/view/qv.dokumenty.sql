CREATE VIEW dokumenty AS
 SELECT tr.tr_idtrans,
    tr.tr_datasprzedaz AS datasprzedazy,
    date_part('year'::text, tr.tr_datasprzedaz) AS rok_sprzedazy,
    date_part('month'::text, tr.tr_datasprzedaz) AS miesiac_sprzedazy,
    date_part('week'::text, tr.tr_datasprzedaz) AS tydzien_sprzedazy,
    date_part('day'::text, tr.tr_datasprzedaz) AS dzien_sprzedazy,
    tr.tr_datawystaw AS datawystawienia,
    date_part('year'::text, tr.tr_datawystaw) AS rok_wystawienia,
    date_part('month'::text, tr.tr_datawystaw) AS miesiac_wystawienia,
    date_part('week'::text, tr.tr_datawystaw) AS tydzien_wystawienia,
    date_part('day'::text, tr.tr_datawystaw) AS dzien_wystawienia,
    ((date_part('year'::text, tr.tr_datasprzedaz) || '.'::text) || public.uzupelnijmiesiac((date_part('month'::text, tr.tr_datasprzedaz))::text)) AS rok_miesiac_sprzedaz,
    ((date_part('year'::text, tr.tr_datawystaw) || '.'::text) || public.uzupelnijmiesiac((date_part('month'::text, tr.tr_datawystaw))::text)) AS rok_miesiac_wystawienia,
        CASE
            WHEN (tr.tr_infix IS NULL) THEN ("substring"(((((((tr.tr_numer || '/'::text) || btrim((tr.tr_seria)::text)) || '/'::text) || (tr.tr_rok)::text) || '/'::text) || tm_rodzajeinfo.tr_skrot), 0, 50))::character varying(50)
            ELSE ("substring"(((((((((tr.tr_numer || '/'::text) || btrim((tr.tr_seria)::text)) || '/'::text) || tr.tr_infix) || '/'::text) || (tr.tr_rok)::text) || '/'::text) || tm_rodzajeinfo.tr_skrot), 0, 50))::character varying(50)
        END AS numerdokumentu,
    ("substring"(btrim((tr.tr_seria)::text), 0, 8))::character varying(8) AS seria,
    ("substring"(tr.tr_nrobcy, 0, 40))::character varying(40) AS numerobcy,
    tr.tr_rodzaj AS rodzajdokumentu,
    public.dokumentkorekta(tr.tr_rodzaj) AS dokumentkorekta,
    tr.k_idklienta AS tr_kidklienta,
    tr.tr_oidklienta,
    tr.p_idpracownika AS tr_pidwystawiajacy,
    tr.tr_zaliczonedla AS tr_phadlowiec,
    tr.tr_zaliczonoukl AS tr_pukladacz,
    tr.sp_idspedytora AS tr_idspedytora,
    tr.tmg_idmagazynu AS tr_idmagazynu,
    tr.tr_przelicznik AS tr_kurswaluty,
    tr.tr_wartosc AS tr_wartoscnetto,
    tr.tr_dozaplaty AS tr_wartoscbrutto,
    tr.wl_idwaluty,
    tr.tr_sprzedaz AS wplywnamagazyn,
    tr.fm_idcentrali AS indexcentrali,
    (tr.tr_zamknieta & 1) AS dokumentzamkniety,
    tr.fm_index AS oddzialdokumentu,
    tr.tr_kosztkraj AS transportkraj,
    tr.tr_kosztzag AS transportzag,
    ((tr.tr_zamknieta & 64) >> 6) AS wchodzidoplanosci,
    tm_rodzajeinfo.tr_skrot AS skrotdokumentu
   FROM (public.tg_transakcje tr
     JOIN vendo.tm_rodzajeinfo USING (tr_rodzaj))
  WHERE ((tr.tr_zamknieta & 1) = 1);
