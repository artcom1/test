CREATE VIEW wymiary_dzialy AS
 SELECT s.dz_iddzialu AS iddzialu_wymiaru,
    s.dz_nazwa AS nazwadzialu_wymiaru
   FROM public.ts_dzialy s;
