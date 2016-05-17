CREATE TABLE tb_zdarzeniaptlist (
    zdl_id integer DEFAULT nextval('tb_zdarzeniaptlist_s'::regclass) NOT NULL,
    zdp_id integer NOT NULL,
    szl_idstatusu integer,
    zdl_lp integer NOT NULL,
    zdl_flag integer DEFAULT 0 NOT NULL,
    zdl_ref_zdp_id integer
);
