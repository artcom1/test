CREATE TABLE tb_googlesynchronize (
    ggs_id integer DEFAULT nextval('tb_googlesynchronize_s'::regclass) NOT NULL,
    gga_id integer NOT NULL,
    ggs_calendarid text NOT NULL,
    ggs_eventid text NOT NULL,
    zd_idzdarzenia integer NOT NULL,
    ggs_lastsynchronized timestamp with time zone DEFAULT now() NOT NULL,
    ggs_flag integer DEFAULT 0 NOT NULL
);
