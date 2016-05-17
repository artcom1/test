CREATE UNIQUE INDEX kh_platnosci_mv_idx ON kh_platnosci_mv USING btree (pl_idplatnosc);


--
--

CREATE UNIQUE INDEX st_srodkitrwale_mv_idx ON st_srodkitrwale_mv USING btree (str_id);


--
--

CREATE UNIQUE INDEX tb_firma_mv_idx ON tb_firma_mv USING btree (fm_index);


--
--

CREATE UNIQUE INDEX tb_kalendarzhead_mv_idx ON tb_kalendarzhead_mv USING btree (kalh_idkalendarzahead);


--
--

CREATE UNIQUE INDEX tb_klient_mv_idx ON tb_klient_mv USING btree (k_idklienta);


--
--

CREATE UNIQUE INDEX tb_ludzieklienta_mv_idx ON tb_ludzieklienta_mv USING btree (lk_idczklienta);


--
--

CREATE UNIQUE INDEX tb_pracownicy_mv_idx ON tb_pracownicy_mv USING btree (p_idpracownika);


--
--

CREATE UNIQUE INDEX tb_zdarzenia_mv_idx ON tb_zdarzenia_mv USING btree (zd_idzdarzenia);


--
--

CREATE UNIQUE INDEX tg_abonamelem_mv_idx ON tg_abonamelem_mv USING btree (ae_idelemu);


--
--

CREATE UNIQUE INDEX tg_abonamenty_mv_idx ON tg_abonamenty_mv USING btree (ab_idabonamentu);


--
--

CREATE UNIQUE INDEX tg_charklientdlatow_mv_idx ON tg_charklientdlatow_mv USING btree (ckdt_idkartoteki);


--
--

CREATE UNIQUE INDEX tg_elslownika_mv_idx ON tg_elslownika_mv USING btree (es_idelem);


--
--

CREATE UNIQUE INDEX tg_grupytow_mv_idx ON tg_grupytow_mv USING btree (tgr_idgrupy);


--
--

CREATE UNIQUE INDEX tg_grupywww_mv_idx ON tg_grupywww_mv USING btree (tgw_idgrupy);


--
--

CREATE UNIQUE INDEX tg_jednostki_mv_idx ON tg_jednostki_mv USING btree (tjn_idjedn);


--
--

CREATE UNIQUE INDEX tg_klientzlecenia_mv_idx ON tg_klientzlecenia_mv USING btree (kz_idklienta);


--
--

CREATE UNIQUE INDEX tg_kpohead_mv_idx ON tg_kpohead_mv USING btree (kpo_idheadu);


--
--

CREATE UNIQUE INDEX tg_magazyny_mv_idx ON tg_magazyny_mv USING btree (tmg_idmagazynu);


--
--

CREATE UNIQUE INDEX tg_obiekty_mv_idx ON tg_obiekty_mv USING btree (ob_idobiektu);


--
--

CREATE UNIQUE INDEX tg_partie_mv_idx ON tg_partie_mv USING btree (prt_idpartii);


--
--

CREATE UNIQUE INDEX tg_partiehelper_mv_idx ON tg_partiehelper_mv USING btree (prh_idpartii);


--
--

CREATE UNIQUE INDEX tg_planzlecenia_mv_idx ON tg_planzlecenia_mv USING btree (pz_idplanu);


--
--

CREATE UNIQUE INDEX tg_podgrupytow_mv_idx ON tg_podgrupytow_mv USING btree (tpg_idpodgrupy);


--
--

CREATE UNIQUE INDEX tg_praceall_mv_idx ON tg_praceall_mv USING btree (pra_idpracy);


--
--

CREATE UNIQUE INDEX tg_rodzajedokumentow_mv_idx ON tg_rodzajedokumentow_mv USING btree (tr_rodzaj);


--
--

CREATE UNIQUE INDEX tg_swiadectwa_mv_idx ON tg_swiadectwa_mv USING btree (sw_idswiadectwa);


--
--

CREATE UNIQUE INDEX tg_teex_mv_idx ON tg_teex_mv USING btree (tex_idelem);


--
--

CREATE UNIQUE INDEX tg_towary_mv_idx ON tg_towary_mv USING btree (ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tg_transakcje_mv_idx ON tg_transakcje_mv USING btree (tr_idtrans);


--
--

CREATE UNIQUE INDEX tg_transelem_mv_idx ON tg_transelem_mv USING btree (tel_idelem);


--
--

CREATE UNIQUE INDEX tg_transport_mv_idx ON tg_transport_mv USING btree (lt_idtransportu);


--
--

CREATE UNIQUE INDEX tg_zlecenia_mv_idx ON tg_zlecenia_mv USING btree (zl_idzlecenia);


--
--

CREATE UNIQUE INDEX tr_ciagtech_mv_idx ON tr_ciagtech_mv USING btree (ct_idciagu);


--
--

CREATE UNIQUE INDEX tr_kkwhead_mv_idx ON tr_kkwhead_mv USING btree (kwh_idheadu);


--
--

CREATE UNIQUE INDEX tr_kkwnod_mv_idx ON tr_kkwnod_mv USING btree (kwe_idelemu);


--
--

CREATE UNIQUE INDEX tr_kkwnodwyk_mv_idx ON tr_kkwnodwyk_mv USING btree (knw_idelemu);


--
--

CREATE UNIQUE INDEX tr_nodrec_mv_idx ON tr_nodrec_mv USING btree (knr_idelemu);


--
--

CREATE UNIQUE INDEX tr_operacjetech_mv_idx ON tr_operacjetech_mv USING btree (top_idoperacji);


--
--

CREATE UNIQUE INDEX tr_pomiary_definicje_mv_idx ON tr_pomiary_definicje_mv USING btree (pd_iddefinicji);


--
--

CREATE UNIQUE INDEX tr_pomiary_wykonanie_mv_idx ON tr_pomiary_wykonanie_mv USING btree (pw_idpomiarukkw);


--
--

CREATE UNIQUE INDEX tr_rrozchodu_mv_idx ON tr_rrozchodu_mv USING btree (trr_idelemu);


--
--

CREATE UNIQUE INDEX tr_technoelem_mv_idx ON tr_technoelem_mv USING btree (the_idelem);


--
--

CREATE UNIQUE INDEX tr_technogrupy_mv_idx ON tr_technogrupy_mv USING btree (thg_idgrupy);


--
--

CREATE UNIQUE INDEX tr_technologie_mv_idx ON tr_technologie_mv USING btree (th_idtechnologii);


--
--

CREATE UNIQUE INDEX ts_banki_mv_idx ON ts_banki_mv USING btree (bk_idbanku);


--
--

CREATE UNIQUE INDEX ts_formaplat_mv_idx ON ts_formaplat_mv USING btree (pl_formaplat);


--
--

CREATE UNIQUE INDEX ts_grupycen_mv_idx ON ts_grupycen_mv USING btree (tgc_idgrupy);


--
--

CREATE UNIQUE INDEX ts_powiaty_mv_idx ON ts_powiaty_mv USING btree (pw_idpowiatu);


--
--

CREATE UNIQUE INDEX ts_slownikwykonania_mv_idx ON ts_slownikwykonania_mv USING btree (tsw_idslownika);


--
--

CREATE UNIQUE INDEX ts_spedycje_mv_idx ON ts_spedycje_mv USING btree (sp_idspedytora);


SET search_path = public, pg_catalog;
