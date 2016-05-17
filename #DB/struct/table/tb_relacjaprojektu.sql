CREATE TABLE tb_relacjaprojektu (
    ll_idrelacji integer DEFAULT nextval('tb_relacjaprojektu_s'::regclass) NOT NULL,
    pt_idetapu_src integer,
    pt_idetapu_dst integer,
    pt_idetapu_to integer,
    ll_idrelacji_src integer,
    ll_idrelacji_dst integer,
    ll_lp integer,
    zd_idzdarzenia_src integer,
    zd_idzdarzenia_dst integer,
    ll_poptype smallint,
    plt_id integer
);
