CREATE VIEW pracownik_opiekun_odbiorcy AS
 SELECT tb_pracownicy.p_idpracownika AS opiekun_odbiorcy,
    tb_pracownicy.p_login AS login_opiekun_odbiorcy,
    tb_pracownicy.p_imie AS imie_opiekun_odbiorcy,
    tb_pracownicy.p_nazwisko AS nazwisko_opiekun_odbiorcy
   FROM public.tb_pracownicy;
