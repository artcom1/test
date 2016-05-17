CREATE VIEW wymiary_pracownicy AS
 SELECT tb_pracownicy.p_idpracownika AS idpracownika_wymiaru,
    tb_pracownicy.p_login AS login_pracownika_wymiaru,
    tb_pracownicy.p_imie AS imie_pracownika_wymiaru,
    tb_pracownicy.p_nazwisko AS nazwisko_pracownika_wymiaru
   FROM public.tb_pracownicy;
