CREATE VIEW wymiary_srodkitrwale AS
 SELECT st.str_id AS idsrodkatrwalego_wymiaru,
    st.str_nrinwent AS nrinwentarzowy_srodkatrwalego_wymiaru,
    st.str_nazwa AS nazwa_srodkatrwalego_wymiaru
   FROM public.st_srodkitrwale st;
