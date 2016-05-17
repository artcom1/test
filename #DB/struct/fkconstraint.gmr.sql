ALTER TABLE ONLY tg_planzleceniarozmelems
    ADD CONSTRAINT tg_planzleceniarozmelems_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES public.tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzleceniarozmelems
    ADD CONSTRAINT tg_planzleceniarozmelems_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES public.tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_planzleceniarozmelems
    ADD CONSTRAINT tg_planzleceniarozmelems_tel_idsrcelem_fkey FOREIGN KEY (tel_idsrcelem) REFERENCES public.tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_planzleceniarozmelems
    ADD CONSTRAINT tg_planzleceniarozmelems_ttw_idtowaru_pdx_fkey FOREIGN KEY (ttw_idtowaru_pdx) REFERENCES public.tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


SET search_path = gms, pg_catalog;
