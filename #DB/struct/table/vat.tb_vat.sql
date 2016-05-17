CREATE TABLE tb_vat (
    v_id integer DEFAULT nextval('tb_vat_s'::regclass) NOT NULL,
    v_nettokgo numeric NOT NULL,
    v_vatkgon numeric NOT NULL,
    v_vatkgob numeric NOT NULL,
    v_bruttokgo numeric NOT NULL,
    v_netnetto numeric NOT NULL,
    v_netvatn numeric NOT NULL,
    v_netvatb numeric NOT NULL,
    v_netbrutto numeric NOT NULL,
    v_netto numeric NOT NULL,
    v_vatn numeric NOT NULL,
    v_vatb numeric NOT NULL,
    v_brutto numeric NOT NULL,
    v_iloscpoz integer NOT NULL,
    v_iloscwyd numeric NOT NULL,
    v_ilosc0cena integer NOT NULL,
    v_iloscpozusl integer NOT NULL
)
INHERITS (tb_vat_b);
