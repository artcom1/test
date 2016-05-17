CREATE TABLE tmp_viewspushed (
    id integer DEFAULT nextval('tmp_viewspushed_s'::regclass) NOT NULL,
    name text,
    def text
);
