CREATE OPERATOR + (
    PROCEDURE = vat.addinfo,
    LEFTARG = vat.tb_vat,
    RIGHTARG = vat.tb_vat,
    COMMUTATOR = +
);


--
--

CREATE OPERATOR + (
    PROCEDURE = gms.addtmilosci,
    LEFTARG = gms.tm_ilosci,
    RIGHTARG = gms.tm_ilosci
);


--
--

CREATE OPERATOR - (
    PROCEDURE = vat.subinfo,
    LEFTARG = vat.tb_vat,
    RIGHTARG = vat.tb_vat,
    COMMUTATOR = -
);


--
--

CREATE OPERATOR - (
    PROCEDURE = gms.subtmilosci,
    LEFTARG = gms.tm_ilosci,
    RIGHTARG = gms.tm_ilosci
);


--
--

CREATE OPERATOR == (
    PROCEDURE = vat.eqinfo,
    LEFTARG = vat.tb_vat,
    RIGHTARG = vat.tb_vat
);


--
--

CREATE OPERATOR == (
    PROCEDURE = gm.flc_compare,
    LEFTARG = gm.tm_flagcounterbase,
    RIGHTARG = gm.tm_flagcounterbase
);


--
--

CREATE OPERATOR ~~~ (
    PROCEDURE = rilike,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = ~~
);
