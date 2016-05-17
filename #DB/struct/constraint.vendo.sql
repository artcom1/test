ALTER TABLE ONLY tm_licenseextension
    ADD CONSTRAINT tm_licenseextension_pkey PRIMARY KEY (nsl_id);


--
--

ALTER TABLE ONLY tm_numerseryjny
    ADD CONSTRAINT tm_numerseryjny_pkey PRIMARY KEY (vns_id);


--
--

ALTER TABLE ONLY tm_numeryseryjne
    ADD CONSTRAINT tm_numeryseryjne_pkey PRIMARY KEY (ns_idnumeru);


--
--

ALTER TABLE ONLY tm_registereddbs
    ADD CONSTRAINT tm_registereddbs_pkey PRIMARY KEY (nsr_idrejestracji);


--
--

ALTER TABLE ONLY tm_rodzajeinfo
    ADD CONSTRAINT tm_rodzajeinfo_pkey PRIMARY KEY (tr_rodzaj);


--
--

ALTER TABLE ONLY tm_rodzajezleceninfo
    ADD CONSTRAINT tm_rodzajezleceninfo_pkey PRIMARY KEY (zl_typ);


--
--

ALTER TABLE ONLY tm_vorders
    ADD CONSTRAINT tm_vorders_pkey PRIMARY KEY (ord_id);


--
--

ALTER TABLE ONLY tmp_viewspushed
    ADD CONSTRAINT tmp_viewspushed_pkey PRIMARY KEY (id);


SET search_path = gm, pg_catalog;
