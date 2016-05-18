ALTER TABLE ONLY ts_multivalfiltr
    ADD CONSTRAINT ts_multivalfiltr_mvs_id_fkey FOREIGN KEY (mvs_id) REFERENCES ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_multivals
    ADD CONSTRAINT ts_multivals_mvg_id_fkey FOREIGN KEY (mvg_id) REFERENCES ts_multivalpage(mvg_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_multivals
    ADD CONSTRAINT ts_multivals_mvs_ex_idslownika_fkey FOREIGN KEY (mvs_ex_idslownika) REFERENCES public.tg_slownik(sl_idslownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_multivals
    ADD CONSTRAINT ts_multivals_mvs_idslownikarozmiarowki_fkey FOREIGN KEY (mvs_idslownikarozmiarowki) REFERENCES public.tg_rozmrodzaje(rmr_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_mvmoveables
    ADD CONSTRAINT ts_mvmoveables_mvs_dstid_fkey FOREIGN KEY (mvs_dstid) REFERENCES ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_mvmoveables
    ADD CONSTRAINT ts_mvmoveables_mvs_srcid_fkey FOREIGN KEY (mvs_srcid) REFERENCES ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_mvpodrodzaj
    ADD CONSTRAINT ts_mvpodrodzaj_mvs_id_fkey FOREIGN KEY (mvs_id) REFERENCES ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_mvzestawelem
    ADD CONSTRAINT ts_mvzestawelem_mvs_id_fkey FOREIGN KEY (mvs_id) REFERENCES ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_mvzestawelem
    ADD CONSTRAINT ts_mvzestawelem_mvz_idzestawu_fkey FOREIGN KEY (mvz_idzestawu) REFERENCES ts_mvzestaw(mvz_idzestawu) ON UPDATE CASCADE ON DELETE CASCADE;
