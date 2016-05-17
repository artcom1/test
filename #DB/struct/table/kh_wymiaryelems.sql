CREATE TABLE kh_wymiaryelems (
    wme_idelemu integer DEFAULT nextval('kh_wymiary_s'::regclass) NOT NULL,
    wms_idwymiaru integer,
    wme_datatyperef integer,
    wme_idref integer,
    wme_nazwa text,
    wme_sumwn numeric DEFAULT 0,
    wme_summa numeric DEFAULT 0,
    wme_sumwnbuf numeric DEFAULT 0,
    wme_summabuf numeric DEFAULT 0,
    wme_isactive boolean DEFAULT true,
    wme_kod text
);
