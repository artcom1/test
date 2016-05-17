CREATE VIEW tv_zdarzeniapowiazane AS
 SELECT tb_zdpowiazania.zp_idpowiazania,
    tb_zdpowiazania.zd_idzdarzenia AS zp_zdarzenie,
    tb_zdpowiazania.zp_idref AS zp_zdpowiazane
   FROM tb_zdpowiazania
  WHERE (tb_zdpowiazania.zp_datatype = 206)
UNION
 SELECT tb_zdpowiazania.zp_idpowiazania,
    tb_zdpowiazania.zp_idref AS zp_zdarzenie,
    tb_zdpowiazania.zd_idzdarzenia AS zp_zdpowiazane
   FROM tb_zdpowiazania
  WHERE (tb_zdpowiazania.zp_datatype = 206);
