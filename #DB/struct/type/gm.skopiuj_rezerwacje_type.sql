CREATE TYPE skopiuj_rezerwacje_type AS (
	rc_idruchu_src integer,
	tel_idelem_dst integer,
	tex_idelem_dst integer,
	tr_idtrans_dst integer,
	rc_ilosctocopy numeric,
	rc_addflaga integer,
	rc_delflaga integer,
	rc_ruch_new integer,
	prt_idpartiipz_new integer,
	rc_iloscpoztoadd numeric,
	_leaveflags boolean
);
