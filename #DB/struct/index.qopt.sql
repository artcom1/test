CREATE INDEX gms_tg_loglocks_i1 ON tg_loglocks USING btree (lg_id);


--
--

CREATE INDEX gms_tg_logs1 ON tg_logs USING btree (lg_sessid, lg_start);


--
--

CREATE INDEX gms_tg_logs2 ON tg_logs USING btree (lg_sessid, lg_end);


--
--

CREATE INDEX gms_tg_logs3 ON tg_logs USING btree (lt_tid);


--
--

CREATE INDEX gms_tg_logtrans1 ON tg_logtrans USING btree (lt_sessid, lt_start);


--
--

CREATE INDEX gms_tg_logtrans2 ON tg_logtrans USING btree (lt_sessid, lt_end);


--
--

CREATE INDEX qopt_tg_exdetails_i1 ON tg_exdetails USING btree (lexp_id);


--
--

CREATE INDEX qopt_tg_explains_i1 ON tg_explains USING btree (lg_id);


SET search_path = vat, pg_catalog;
