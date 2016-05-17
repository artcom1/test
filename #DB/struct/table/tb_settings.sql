CREATE TABLE tb_settings (
    stt_id integer NOT NULL,
    stt_sts_id integer NOT NULL,
    stt_ownertype integer DEFAULT 0 NOT NULL,
    stt_ownerid text NOT NULL,
    stt_name text NOT NULL,
    stt_value text NOT NULL,
    stt_valuehash text,
    stt_lastchanged timestamp with time zone DEFAULT now() NOT NULL,
    stt_flag integer DEFAULT 0 NOT NULL
);
