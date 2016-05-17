CREATE TABLE kh_rejestrhead (
    rh_idrejestru integer DEFAULT nextval(('kh_rejestrhead_s'::text)::regclass) NOT NULL,
    rh_flaga integer DEFAULT 0,
    k_idklienta integer,
    rh_kadres text,
    rh_knazwa text,
    rh_nip text,
    rh_kkodpocz text,
    rh_kmiasto text,
    rh_pozycja integer,
    nr_idnazwy integer,
    ro_idroku integer,
    rh_formaplat smallint,
    rh_dataotrzymania date,
    rh_datawystaw date,
    rh_dataoperacji date,
    rh_dataplatnosci date,
    mn_miesiac integer,
    rh_koszt numeric DEFAULT 0,
    rh_brutto numeric DEFAULT 0,
    rh_vat numeric DEFAULT 0,
    rh_netto numeric DEFAULT 0,
    rh_numerdok text,
    tr_idtrans integer,
    rh_korekta text,
    rh_rodzaj integer,
    rh_skojlog integer,
    rh_transakcjavat integer,
    rh_opis text DEFAULT ''::text,
    rh_kursvat mpq DEFAULT '1'::mpq NOT NULL,
    rh_idwalutykursu integer DEFAULT 1 NOT NULL
);
