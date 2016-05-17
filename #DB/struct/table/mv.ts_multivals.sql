CREATE TABLE ts_multivals (
    mvs_id integer DEFAULT nextval('mvmultivalues_s'::regclass) NOT NULL,
    mvs_datatypefor integer,
    mvs_podrodzajfor integer,
    mvs_inputtype integer,
    mvs_znaczenie integer,
    mvs_opis text,
    mvs_nzmiennej text,
    mvs_lp integer,
    mvs_dbfieldname text,
    mvs_isarray boolean,
    mvs_otherdbfields text[],
    mvs_ex_formatowaniedo integer,
    mvs_ex_idslownika integer,
    mvs_dbflagfield text,
    mvs_flaga integer DEFAULT 0,
    mvg_id integer DEFAULT getdefmvpage() NOT NULL,
    mvs_idslownikarozmiarowki integer,
    mvs_defaultvalue text
);
