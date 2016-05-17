CREATE VIEW rv AS
 SELECT ttm.ttm_wartosc,
    a.sw,
    ttm.ttm_stan,
    a.si,
    ttm.tmg_idmagazynu,
    ttm.ttm_idtowmag,
    tg_towary.ttw_klucz
   FROM ((tg_towmag ttm
     JOIN ( SELECT sum(tg_ruchy.rc_wartoscpoz) AS sw,
            sum(tg_ruchy.rc_iloscpoz) AS si,
            tg_ruchy.ttm_idtowmag
           FROM tg_ruchy
          WHERE ispzet(tg_ruchy.rc_flaga)
          GROUP BY tg_ruchy.ttm_idtowmag) a USING (ttm_idtowmag))
     JOIN tg_towary USING (ttw_idtowaru))
  WHERE ((ttm.ttm_wartosc <> a.sw) OR (a.si <> ttm.ttm_stan));
