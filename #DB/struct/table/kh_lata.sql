CREATE TABLE kh_lata (
    ro_idroku integer DEFAULT nextval(('kh_lata_s'::text)::regclass) NOT NULL,
    ro_rok text NOT NULL,
    ro_start date DEFAULT now(),
    ro_end date DEFAULT now(),
    ro_closedto integer DEFAULT '-1'::integer,
    ro_syntzerosto integer DEFAULT 3,
    fm_idcentrali integer,
    ro_commrr boolean,
    ro_iswymiar boolean DEFAULT false,
    ro_rronallyear boolean DEFAULT false,
    ro_borozrachunkowe boolean DEFAULT true
);
