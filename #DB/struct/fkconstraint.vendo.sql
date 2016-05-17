ALTER TABLE ONLY tm_licenseextension
    ADD CONSTRAINT tm_licenseextension_ns_idnumeru_fkey FOREIGN KEY (ns_idnumeru) REFERENCES tm_numeryseryjne(ns_idnumeru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tm_licenseextension
    ADD CONSTRAINT tm_licenseextension_ns_idnumeru_prev_fkey FOREIGN KEY (ns_idnumeru_prev) REFERENCES tm_numeryseryjne(ns_idnumeru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tm_licenseextension
    ADD CONSTRAINT tm_licenseextension_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES public.tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_numeryseryjne
    ADD CONSTRAINT tm_numeryseryjne_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES public.tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tm_registereddbs
    ADD CONSTRAINT tm_registereddbs_ns_idnumeru_fkey FOREIGN KEY (ns_idnumeru) REFERENCES tm_numeryseryjne(ns_idnumeru) ON UPDATE CASCADE ON DELETE RESTRICT;
