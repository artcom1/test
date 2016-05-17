CREATE TABLE kh_wzorceelfiltr (
    wf_idfiltru integer DEFAULT nextval(('kh_wzorceelfiltr_s'::text)::regclass) NOT NULL,
    we_idelementu integer,
    wz_idwzorca integer,
    wf_typ integer NOT NULL,
    ttw_idtowaru integer,
    wf_intvalue integer,
    wf_txtvalue text,
    wf_flaga integer DEFAULT 0
);
