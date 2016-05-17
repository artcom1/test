CREATE VIEW raport_bielmar AS
 SELECT tmp.rok_sprzedazy,
    tmp.miesiac_sprzedazy,
    tmp.rok_miesiac_sprzedazy,
    n.k_kod AS kodnabywcy,
    n.k_nazwa AS nazwanabywcy,
    n.k_nip AS nipnabywcy,
    n.k_miejscowosc AS miejscowoscnabywcy,
    n.k_kodpocztowy AS kodpocztowynabywcy,
    n.k_ulica AS adresnabywcy,
    o.k_kod AS kododbiorcy,
    o.k_nazwa AS nazwaodbiorcy,
    o.k_nip AS nipodbiorcy,
    o.k_miejscowosc AS miejscowoscodbiorcy,
    o.k_kodpocztowy AS kodpocztowyodbiorcy,
    o.k_ulica AS adresodbiorcy,
    tg_towary.ttw_nazwa AS nazwatowaru,
    tg_towary.ttw_klucz AS kodtowaru,
    tmp.ilosctowaru,
    tmp.wartosc
   FROM (((( SELECT t.rok_sprzedazy,
            t.miesiac_sprzedazy,
            t.rok_miesiac_sprzedazy,
            t.k_idklienta,
            t.tr_oidklienta,
            t.ttw_idtowaru,
            sum(t.tel_iloscf) AS ilosctowaru,
            sum(t.tel_wartoscf) AS wartosc
           FROM ( SELECT date_part('year'::text, tg_transakcje.tr_datasprzedaz) AS rok_sprzedazy,
                    date_part('month'::text, tg_transakcje.tr_datasprzedaz) AS miesiac_sprzedazy,
                    (((date_part('year'::text, tg_transakcje.tr_datasprzedaz))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_transakcje.tr_datasprzedaz))::text)) AS rok_miesiac_sprzedazy,
                    tg_transakcje.k_idklienta,
                    tg_transakcje.tr_oidklienta,
                    tg_transelem.tel_iloscf,
                    tg_transelem.ttw_idtowaru,
                    getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) AS tel_wartoscf
                   FROM ((tg_transakcje
                     JOIN tg_transelem USING (tr_idtrans))
                     JOIN tg_towary tg_towary_1 USING (ttw_idtowaru))
                  WHERE (((tg_transakcje.tr_rodzaj = 1) OR (tg_transakcje.tr_rodzaj = 11) OR (tg_transakcje.tr_rodzaj = 7) OR (tg_transakcje.tr_rodzaj = 17)) AND (tg_towary_1.ttw_dostawca = 599) AND (tg_transakcje.tr_datasprzedaz >= '2006-04-01'::date))) t
          GROUP BY t.rok_sprzedazy, t.miesiac_sprzedazy, t.rok_miesiac_sprzedazy, t.k_idklienta, t.tr_oidklienta, t.ttw_idtowaru) tmp
     JOIN tb_klient n USING (k_idklienta))
     JOIN tb_klient o ON ((o.k_idklienta = tmp.tr_oidklienta)))
     JOIN tg_towary USING (ttw_idtowaru));
