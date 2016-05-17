CREATE VIEW tv_mysession AS
 SELECT tv_vusers.id,
    tv_vusers.backend_pid,
    tv_vusers.table_oid,
    tv_vusers.p_idpracownika
   FROM tv_vusers
  WHERE (tv_vusers.backend_pid = pg_backend_pid());
