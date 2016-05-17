CREATE TABLE tb_appcustomwindows (
    acw_id integer NOT NULL,
    acw_ownerid integer NOT NULL,
    acw_destopid text NOT NULL,
    acw_windowuri text NOT NULL,
    acw_instanceid text NOT NULL,
    acw_caption text,
    acw_sourceid integer
);
