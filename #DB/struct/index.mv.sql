CREATE UNIQUE INDEX mv_ts_zestawelem_i1 ON ts_mvzestawelem USING btree (mvz_idzestawu, mvs_id);


--
--

CREATE UNIQUE INDEX ts_mvpodrodzaj_i1 ON ts_mvpodrodzaj USING btree (mvs_id, mvp_notpodrodzaj);


SET search_path = mvv, pg_catalog;
