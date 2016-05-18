CREATE INDEX gm_tm_childs_i1 ON tm_childs USING btree (gcl_sessionid, rc_idruchu_parent);


--
--

CREATE INDEX gm_tm_childs_i2 ON tm_childs USING btree (rc_idruchu_parent);


--
--

CREATE INDEX gm_tm_childs_i3 ON tm_childs USING btree (rc_idruchu_child);


--
--

CREATE UNIQUE INDEX gm_tm_flagcounter_u ON tm_flagcounter USING btree (mrpp_idpalety_to, flc_type);


--
--

CREATE UNIQUE INDEX gm_tm_oznaczoneruchy_i1 ON tm_oznaczoneruchy USING btree (ozr_setid, rc_idruchu);


--
--

CREATE INDEX gm_tm_oznaczoneruchy_i2 ON tm_oznaczoneruchy USING btree (rc_idruchu);


--
--

CREATE UNIQUE INDEX gm_tm_simulation_i1 ON tm_simulation USING btree (sim_sid, sim_simid, rc_idruchurez, rc_idruchupz);


--
--

CREATE INDEX gm_tm_simulation_i2 ON tm_simulation USING btree ((COALESCE(sim_sid, '-1'::integer)), sim_simid, rc_idruchupz);


--
--

CREATE UNIQUE INDEX tg_rezstack_i1 ON tg_rezstack USING btree (rc_idruchu, rc_recver_new);
