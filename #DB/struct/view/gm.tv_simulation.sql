CREATE VIEW tv_simulation AS
 SELECT tm_simulation.sim_sid,
    tm_simulation.sim_simid,
    tm_simulation.rc_idruchupz,
    sum(tm_simulation.sim_iloscpz) AS sim_iloscpz,
    sum(tm_simulation.sim_iloscrezn) AS sim_iloscrezn,
    sum(tm_simulation.sim_iloscrezl) AS sim_iloscrezl
   FROM tm_simulation
  WHERE (tm_simulation.sim_sid = COALESCE(vendo.tv_mysessionpid(), '-1'::integer))
  GROUP BY tm_simulation.sim_sid, tm_simulation.sim_simid, tm_simulation.rc_idruchupz;
