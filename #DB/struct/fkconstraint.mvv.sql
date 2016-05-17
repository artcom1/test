ALTER TABLE ONLY kh_platnosci_mv
    ADD CONSTRAINT kh_platnosci_mv_pl_idplatnosc_fkey FOREIGN KEY (pl_idplatnosc) REFERENCES public.kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_srodkitrwale_mv
    ADD CONSTRAINT st_srodkitrwale_mv_str_id_fkey FOREIGN KEY (str_id) REFERENCES public.st_srodkitrwale(str_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_firma_mv
    ADD CONSTRAINT tb_firma_mv_fm_index_fkey FOREIGN KEY (fm_index) REFERENCES public.tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kalendarzhead_mv
    ADD CONSTRAINT tb_kalendarzhead_mv_kalh_idkalendarzahead_fkey FOREIGN KEY (kalh_idkalendarzahead) REFERENCES public.tb_kalendarzhead(kalh_idkalendarzahead) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_klient_mv
    ADD CONSTRAINT tb_klient_mv_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES public.tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ludzieklienta_mv
    ADD CONSTRAINT tb_ludzieklienta_mv_lk_idczklienta_fkey FOREIGN KEY (lk_idczklienta) REFERENCES public.tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicy_mv
    ADD CONSTRAINT tb_pracownicy_mv_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES public.tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia_mv
    ADD CONSTRAINT tb_zdarzenia_mv_zd_idzdarzenia_fkey FOREIGN KEY (zd_idzdarzenia) REFERENCES public.tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamelem_mv
    ADD CONSTRAINT tg_abonamelem_mv_ae_idelemu_fkey FOREIGN KEY (ae_idelemu) REFERENCES public.tg_abonamelem(ae_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamenty_mv
    ADD CONSTRAINT tg_abonamenty_mv_ab_idabonamentu_fkey FOREIGN KEY (ab_idabonamentu) REFERENCES public.tg_abonamenty(ab_idabonamentu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_charklientdlatow_mv
    ADD CONSTRAINT tg_charklientdlatow_mv_ckdt_idkartoteki_fkey FOREIGN KEY (ckdt_idkartoteki) REFERENCES public.tg_charklientdlatow(ckdt_idkartoteki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_elslownika_mv
    ADD CONSTRAINT tg_elslownika_mv_es_idelem_fkey FOREIGN KEY (es_idelem) REFERENCES public.tg_elslownika(es_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_grupytow_mv
    ADD CONSTRAINT tg_grupytow_mv_tgr_idgrupy_fkey FOREIGN KEY (tgr_idgrupy) REFERENCES public.tg_grupytow(tgr_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_grupywww_mv
    ADD CONSTRAINT tg_grupywww_mv_tgw_idgrupy_fkey FOREIGN KEY (tgw_idgrupy) REFERENCES public.tg_grupywww(tgw_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_jednostki_mv
    ADD CONSTRAINT tg_jednostki_mv_tjn_idjedn_fkey FOREIGN KEY (tjn_idjedn) REFERENCES public.tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_klientzlecenia_mv
    ADD CONSTRAINT tg_klientzlecenia_mv_kz_idklienta_fkey FOREIGN KEY (kz_idklienta) REFERENCES public.tg_klientzlecenia(kz_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead_mv
    ADD CONSTRAINT tg_kpohead_mv_kpo_idheadu_fkey FOREIGN KEY (kpo_idheadu) REFERENCES public.tg_kpohead(kpo_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_magazyny_mv
    ADD CONSTRAINT tg_magazyny_mv_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES public.tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_obiekty_mv
    ADD CONSTRAINT tg_obiekty_mv_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES public.tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partie_mv
    ADD CONSTRAINT tg_partie_mv_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES public.tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partiehelper_mv
    ADD CONSTRAINT tg_partiehelper_mv_prh_idpartii_fkey FOREIGN KEY (prh_idpartii) REFERENCES public.tg_partiehelper(prh_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia_mv
    ADD CONSTRAINT tg_planzlecenia_mv_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES public.tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_podgrupytow_mv
    ADD CONSTRAINT tg_podgrupytow_mv_tpg_idpodgrupy_fkey FOREIGN KEY (tpg_idpodgrupy) REFERENCES public.tg_podgrupytow(tpg_idpodgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_praceall_mv
    ADD CONSTRAINT tg_praceall_mv_pra_idpracy_fkey FOREIGN KEY (pra_idpracy) REFERENCES public.tg_praceall(pra_idpracy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_swiadectwa_mv
    ADD CONSTRAINT tg_swiadectwa_mv_sw_idswiadectwa_fkey FOREIGN KEY (sw_idswiadectwa) REFERENCES public.tg_swiadectwa(sw_idswiadectwa) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_teex_mv
    ADD CONSTRAINT tg_teex_mv_tex_idelem_fkey FOREIGN KEY (tex_idelem) REFERENCES public.tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towary_mv
    ADD CONSTRAINT tg_towary_mv_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES public.tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transakcje_mv
    ADD CONSTRAINT tg_transakcje_mv_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES public.tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transelem_mv
    ADD CONSTRAINT tg_transelem_mv_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES public.tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transport_mv
    ADD CONSTRAINT tg_transport_mv_lt_idtransportu_fkey FOREIGN KEY (lt_idtransportu) REFERENCES public.tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zlecenia_mv
    ADD CONSTRAINT tg_zlecenia_mv_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES public.tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_ciagtech_mv
    ADD CONSTRAINT tr_ciagtech_mv_ct_idciagu_fkey FOREIGN KEY (ct_idciagu) REFERENCES public.tr_ciagtech(ct_idciagu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwhead_mv
    ADD CONSTRAINT tr_kkwhead_mv_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES public.tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnod_mv
    ADD CONSTRAINT tr_kkwnod_mv_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES public.tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwyk_mv
    ADD CONSTRAINT tr_kkwnodwyk_mv_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES public.tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrec_mv
    ADD CONSTRAINT tr_nodrec_mv_knr_idelemu_fkey FOREIGN KEY (knr_idelemu) REFERENCES public.tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_operacjetech_mv
    ADD CONSTRAINT tr_operacjetech_mv_top_idoperacji_fkey FOREIGN KEY (top_idoperacji) REFERENCES public.tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_definicje_mv
    ADD CONSTRAINT tr_pomiary_definicje_mv_pd_iddefinicji_fkey FOREIGN KEY (pd_iddefinicji) REFERENCES public.tr_pomiary_definicje(pd_iddefinicji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie_mv
    ADD CONSTRAINT tr_pomiary_wykonanie_mv_pw_idpomiarukkw_fkey FOREIGN KEY (pw_idpomiarukkw) REFERENCES public.tr_pomiary_wykonanie(pw_idpomiarukkw) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_rrozchodu_mv
    ADD CONSTRAINT tr_rrozchodu_mv_trr_idelemu_fkey FOREIGN KEY (trr_idelemu) REFERENCES public.tr_rrozchodu(trr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoelem_mv
    ADD CONSTRAINT tr_technoelem_mv_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES public.tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technogrupy_mv
    ADD CONSTRAINT tr_technogrupy_mv_thg_idgrupy_fkey FOREIGN KEY (thg_idgrupy) REFERENCES public.tr_technogrupy(thg_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technologie_mv
    ADD CONSTRAINT tr_technologie_mv_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES public.tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_banki_mv
    ADD CONSTRAINT ts_banki_mv_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES public.ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_formaplat_mv
    ADD CONSTRAINT ts_formaplat_mv_pl_formaplat_fkey FOREIGN KEY (pl_formaplat) REFERENCES public.ts_formaplat(pl_formaplat) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_grupycen_mv
    ADD CONSTRAINT ts_grupycen_mv_tgc_idgrupy_fkey FOREIGN KEY (tgc_idgrupy) REFERENCES public.ts_grupycen(tgc_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_powiaty_mv
    ADD CONSTRAINT ts_powiaty_mv_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES public.ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_slownikwykonania_mv
    ADD CONSTRAINT ts_slownikwykonania_mv_tsw_idslownika_fkey FOREIGN KEY (tsw_idslownika) REFERENCES public.ts_slownikwykonania(tsw_idslownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_spedycje_mv
    ADD CONSTRAINT ts_spedycje_mv_sp_idspedytora_fkey FOREIGN KEY (sp_idspedytora) REFERENCES public.ts_spedycje(sp_idspedytora) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = public, pg_catalog;
