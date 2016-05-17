CREATE TABLE tb_maps_gpshistory (
    gps_id integer NOT NULL,
    gps_date timestamp with time zone NOT NULL,
    gps_object_type integer NOT NULL,
    gps_object_id integer NOT NULL,
    gps_longitude double precision NOT NULL,
    gps_latitude double precision NOT NULL,
    gps_altitude integer,
    gps_heading double precision,
    gps_speed integer,
    gps_accuracy integer,
    gps_altitudeaccuracy integer
);
