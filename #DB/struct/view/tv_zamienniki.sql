CREATE VIEW tv_zamienniki AS
 SELECT tg_zamiennikitow.zt_idzamiennika,
    tg_zamiennikitow.zt_idtowarusrc,
    tg_zamiennikitow.zt_idtowarudesc,
    tg_zamiennikitow.zt_przelicznik,
    false AS idodwrocony
   FROM tg_zamiennikitow
UNION
 SELECT tg_zamiennikitow.zt_idzamiennika,
    tg_zamiennikitow.zt_idtowarudesc AS zt_idtowarusrc,
    tg_zamiennikitow.zt_idtowarusrc AS zt_idtowarudesc,
    ((1)::numeric / tg_zamiennikitow.zt_przelicznik) AS zt_przelicznik,
    true AS idodwrocony
   FROM tg_zamiennikitow
  WHERE ((tg_zamiennikitow.zt_flaga & 1) = 1);
