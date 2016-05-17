CREATE VIEW khv_obrotyroznice AS
 SELECT kt_idkonta,
    mc_miesiac,
    ob.wn AS obwn,
    kwe.wn AS kwewn,
    ob.ma AS obma,
    kwe.ma AS kwema
   FROM (khv_obrotyfromob ob
     FULL JOIN khv_obrotyfromkwe kwe USING (kt_idkonta, mc_miesiac))
  WHERE ((nullzero(ob.wn) <> nullzero(kwe.wn)) OR (nullzero(ob.ma) <> nullzero(kwe.ma)));
