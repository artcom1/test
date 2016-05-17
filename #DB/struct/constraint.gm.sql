ALTER TABLE ONLY tg_idpartiitocalc
    ADD CONSTRAINT tg_idpartiitocalc_pkey PRIMARY KEY (idc_id);


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_pkey PRIMARY KEY (rs_id);


--
--

ALTER TABLE ONLY tm_childs
    ADD CONSTRAINT tm_childs_pkey PRIMARY KEY (gcl_id);


--
--

ALTER TABLE ONLY tm_flagcounter
    ADD CONSTRAINT tm_flagcounter_pkey PRIMARY KEY (flc_id);


--
--

ALTER TABLE ONLY tm_oznaczoneruchy
    ADD CONSTRAINT tm_oznaczoneruchy_pkey PRIMARY KEY (ozr_id);


--
--

ALTER TABLE ONLY tm_simulation
    ADD CONSTRAINT tm_simulation_pkey PRIMARY KEY (sim_id);


SET search_path = gmr, pg_catalog;
