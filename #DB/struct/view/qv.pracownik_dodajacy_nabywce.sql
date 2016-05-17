CREATE VIEW pracownik_dodajacy_nabywce AS
 SELECT tb_pracownicy.p_idpracownika AS pracownik_dodajacy_nabywcy,
    tb_pracownicy.p_login AS login_dodajacy_nabywce,
    tb_pracownicy.p_imie AS imie_dodajacy_nabywce,
    tb_pracownicy.p_nazwisko AS nazwisko_dodajacy_nabywce
   FROM public.tb_pracownicy;
