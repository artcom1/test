CREATE VIEW pracownik_opiekun_nabywcy AS
 SELECT tb_pracownicy.p_idpracownika AS opiekun_nabywcy,
    tb_pracownicy.p_login AS login_opiekun_nabywcy,
    tb_pracownicy.p_imie AS imie_opiekun_nabywcy,
    tb_pracownicy.p_nazwisko AS nazwisko_opiekun_nabywcy
   FROM public.tb_pracownicy;
