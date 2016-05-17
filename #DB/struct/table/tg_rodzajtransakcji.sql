CREATE TABLE tg_rodzajtransakcji (
    trt_idrodzaju integer DEFAULT nextval(('tg_rodzajtransakcji_s'::text)::regclass) NOT NULL,
    tr_rodzaj integer DEFAULT 0,
    trt_skrot character varying(5) DEFAULT ''::character varying,
    trt_ostseria character varying(4)
);
