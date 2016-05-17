CREATE TABLE ts_funkcjepracownikow (
    fps_idfunprac integer DEFAULT nextval('ts_funkcjepracownikow_s'::regclass) NOT NULL,
    fps_nazwa text
);
