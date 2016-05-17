CREATE TABLE tg_odsetki (
    os_idstawki integer DEFAULT nextval(('tg_odsetki_s'::text)::regclass) NOT NULL,
    os_datapoczatkowa date DEFAULT now(),
    os_datakoncowa date DEFAULT '2079-11-29'::date,
    os_stawka numeric DEFAULT 0,
    os_iloscdni integer DEFAULT 365,
    os_flaga smallint DEFAULT 0,
    ros_idrodzaju integer NOT NULL
);
