CREATE VIEW tv_kursywalut AS
 SELECT o.wl_idwaluty,
    COALESCE(i.kw_idkursu, i1.kw_idkursu) AS kw_idkursu,
    o.tw_idtabeli,
    COALESCE(i.kw_przelicznik, i1.kw_przelicznik) AS kw_przelicznik,
    COALESCE(i.kw_data, i1.kw_data) AS kw_data
   FROM ((( SELECT wl.wl_idwaluty,
            wl.wl_nazwa,
            wl.wl_skrot,
            t.tw_idtabeli,
            t.tw_nazwa,
            t.tw_flaga
           FROM tg_waluty wl,
            ts_tabelakursow t) o
     LEFT JOIN tg_kursywalut i ON (((o.wl_idwaluty = i.wl_idwaluty) AND (o.tw_idtabeli = i.tw_idtabeli) AND (i.kw_islast = true))))
     LEFT JOIN tg_kursywalut i1 ON (((o.wl_idwaluty = i1.wl_idwaluty) AND (1 = i1.tw_idtabeli) AND (i1.kw_islast = true) AND (i.kw_idkursu IS NULL))));
