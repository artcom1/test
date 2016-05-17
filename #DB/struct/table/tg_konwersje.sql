CREATE TABLE tg_konwersje (
    cv_idkonwersji integer DEFAULT nextval(('tg_konwersje_s'::text)::regclass) NOT NULL,
    cv_src integer,
    cv_dest integer,
    cv_srcrodzaj integer,
    cv_destrodzaj integer,
    cv_idprocesu integer DEFAULT 0,
    cv_flaga integer DEFAULT 0
);
