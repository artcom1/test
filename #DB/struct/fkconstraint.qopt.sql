ALTER TABLE ONLY tg_exdetails
    ADD CONSTRAINT tg_exdetails_lexdet_ref_fkey FOREIGN KEY (lexdet_ref) REFERENCES tg_exdetails(lexdet_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_exdetails
    ADD CONSTRAINT tg_exdetails_lexp_id_fkey FOREIGN KEY (lexp_id) REFERENCES tg_explains(lexp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_explains
    ADD CONSTRAINT tg_explains_lg_id_fkey FOREIGN KEY (lg_id) REFERENCES tg_logs(lg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_loglocks
    ADD CONSTRAINT tg_loglocks_lg_id_fkey FOREIGN KEY (lg_id) REFERENCES tg_logs(lg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_logs
    ADD CONSTRAINT tg_logs_lt_tid_fkey FOREIGN KEY (lt_tid) REFERENCES tg_logtrans(lt_tid) ON UPDATE CASCADE ON DELETE CASCADE;
