ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_mm_idmiejscadst_fkey FOREIGN KEY (mm_idmiejscadst) REFERENCES public.ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_mm_idmiejscasrc_fkey FOREIGN KEY (mm_idmiejscasrc) REFERENCES public.ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_tr_idtranssrc_fkey FOREIGN KEY (tr_idtranssrc) REFERENCES public.tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_bigsimulation
    ADD CONSTRAINT tm_bigsimulation_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES public.tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_idtouse
    ADD CONSTRAINT tm_idtouse_rc_idruchuwz_touse_fkey FOREIGN KEY (rc_idruchuwz_touse) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_idtouse
    ADD CONSTRAINT tm_idtouse_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES public.tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_marked
    ADD CONSTRAINT tm_marked_rc_idruchu_fkey FOREIGN KEY (rc_idruchu) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simcoll
    ADD CONSTRAINT tm_simcoll_rc_idruchupz_fkey FOREIGN KEY (rc_idruchupz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_simcoll
    ADD CONSTRAINT tm_simcoll_sc_idmiejsca_fkey FOREIGN KEY (sc_idmiejsca) REFERENCES public.ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_simcoll
    ADD CONSTRAINT tm_simcoll_sc_idpartiipz_fkey FOREIGN KEY (sc_idpartiipz) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_simcoll
    ADD CONSTRAINT tm_simcoll_sc_idtowmag_fkey FOREIGN KEY (sc_idtowmag) REFERENCES public.tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tm_simdlamiejsca
    ADD CONSTRAINT tm_simdlamiejsca_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simdlamiejsca
    ADD CONSTRAINT tm_simdlamiejsca_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES public.tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simorder
    ADD CONSTRAINT tm_simorder_sc_id_fkey FOREIGN KEY (sc_id) REFERENCES tm_simcoll(sc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_mm_idmiejscapz_fkey FOREIGN KEY (mm_idmiejscapz) REFERENCES public.ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_rc_idruchupz_fkey FOREIGN KEY (rc_idruchupz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_rc_idruchuwz_fkey FOREIGN KEY (rc_idruchuwz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_simwz
    ADD CONSTRAINT tm_simwz_sc_id_fkey FOREIGN KEY (sc_id) REFERENCES tm_simcoll(sc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES public.ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_prt_idpartiil_fkey FOREIGN KEY (prt_idpartiil) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_rc_idruchupz_fkey FOREIGN KEY (rc_idruchupz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_rc_idruchurez_fkey FOREIGN KEY (rc_idruchurez) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_rc_idruchuwz_fkey FOREIGN KEY (rc_idruchuwz) REFERENCES public.tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_touse
    ADD CONSTRAINT tm_touse_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES public.tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = mv, pg_catalog;
