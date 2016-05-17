CREATE AGGREGATE myconcat(text) (
    SFUNC = agg_myconcat,
    STYPE = text,
    INITCOND = ''
);


--
--

CREATE AGGREGATE sum(gms.tm_ilosci) (
    SFUNC = gms.tm_ilosci_add,
    STYPE = gms.tm_ilosci,
    INITCOND = '(0,0,0,0)'
);


--
--

CREATE AGGREGATE sum(vat.tb_vat) (
    SFUNC = vat.sumvat,
    STYPE = vat.tb_vat
);
