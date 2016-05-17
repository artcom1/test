CREATE TYPE dodaj_rezerwacje_type AS (
	rc_ilosc numeric,
	prt_idpartii integer,
	tel_idelem_for integer,
	tex_idelem_for integer,
	tr_idtrans_for integer,
	k_idklienta_for integer,
	data_rezerwacji date,
	ttw_idtowaru integer,
	ttm_idtowmag integer,
	tmg_idmagazynu integer,
	_zewskazaniem boolean,
	_idpzam integer,
	_rezid integer,
	_onlywskazane boolean,
	_rezdopzam boolean,
	ttw_whereparams integer,
	ttw_inoutmethod integer,
	_rezerwacjalekka boolean,
	rc_idruchupz integer,
	_nonewrezerwacja boolean
);