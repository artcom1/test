CREATE VIEW odsetki_ustawowe AS
 SELECT tg_odsetki.os_idstawki AS idodsetki,
    tg_odsetki.os_datapoczatkowa AS odsetki_datapoczatkowa,
    tg_odsetki.os_datakoncowa AS odsetki_datakoncowa,
    tg_odsetki.os_stawka AS odsetki_stawka
   FROM public.tg_odsetki
  WHERE (((tg_odsetki.os_flaga)::integer & 1) = 0);
