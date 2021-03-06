CREATE VIEW dokument_nabywca AS
 SELECT tb_klient.k_idklienta AS tr_kidklienta,
    tb_klient.k_kod AS kod_nabywcy,
    tb_klient.k_nazwa AS nazwa_nabywcy,
    tb_klient.rj_idregionu AS region_nabywcy,
    tb_klient.rk_idrodzajklienta AS grupa_nabywcy,
    tb_klient.zi_idzrodla AS zrodlo_nabywcy,
    tb_klient.sk_idstatusu AS stutus_nabywcy,
    tb_klient.k_dostodb AS rodzaj_nabywcy,
    tb_klient.sp_idspedytora AS spedytor_nabywcy,
    tb_klient.p_idpracownika AS opiekun_nabywcy,
    tb_klient.pw_idpowiatu AS kraj_nabywcy,
    tb_klient.tgc_idgrupy AS grupacen_nabywcy,
    tb_klient.p_dodajacy AS pracownik_dodajacy_nabywcy,
    tb_klient.k_datawpr AS data_wprowadzenia_nabywcy,
    tb_klient.k_jegoagent AS agent_nabywcy,
    tb_klient.k_kolor AS kolor_nabywcy,
    tb_klient.k_geox AS geo_x_nabywcy,
    tb_klient.k_geoy AS geo_y_nabywcy,
    tb_klient.wk_idwagi AS grupa_ii_nabywcy,
    tb_klient.k_limitkredyt AS limit_kredytowy_nabywcy,
    tb_klient.k_kredytdni AS kredyt_dni_nabywcy,
    tb_klient.k_potrzeby AS opinie_o_nabywcy
   FROM public.tb_klient;
