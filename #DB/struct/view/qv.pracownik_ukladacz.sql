CREATE VIEW pracownik_ukladacz AS
 SELECT tb_pracownicy.p_idpracownika AS tr_pukladacz,
    tb_pracownicy.p_login AS login_ukladacz,
    tb_pracownicy.p_imie AS imie_ukladacz,
    tb_pracownicy.p_nazwisko AS nazwisko_ukladacz
   FROM public.tb_pracownicy;
