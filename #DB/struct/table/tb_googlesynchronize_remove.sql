CREATE TABLE tb_googlesynchronize_remove (
    gsr_id integer DEFAULT nextval('tb_googlesynchronize_remove_s'::regclass) NOT NULL,
    gga_id integer NOT NULL,
    gsr_calendarid text NOT NULL,
    gsr_eventid text NOT NULL
);
