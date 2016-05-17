CREATE TABLE tb_proces (
    pc_idprocesu integer DEFAULT nextval(('tb_proces_s'::text)::regclass) NOT NULL,
    k_idklienta integer DEFAULT 0,
    pc_czegoprocesdot text NOT NULL,
    zi_idzrodla integer DEFAULT 0,
    pc_status text NOT NULL,
    pc_nic boolean DEFAULT true NOT NULL,
    pc_wartosc integer DEFAULT 0,
    pc_otwarty smallint DEFAULT 0,
    pc_datazamk date DEFAULT now(),
    pc_dataotw date DEFAULT now(),
    p_wlasciciel integer DEFAULT 0,
    pc_wnioski text DEFAULT ''::text,
    sc_idsciezki integer,
    sc_pozycjawsciezce integer
);
