CREATE VIEW showcoll AS
 SELECT tm_simcoll.sc_id,
    tm_simcoll.sc_idpartiipz AS idp,
    tm_simcoll.rc_idruchupz AS idr,
    tm_simcoll.sc_idtowmag AS tm,
    tm_simcoll.sc_idmiejsca AS idmm,
    tm_simcoll.sc_iloscpoz AS ip,
    tm_simcoll.sc_ilosc[0] AS wz,
    tm_simcoll.sc_ilosc[1] AS rezc,
    tm_simcoll.sc_ilosc[2] AS rezl
   FROM tm_simcoll
  ORDER BY tm_simcoll.sc_idtowmag;
