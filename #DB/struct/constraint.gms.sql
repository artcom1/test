ALTER TABLE ONLY tm_allowed
    ADD CONSTRAINT tm_allowed_pkey PRIMARY KEY (nal_id);


--
--

ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_pkey PRIMARY KEY (bsim_id);


--
--

ALTER TABLE ONLY tm_idtouse
    ADD CONSTRAINT tm_idtouse_pkey PRIMARY KEY (suu_id);


--
--

ALTER TABLE ONLY tm_marked
    ADD CONSTRAINT tm_marked_pkey PRIMARY KEY (gmm_id);


--
--

ALTER TABLE ONLY tm_simcoll
    ADD CONSTRAINT tm_simcoll_pkey PRIMARY KEY (sc_id);


--
--

ALTER TABLE ONLY tm_simdlamiejsca
    ADD CONSTRAINT tm_simdlamiejsca_pkey PRIMARY KEY (sdm_id);


--
--

ALTER TABLE ONLY tm_simorder
    ADD CONSTRAINT tm_simorder_pkey PRIMARY KEY (so_id);


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_pkey PRIMARY KEY (swz_id);


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_pkey PRIMARY KEY (stu_id);
