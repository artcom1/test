CREATE VIEW towary AS
 SELECT tg_towary.ttw_idtowaru,
    tg_towary.ttw_klucz,
    tg_towary.ttw_nazwa,
    tg_towary.ttw_waga,
    tg_towary.tgr_idgrupy,
    tg_towary.tpg_idpodgrupy,
    tg_towary.tjn_idjedn,
    tg_towary.ttw_aktywny,
    tg_towary.ttw_datawpr,
    tg_towary.ttw_dataostmod,
    tg_towary.ttw_koddost AS kod_u_dostawcy,
    tg_towary.ttw_ean AS ean,
    tg_towary.tgw_idgrupy,
    public.nazwagrupy3tow((tg_towary.ttw_flaga & 6291456)) AS grupaiii,
    public.nazwachodliwosc((tg_towary.ttw_flaga & 98304)) AS chodliwosc1,
    public.nazwachodliwosc2((tg_towary.ttw_flaga & 6291456)) AS chodliwosc2,
    public.getrodzajkartytowaru(tg_towary.ttw_flaga, tg_towary.ttw_usluga) AS rodzajkartytowarowej
   FROM public.tg_towary;
