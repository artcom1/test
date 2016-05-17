CREATE VIEW dokument_odbiorca AS
 SELECT tb_klient.k_idklienta AS tr_oidklienta,
    tb_klient.k_kod AS kod_odbiorcy,
    tb_klient.k_nazwa AS nazwa_odbiorcy,
    tb_klient.rj_idregionu AS region_odbiorcy,
    tb_klient.rk_idrodzajklienta AS grupa_odbiorcy,
    tb_klient.zi_idzrodla AS zrodlo_odbiorcy,
    tb_klient.sk_idstatusu AS status_odbiorcy,
    tb_klient.k_dostodb AS rodzaj_odbiorcy,
    tb_klient.sp_idspedytora AS spedytor_odbiorcy,
    tb_klient.p_idpracownika AS opiekun_odbiorcy,
    tb_klient.pw_idpowiatu AS kraj_odbiorcy,
    tb_klient.tgc_idgrupy AS grupacen_odbiorcy,
    tb_klient.p_dodajacy AS pracownik_dodajacy_odbiorce,
    tb_klient.k_datawpr AS data_wprowadzenia_odbiorcy,
    tb_klient.k_jegoagent AS agent_odbiorcy,
    tb_klient.k_kolor AS kolor_odbiorcy,
    tb_klient.k_geox AS geo_x_odbiorcy,
    tb_klient.k_geoy AS geo_y_odbiorcy,
    tb_klient.wk_idwagi AS grupa_ii_odbiorcy,
    tb_klient.k_potrzeby AS opinie_o_odbiorcy
   FROM public.tb_klient;


SET search_path = vendo, pg_catalog;
