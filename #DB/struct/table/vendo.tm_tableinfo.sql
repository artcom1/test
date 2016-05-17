CREATE TABLE tm_tableinfo (
    tid_datatype integer,
    tid_tablename text,
    tid_tablepkey text,
    tim_hasmultivalues boolean DEFAULT false,
    tim_hasstatuses boolean DEFAULT false,
    tim_version smallint DEFAULT 0,
    tim_hasrecchanges boolean DEFAULT false,
    tim_hasautonotifies boolean DEFAULT false
);
