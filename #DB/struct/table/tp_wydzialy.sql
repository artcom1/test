CREATE TABLE tp_wydzialy (
    w_idwydzialu integer DEFAULT nextval(('tp_wydzialy_s'::text)::regclass) NOT NULL,
    w_kod text,
    w_nazwa text,
    w_narzut numeric DEFAULT 0
);
