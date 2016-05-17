CREATE VIEW wymiarywaluty AS
 SELECT w.wl_idwaluty AS idwaluty_wymiaru,
    w.nazwa_waluty AS nazwa_waluty_wymiaru,
    w.symbol_waluty AS symbol_waluty_wymiaru
   FROM waluty w;
