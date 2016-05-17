COMMENT ON COLUMN dodaj_rezerwacje_type.rc_ilosc IS 'Ilosc na ktora ma byc zalozona rezerwacja';


--
--

COMMENT ON COLUMN dodaj_rezerwacje_type.tel_idelem_for IS 'Transelem dla ktorego ma byc zalozona rezerwacja';


--
--

COMMENT ON COLUMN dodaj_rezerwacje_type._rezid IS 'Numer ktory znajdzie sie w rc_seqid utworzonej rezerwacji lub w polaczeniu z _onlywskazane SEQID rezerwacji ktora ma byc brana do liczenia ilosci';


--
--

COMMENT ON COLUMN dodaj_rezerwacje_type._nonewrezerwacja IS 'Jesli TRUE to nie zakladaj nowych rezerwacji, jedynie zmniejsz lub utrzymaj istniejace, jesli FALSE lub NULL zaloz rezerwacje na podana ilosc';
