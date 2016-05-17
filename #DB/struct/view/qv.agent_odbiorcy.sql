CREATE VIEW agent_odbiorcy AS
 SELECT tb_klient.k_idklienta AS agent_odbiorcy,
    tb_klient.k_kod AS kod_agenta_odbiorcy,
    tb_klient.k_nazwa AS nazwa_agenta_odbiorcy
   FROM public.tb_klient;
