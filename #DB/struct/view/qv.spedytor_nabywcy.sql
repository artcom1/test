CREATE VIEW spedytor_nabywcy AS
 SELECT ts_spedycje.sp_idspedytora AS spedytor_nabywcy,
    ts_spedycje.sp_nazwa AS spedytor_nabywcy_nazwa
   FROM public.ts_spedycje;
