ALTER TABLE ONLY tg_exdetails
    ADD CONSTRAINT tg_exdetails_pkey PRIMARY KEY (lexdet_id);


--
--

ALTER TABLE ONLY tg_explains
    ADD CONSTRAINT tg_explains_pkey PRIMARY KEY (lexp_id);


--
--

ALTER TABLE ONLY tg_loglocks
    ADD CONSTRAINT tg_loglocks_pkey PRIMARY KEY (ll_id);


--
--

ALTER TABLE ONLY tg_logs
    ADD CONSTRAINT tg_logs_pkey PRIMARY KEY (lg_id);


--
--

ALTER TABLE ONLY tg_logtrans
    ADD CONSTRAINT tg_logtrans_pkey PRIMARY KEY (lt_tid);


--
--

ALTER TABLE ONLY tg_postgreslog
    ADD CONSTRAINT tg_postgreslog_pkey PRIMARY KEY (plog_session_id, plog_session_line_num);


SET search_path = vat, pg_catalog;
