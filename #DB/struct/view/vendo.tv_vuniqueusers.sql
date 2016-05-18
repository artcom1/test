CREATE VIEW tv_vuniqueusers AS
 SELECT tv_vusers.id,
    tv_vusers.p_idpracownika,
    min(tv_vusers.backend_pid) AS backend_pid
   FROM tv_vusers
  GROUP BY tv_vusers.id, tv_vusers.p_idpracownika;
