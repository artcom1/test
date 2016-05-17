CREATE TABLE tr_matrycaumiejetnosci (
    mau_id integer NOT NULL,
    mau_p_idpracownika integer NOT NULL,
    mau_top_idoperacji integer NOT NULL,
    mau_wartosc numeric DEFAULT 0 NOT NULL,
    mau_flaga integer DEFAULT 0 NOT NULL
);
