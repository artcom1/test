CREATE TABLE tb_kompensatyhand (
    kh_idkompensaty integer DEFAULT nextval(('tb_kompensatyhand_s'::text)::regclass) NOT NULL,
    kh_ilosc numeric DEFAULT 0 NOT NULL,
    kh_idfaktury integer NOT NULL,
    kh_idkorekty integer NOT NULL
);
