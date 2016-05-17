CREATE VIEW tv_vusers AS
 SELECT u.id,
    u.backend_pid,
    u.table_oid,
    u.p_idpracownika,
    u.winusersid,
    u.creation_date,
    COALESCE(u.appname, a.application_name) AS application_name
   FROM (tm_vusers u
     JOIN pg_stat_activity a ON ((a.pid = u.backend_pid)))
  WHERE (u.table_oid IN ( SELECT pg_class.oid
           FROM pg_class));
