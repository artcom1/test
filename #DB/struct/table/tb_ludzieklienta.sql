CREATE TABLE tb_ludzieklienta (
    lk_idczklienta integer DEFAULT nextval(('tb_ludzieklienta_s'::text)::regclass) NOT NULL,
    k_idklienta integer DEFAULT 0,
    zg_idzwrotu integer DEFAULT 0,
    lk_nazwisko text NOT NULL,
    lk_imie text NOT NULL,
    lk_tytulstanowisko text,
    lk_kobieta boolean DEFAULT false,
    lk_stanowisko text,
    wd_idwplywu integer DEFAULT 0,
    lk_ulica text NOT NULL,
    lk_nrlokalu text NOT NULL,
    lk_kodpocztowy text,
    lk_miejscowosc text NOT NULL,
    pw_idpowiatu integer DEFAULT 0,
    lk_telefon text DEFAULT ''::text,
    lk_email text,
    lk_hobby text,
    lk_opisogolny text,
    lk_uzyjadrpryw boolean DEFAULT true,
    lk_urodziny date,
    lk_imieniny date,
    lk_nrpaszportu text,
    lk_flaga smallint DEFAULT 0,
    lk_aktywny integer,
    lk_ileklientow integer DEFAULT 0
);
