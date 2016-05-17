CREATE TABLE tm_simulation (
    sim_id integer DEFAULT nextval('tm_simulation_s'::regclass) NOT NULL,
    sim_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    sim_simid integer NOT NULL,
    rc_idruchurez integer,
    rc_idruchupz integer NOT NULL,
    sim_iloscpz numeric DEFAULT 0 NOT NULL,
    sim_iloscrezn numeric DEFAULT 0 NOT NULL,
    sim_iloscrezl numeric DEFAULT 0 NOT NULL
);
