CREATE VIEW tv_kursydok AS
 SELECT b.wl_idwaluty,
    getkursdladokumentu(b.tr_idtrans, b.wl_idwaluty) AS kurs,
    b.tr_idtrans,
    b.iloscpozycji
   FROM ( SELECT a.wl_idwaluty,
            a.tr_idtrans,
            sum(a.iloscpozycji) AS iloscpozycji
           FROM ( SELECT tr.wl_idwaluty,
                    tr.tr_idtrans,
                    0 AS iloscpozycji
                   FROM tg_transakcje tr
                UNION ALL
                 SELECT te.tel_walutawal,
                    te.tr_idtrans,
                    count(*) AS count
                   FROM tg_transelem te
                  WHERE ((te.tel_flaga & 1024) = 0)
                  GROUP BY te.tr_idtrans, te.tel_walutawal) a
          GROUP BY a.wl_idwaluty, a.tr_idtrans) b;
