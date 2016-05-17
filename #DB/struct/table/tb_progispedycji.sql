CREATE TABLE tb_progispedycji (
    ps_idprogu integer DEFAULT nextval('tb_progispedycji_s'::regclass) NOT NULL,
    sp_idspedytora integer NOT NULL,
    ps_progleft numeric DEFAULT 0 NOT NULL,
    ps_kosztnetto numeric DEFAULT 0 NOT NULL,
    ttw_idtowaru integer,
    ps_rodzaj integer
);
