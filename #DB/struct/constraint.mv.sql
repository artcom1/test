ALTER TABLE ONLY ts_multivalfiltr
    ADD CONSTRAINT ts_multivalfiltr_pkey PRIMARY KEY (mvf_idfiltru);


--
--

ALTER TABLE ONLY ts_multivalpage
    ADD CONSTRAINT ts_multivalpage_pkey PRIMARY KEY (mvg_id);


--
--

ALTER TABLE ONLY ts_multivals
    ADD CONSTRAINT ts_multivals_pkey PRIMARY KEY (mvs_id);


--
--

ALTER TABLE ONLY ts_mvmoveables
    ADD CONSTRAINT ts_mvmoveables_pkey PRIMARY KEY (mva_id);


--
--

ALTER TABLE ONLY ts_mvpodrodzaj
    ADD CONSTRAINT ts_mvpodrodzaj_pkey PRIMARY KEY (mvp_id);


--
--

ALTER TABLE ONLY ts_mvzestaw
    ADD CONSTRAINT ts_mvzestaw_pkey PRIMARY KEY (mvz_idzestawu);


--
--

ALTER TABLE ONLY ts_mvzestawelem
    ADD CONSTRAINT ts_mvzestawelem_pkey PRIMARY KEY (mvze_idelemu);
