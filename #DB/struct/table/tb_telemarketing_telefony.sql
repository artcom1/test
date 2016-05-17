CREATE TABLE tb_telemarketing_telefony (
    tlpr_id integer NOT NULL,
    tlpr_pra_idpracy integer NOT NULL,
    tlpr_kl_idklienta integer NOT NULL,
    tlpr_lk_idczklienta integer,
    tlpr_st_idstatusu integer,
    tlpr_phone text,
    tlpr_status text,
    tlpr_opis text
);
