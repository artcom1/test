CREATE TABLE ts_rodzajeodsetek (
    ros_idrodzaju integer DEFAULT nextval('ts_rodzajeodsetek_s'::regclass) NOT NULL,
    ros_nazwa text,
    ros_flaga integer DEFAULT 0 NOT NULL
);
