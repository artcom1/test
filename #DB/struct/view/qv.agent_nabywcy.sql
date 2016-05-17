CREATE VIEW agent_nabywcy AS
 SELECT tb_klient.k_idklienta AS agent_nabywcy,
    tb_klient.k_kod AS kod_agenta_nabywcy,
    tb_klient.k_nazwa AS nazwa_agenta_nabywcy
   FROM public.tb_klient;
