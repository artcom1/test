CREATE VIEW khwalutyzapisow AS
 SELECT w.wl_idwaluty AS idwaluty_zapisu,
    w.nazwa_waluty,
    w.symbol_waluty
   FROM waluty w;


SET search_path = qvi, pg_catalog;
