CREATE VIEW pracownik_handlowiec AS
 SELECT tb_pracownicy.p_idpracownika AS tr_phadlowiec,
    tb_pracownicy.p_login AS login_handlowiec,
    tb_pracownicy.p_imie AS imie_handlowiec,
    tb_pracownicy.p_nazwisko AS nazwisko_handlowiec
   FROM public.tb_pracownicy;
