CREATE TABLE ts_wlascicielefirmy (
    wf_idwlasciciela integer DEFAULT nextval(('ts_wlascicielefirmy_s'::text)::regclass) NOT NULL,
    wf_nazwisko text,
    wf_imie text,
    wf_udzial numeric,
    wf_udzialmianownik numeric
);
