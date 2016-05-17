CREATE VIEW pozycjepierwotnezam AS
 SELECT te.tel_idelem,
    te.tr_idtrans,
    te.tel_ilosc AS ilosc,
    te.tel_iloscf AS ilosc_magazynowa,
    te.tel_nazwa AS nazwa_pozycji,
    public.round(((te.tel_cenawal)::public.mpq OPERATOR(public.*) te.tel_kurswal), 2) AS cenatowaru,
    public.round(((public.getwartoscnetto(te.tel_ilosc, te.tel_cenawal, te.tel_cenabwal, te.tel_flaga, te.tel_stvat))::public.mpq OPERATOR(public.*) te.tel_kurswal), 2) AS wartoscsprzedazypln,
    public.getwartoscnetto(te.tel_ilosc, te.tel_cenadok, te.tel_cenabdok, te.tel_flaga, te.tel_stvat) AS wartoscsprzedazy,
    te.tel_narzut AS koszttrans,
    te.tel_kosztnabycia AS kosztnabycia,
    te.ttw_idtowaru,
    tg_transakcje.tr_datasprzedaz AS data1,
    te.tel_cecha AS cecha,
    tg_transakcje.tr_rodzaj AS rodzajdok,
    ((tg_transakcje.tr_zamknieta & 64) >> 6) AS wchodzidoplanoscidok,
    te.tel_kurswal AS kurswaluty,
    te.tel_walutawal AS wl_idwaluty,
    te.tel_cenawal AS cenawwalucie
   FROM (public.tg_transelem te
     JOIN public.tg_transakcje USING (tr_idtrans))
  WHERE ((tg_transakcje.tr_rodzaj = ANY (ARRAY[30, 31, 33])) AND ((tg_transakcje.tr_zamknieta & 1) = 1) AND (((te.tel_flaga & 1024) = 1024) OR ((te.tel_flaga & 32768) = 0)) AND (gmr.gettypzestawu(te.tel_new2flaga) <> ALL (ARRAY[1, 3])));
