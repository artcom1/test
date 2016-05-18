COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
--

COMMENT ON EXTENSION pgmp IS 'Multiple Precision Arithmetic extension';


--
--

COMMENT ON EXTENSION vendo IS 'Funkcje vendo';



--
--

COMMENT ON COLUMN tr_kkwhead.kwh_norma_rbh_oczek IS 'Norma rbh na ilosc oczekiwana (ile h mam robic ilosc oczekiwana)';


--
--

COMMENT ON COLUMN tr_kkwhead.kwh_norma_rbh_wyk IS 'Norma rbh na ilosc wykonana (ile h mialem robic ilosc wykonana)';


--
--

COMMENT ON COLUMN tr_kkwhead.kwh_norma_mh_oczek IS 'Norma mh na ilosc oczekiwana (ile h mam robic ilosc oczekiwana)';


--
--

COMMENT ON COLUMN tr_kkwhead.kwh_norma_mh_wyk IS 'Norma mh na ilosc wykonana (ile h mialem robic ilosc wykonana)';


--
--

COMMENT ON COLUMN tr_kkwhead.kwh_wykonanemh IS 'Ilosc wykonana mh';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.knr_idelemu_idx IS 'Indeks w arrayu rozmiarowkowym';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.rmp_idsposobu IS 'Sposob pakowania sluzy jedynie do tworzenia pozycji Przedstawia pakowania arraya pozostalo do wydania';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.dmag_ilosc IS 'Ilosc awizowana';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.dmag_iloscwmag IS 'Ilosc przeniesiona na magazyn (dokumentem)';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.dmag_iloscwmagclosed IS 'Ilosc przeniesiona na magazyn (dokumentem zamknietym)';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.dmag_typ IS 'Typ dyspozycji: 1: RW, 2: PW, 3: Wyrob, 4: Narzedzia+, 5: Zamowienie, 6: Narzedzia-';


--
--

COMMENT ON COLUMN tr_dyspozycjamag.dmag_serialno IS 'Numer seryjny, przenoszony do partii przy tworzeniu dysp+partia';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_rbh_wyk IS 'Norma rbh na ilosc wykonana (suma z kkw podpietych do pozycji)';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_rbh_roz IS 'Norma rbh na ilosc rozplanowana (suma z kkw podpietych do pozycji)';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_mh_wyk IS 'Norma mh na ilosc wykonana (suma z kkw podpietych do pozycji)';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_mh_roz IS 'Norma mh na ilosc rozplanowana (suma z kkw podpietych do pozycji)';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_rbh_wyk_podrz IS 'Norma rbh na ilosc wykonana (suma z pozycji podrzednych) z uwzglednieniem proporcji ilosci rozplanowanej do ilosci planowanej';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_rbh_roz_podrz IS 'Norma rbh na ilosc rozplanowana (suma z pozycji podrzednych)  z uwzglednieniem proporcji ilosci rozplanowanej do ilosci planowanej';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_mh_wyk_podrz IS 'Norma mh na ilosc wykonana (suma z pozycji podrzednych)  z uwzglednieniem proporcji ilosci rozplanowanej do ilosci planowanej';


--
--

COMMENT ON COLUMN tg_planzlecenia.pz_kkw_norma_mh_roz_podrz IS 'Norma mh na ilosc rozplanowana (suma z pozycji podrzednych)  z uwzglednieniem proporcji ilosci rozplanowanej do ilosci planowanej';


--
--

COMMENT ON COLUMN tg_ppheadelem.tel_idelemsrcskoj IS 'ID transelemu podindeksu dla ktorego jest to przepakowanie (plusowe)';


--
--

COMMENT ON COLUMN tg_ppheadelem.phe_docclosed IS 'Informacja o tym czy dokument do ktorego nalezy element jest zamkniety czy nie';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_if_pierw IS 'IloscF pierwotna na zamowieniu lub iloscf z uwzglednieniem korekt dla innych dokumentow';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_if_reserved IS 'IloscF zarezerwowana (obecnie)';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_if_waitingtoreserve IS 'IloscF rezerwacji w przyszlosc';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_rtowaru IS 'eRTowaru towaru';


--
--

COMMENT ON COLUMN tg_zamilosci.tel_skojzestaw IS 'ID naglowka zestawu ze zrodlowego transelemu';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_tepos IS 'Typ zrodlowej pozycji dokumentu (bity 15-20 z tg_transelem.tel_new2flaga >> 15)';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_wplyw IS 'Kierunek z dokumentu zrodlowego (-1: likeSprzedaz, 1: likeZakup)';


--
--

COMMENT ON COLUMN tg_zamilosci.zmi_if_inprzepakowanie IS 'IloscF w niezamknietym przepakowaniu dodatnim';


--
--

COMMENT ON TABLE tm_volatiles IS 'Tabela do przechowywania danych ktore moga byc usuniete/niedostepne w biezacej wersji a byly w poprzedniej (np. dane o skryptach,pluginach)';
