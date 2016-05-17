CREATE UNIQUE INDEX gms_tm_allowed_i1 ON tm_allowed USING btree (nal_sid, nal_simid, (COALESCE(tel_idelem, 0)), (COALESCE(tex_idelem, 0)));


--
--

CREATE INDEX gms_tm_bigsimulation_i1 ON tm_bigsimulation USING btree (bsim_sid, bsim_simid);


--
--

CREATE UNIQUE INDEX gms_tm_idtouse_i1 ON tm_idtouse USING btree (sc_id, sc_simid, rc_idruchuwz);


--
--

CREATE UNIQUE INDEX gms_tm_idtouse_i2 ON tm_idtouse USING btree (sc_id, sc_simid, rc_idruchurezl);


--
--

CREATE UNIQUE INDEX gms_tm_idtouse_i3 ON tm_idtouse USING btree (sc_id, sc_simid, rc_idruchurezc);


--
--

CREATE INDEX gms_tm_idtouse_i4 ON tm_idtouse USING btree (sc_id, sc_simid, ttm_idtowmag);


--
--

CREATE UNIQUE INDEX gms_tm_idtouse_i5 ON tm_idtouse USING btree (sc_id, sc_simid, rc_idruchuwz_touse);


--
--

CREATE UNIQUE INDEX gms_tm_marked_i1 ON tm_marked USING btree (sc_sid, sc_simid, rc_idruchu);


--
--

CREATE UNIQUE INDEX gms_tm_simcoll_i1 ON tm_simcoll USING btree (sc_sid, sc_simid, rc_idruchupz);


--
--

CREATE INDEX gms_tm_simcoll_i2 ON tm_simcoll USING btree (sc_sid, sc_simid, sc_idtowmag);


--
--

CREATE INDEX gms_tm_simdlamiejsca_i1 ON tm_simdlamiejsca USING btree (sc_sid, sc_simid);


--
--

CREATE INDEX gms_tm_simorder_i1 ON tm_simorder USING btree (sc_id);


--
--

CREATE INDEX gms_tm_simwz_i1 ON tm_simwz USING btree (sc_id);


--
--

CREATE INDEX gms_tm_touse_i1 ON tm_touse USING btree (sc_sid, sc_simid);


SET search_path = mv, pg_catalog;
