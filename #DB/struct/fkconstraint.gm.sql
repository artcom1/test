ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_prt_idpartii_new_fkey FOREIGN KEY (prt_idpartii_new) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_prt_idpartii_old_fkey FOREIGN KEY (prt_idpartii_old) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_rc_idruchu_fkey FOREIGN KEY (rc_idruchu) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_tel_idelem_new_fkey FOREIGN KEY (tel_idelem_new) REFERENCES public.tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_tel_idelem_old_fkey FOREIGN KEY (tel_idelem_old) REFERENCES public.tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_tex_idelem_new_fkey FOREIGN KEY (tex_idelem_new) REFERENCES public.tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_rezstack
    ADD CONSTRAINT tg_rezstack_tex_idelem_old_fkey FOREIGN KEY (tex_idelem_old) REFERENCES public.tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_tetotouch
    ADD CONSTRAINT tg_tetotouch_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES public.tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_childs
    ADD CONSTRAINT tm_childs_rc_idruchu_child_fkey FOREIGN KEY (rc_idruchu_child) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_childs
    ADD CONSTRAINT tm_childs_rc_idruchu_parent_fkey FOREIGN KEY (rc_idruchu_parent) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_flagcounter
    ADD CONSTRAINT tm_flagcounter_mrpp_idpalety_to_fkey FOREIGN KEY (mrpp_idpalety_to) REFERENCES public.tr_mrppalety(mrpp_idpalety) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_flagcounterbase
    ADD CONSTRAINT tm_flagcounterbase_mrpp_idpalety_to_fkey FOREIGN KEY (mrpp_idpalety_to) REFERENCES public.tr_mrppalety(mrpp_idpalety) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simulation
    ADD CONSTRAINT tm_simulation_rc_idruchupz_fkey FOREIGN KEY (rc_idruchupz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simulation
    ADD CONSTRAINT tm_simulation_rc_idruchurez_fkey FOREIGN KEY (rc_idruchurez) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;
