CREATE VIEW spedytor_odbiorcy AS
 SELECT ts_spedycje.sp_idspedytora AS spedytor_odbiorcy,
    ts_spedycje.sp_nazwa AS spedytor_nabywcy_nazwa
   FROM public.ts_spedycje;
