CREATE VIEW powiazaniepozdokumentow AS
 SELECT r.tel_idelem AS idtranselemuwydania,
    rd.tel_idelem AS idtranselemudostawy,
    r.rc_ilosc AS ilosc,
    r.rc_wartosc AS wartosc
   FROM (public.tg_ruchy r
     JOIN public.tg_ruchy rd ON ((rd.rc_idruchu = r.rc_dostawa)))
  WHERE public.isfv(r.rc_flaga);
