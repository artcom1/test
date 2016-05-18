CREATE VIEW wymiary_wagi AS
 SELECT s.wk_idwagi AS idwagiklienta_wymiaru,
    s.wk_opis AS nazwawagi_wymiaru
   FROM public.ts_wagiklienta s;
