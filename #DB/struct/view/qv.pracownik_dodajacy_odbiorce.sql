CREATE VIEW pracownik_dodajacy_odbiorce AS
 SELECT tb_pracownicy.p_idpracownika AS pracownik_dodajacy_odbiorce,
    tb_pracownicy.p_login AS login_dodajacy_odbiorce,
    tb_pracownicy.p_imie AS imie_dodajacy_odbiorce,
    tb_pracownicy.p_nazwisko AS nazwisko_dodajacy_odbiorce
   FROM public.tb_pracownicy;
