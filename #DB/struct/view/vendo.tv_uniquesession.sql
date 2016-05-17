CREATE VIEW tv_uniquesession AS
 SELECT tm_vusers.id,
    tm_vusers.p_idpracownika,
    min(tm_vusers.backend_pid) AS backend_pid
   FROM tm_vusers
  GROUP BY tm_vusers.id, tm_vusers.p_idpracownika;
