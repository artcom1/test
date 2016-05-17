CREATE TABLE tg_ignorowaneeany (
    ie_ideanu integer DEFAULT nextval(('tg_ignorowaneeany_s'::text)::regclass) NOT NULL,
    ie_ean text,
    ie_opis text,
    ie_typ integer DEFAULT 0
);
