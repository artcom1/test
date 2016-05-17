CREATE INDEX archiwum_datanad ON tg_archiwum USING btree (a_datanadold);


--
--

CREATE INDEX archiwum_k_idklienta ON tg_archiwum USING btree (k_idklienta);


--
--

CREATE INDEX archiwum_p_idpracownika ON tg_archiwum USING btree (p_idpracownika);


--
--

CREATE INDEX gm_tg_ruchy_pz1 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (ispzet(rc_flaga) AND ((rc_iloscpoz - (rc_iloscrez - rc_iloscrezzr)) > (0)::numeric));


--
--

CREATE INDEX gm_tg_ruchy_pz2 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (ispzet(rc_flaga) AND (rc_iloscpoz > (0)::numeric));


--
--

CREATE INDEX gm_tg_ruchy_rezerwacje1 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (isrezerwacja(rc_flaga) AND (rc_iloscrez > (0)::numeric));


--
--

CREATE INDEX gm_tg_ruchy_rezerwacje2 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (isrezerwacja(rc_flaga) AND ((rc_ilosc - rc_iloscrezzr) > (0)::numeric));


--
--

CREATE INDEX gm_tg_towary_rtowaru ON tg_towary USING btree (((ttw_rtowaru & 65535)));


--
--

CREATE INDEX ignorowaneeany_ean ON tg_ignorowaneeany USING btree (ie_ean);


--
--

CREATE UNIQUE INDEX kh_deferredkh_i1 ON kh_deferredkh USING btree (dkh_outtype, tr_idtrans);


--
--

CREATE UNIQUE INDEX kh_deferredkh_i2 ON kh_deferredkh USING btree (dkh_outtype, pl_idplatnosc);


--
--

CREATE INDEX kh_konta_index_n ON kh_konta USING btree (numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer) text_pattern_ops);


--
--

CREATE INDEX kh_konta_index_n_v1 ON kh_konta USING btree (numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer));


--
--

CREATE INDEX kh_konta_index_normalized ON kh_konta USING btree (normalizekonto(numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer)) text_pattern_ops);


--
--

CREATE UNIQUE INDEX kh_konta_index_u1 ON kh_konta USING btree (ro_idroku, kt_ref, sortkonta(kt_numer, 8, '-'::text));


--
--

CREATE INDEX kh_konta_ktn ON kh_konta USING btree (ktn_idkonta);


--
--

CREATE INDEX kh_konta_sk ON kh_konta USING btree (sortkonta(numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer), 8));


--
--

CREATE INDEX kh_konta_skop ON kh_konta USING btree (sortkonta(numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer), 8) text_pattern_ops);


--
--

CREATE INDEX kh_konta_skr ON kh_konta USING btree (ro_idroku, sortkonta(numerkonta(kt_prefix, kt_numer, (kt_zerosto)::integer), 8));


--
--

CREATE UNIQUE INDEX kh_kontanorm_i1 ON kh_kontanorm USING btree (fm_idcentrali, ktn_nrkonta);


--
--

CREATE INDEX kh_kontavatowekh_index_u1 ON kh_kontavatowekh USING btree (kt_idkonta);


--
--

CREATE INDEX kh_konwersjakpir_idtrans ON kh_konwersjakpir USING btree (tr_idtrans);


--
--

CREATE INDEX kh_konwersjakpir_idzapisu ON kh_konwersjakpir USING btree (kp_idzapisu);


--
--

CREATE INDEX kh_obroty_i2 ON kh_obroty USING btree (ro_idroku, ob_poziom);


--
--

CREATE INDEX kh_obroty_oref ON kh_obroty USING btree (kt_ref);


--
--

CREATE INDEX kh_platelem_index1 ON kh_platelem USING btree (pl_idplatnosc);


--
--

CREATE INDEX kh_platelem_index2 ON kh_platelem USING btree (tr_idtrans);


--
--

CREATE INDEX kh_platnosci_centrala ON kh_platnosci USING btree (fm_idcentrali);


--
--

CREATE INDEX kh_platnosci_index1 ON kh_platnosci USING btree (pl_wplyw);


--
--

CREATE INDEX kh_platnosci_index2 ON kh_platnosci USING btree (pl_formaplat);


--
--

CREATE INDEX kh_platnosci_index3 ON kh_platnosci USING btree (wl_idwaluty);


--
--

CREATE INDEX kh_platnosci_index4 ON kh_platnosci USING btree (pl_datawplywu);


--
--

CREATE INDEX kh_platnosci_index5 ON kh_platnosci USING btree (k_idklienta);


--
--

CREATE INDEX kh_platnosci_index6 ON kh_platnosci USING btree (bk_idbanku);


--
--

CREATE INDEX kh_platnosci_index7 ON kh_platnosci USING btree (plisnormal(pl_flaga));


--
--

CREATE INDEX kh_platnosci_index8 ON kh_platnosci USING btree (fm_idcentrali, pl_datawplywu, bk_idbanku, wl_idwaluty, pl_formaplat);


--
--

CREATE INDEX kh_rejestre_rh_idrejestru ON kh_rejestrelem USING btree (rh_idrejestru);


--
--

CREATE INDEX kh_rejestrh_k_idklienta ON kh_rejestrhead USING btree (k_idklienta);


--
--

CREATE INDEX kh_rejestrh_ro_idroku ON kh_rejestrhead USING btree (ro_idroku);


--
--

CREATE INDEX kh_rejestrh_tr_idtrans ON kh_rejestrhead USING btree (tr_idtrans);


--
--

CREATE INDEX kh_rejestrhead_mn_miesiac ON kh_rejestrhead USING btree (mn_miesiac);


--
--

CREATE UNIQUE INDEX kh_wymiaryelems_i1 ON kh_wymiaryelems USING btree (wms_idwymiaru, wme_datatyperef, wme_idref);


--
--

CREATE UNIQUE INDEX kh_wymiaryobroty_i1 ON kh_wymiaryobroty USING btree (kt_idkonta, wme_idelemu, (COALESCE(mc_miesiac, '-1'::integer)));


--
--

CREATE UNIQUE INDEX kh_wymiaryonkonto_i1 ON kh_wymiaryonkonto USING btree (wms_idwymiaru, kt_idkonta);


--
--

CREATE UNIQUE INDEX kh_wymiarysumvalues_i1 ON kh_wymiarysumvalues USING btree (zp_idelzapisu, wms_idwymiaru);


--
--

CREATE INDEX kh_wzorceelem_index1 ON kh_wzorceelem USING btree (wz_idwzorca);


--
--

CREATE INDEX kh_wzorceelemkpir_idgri ON kh_wzorceelemkpir USING btree (tgr_idgrupy);


--
--

CREATE INDEX kh_wzorceelemkpir_idgrii ON kh_wzorceelemkpir USING btree (tpg_idpodgrupy);


--
--

CREATE INDEX kh_wzorceelemkpir_idtow ON kh_wzorceelemkpir USING btree (ttw_idtowaru);


--
--

CREATE INDEX kh_wzorceelemkpir_idwzorca ON kh_wzorceelemkpir USING btree (wzk_idwzorca);


--
--

CREATE UNIQUE INDEX kh_zapisskoj_index1 ON kh_zapisskoj USING btree (tr_idtrans, zs_typ);


--
--

CREATE UNIQUE INDEX kh_zapisskoj_index2 ON kh_zapisskoj USING btree (pl_idplatnosc, zs_typ);


--
--

CREATE UNIQUE INDEX kh_zapisskoj_index3 ON kh_zapisskoj USING btree (am_id, zs_typ);


--
--

CREATE UNIQUE INDEX kh_zapisskoj_index4 ON kh_zapisskoj USING btree (pp_idplatelem);


--
--

CREATE INDEX kh_zapisyelem_index1 ON kh_zapisyelem USING btree (tr_idtrans);


--
--

CREATE INDEX kh_zapisyelem_index2 ON kh_zapisyelem USING btree (pl_idplatnosc);


--
--

CREATE INDEX kh_zapisyelem_index3 ON kh_zapisyelem USING btree (kt_idkontawn);


--
--

CREATE INDEX kh_zapisyelem_index4 ON kh_zapisyelem USING btree (kt_idkontama);


--
--

CREATE INDEX kh_zapisyelem_index5 ON kh_zapisyelem USING btree (pp_idplatelem);


--
--

CREATE INDEX kh_zapisyelem_index6 ON kh_zapisyelem USING btree (zk_idzapisu);


--
--

CREATE INDEX kh_zapisykpir_k_idklienta ON kh_zapisykpir USING btree (k_idklienta);


--
--

CREATE INDEX kh_zapisykpir_mn_miesiac ON kh_zapisykpir USING btree (mn_miesiac);


--
--

CREATE INDEX kh_zapisykpir_ro_idroku ON kh_zapisykpir USING btree (ro_idroku);


--
--

CREATE UNIQUE INDEX kh_zledlugi_i1 ON kh_zledlugi USING btree (kzl_type, rc_idruchuwz);


--
--

CREATE INDEX kh_zledlugidet_i1 ON kh_zledlugidet USING btree (kzl_id, kzld_miesiac);


--
--

CREATE INDEX knw_idelemu_index1 ON tr_kkwnodwykdetkooperacja USING btree (knw_idelemu);


--
--

CREATE INDEX kr_check_rozliczono_i1 ON kr_check_rozliczono USING btree (pl_idplatnosc);


--
--

CREATE INDEX kr_conv_i1 ON kr_conv USING btree (tr_idtrans);


--
--

CREATE INDEX kr_conv_i2 ON kr_conv USING btree (pl_idplatnosc);


--
--

CREATE INDEX kr_convrr_i1 ON kr_convrr USING btree (pp_idplatelem);


--
--

CREATE INDEX kr_convrr_i2 ON kr_convrr USING btree (cvr_lid);


--
--

CREATE INDEX kr_convrr_i3 ON kr_convrr USING btree (cvr_rid);


--
--

CREATE INDEX kr_rozliczenia_datamax ON kr_rozliczenia USING btree (rl_datamax);


--
--

CREATE INDEX kr_rozliczenia_kompensaty ON kr_rozliczenia USING btree (km_idkompensaty);


--
--

CREATE INDEX kr_rozliczenia_l ON kr_rozliczenia USING btree (rr_idrozrachunkul);


--
--

CREATE INDEX kr_rozliczenia_r ON kr_rozliczenia USING btree (rr_idrozrachunkur);


--
--

CREATE UNIQUE INDEX kr_rozliczenia_rki ON kr_rozliczenia USING btree (rl_idrozliczenia_rk);


--
--

CREATE INDEX kr_rozrachunki_cen ON kr_rozrachunki USING btree (fm_idcentrali);


--
--

CREATE INDEX kr_rozrachunki_datadok ON kr_rozrachunki USING btree (rr_datadokumentu);


--
--

CREATE INDEX kr_rozrachunki_dataplat ON kr_rozrachunki USING btree (rr_dataplatnosci);


--
--

CREATE INDEX kr_rozrachunki_datazaplat ON kr_rozrachunki USING btree (rr_datazaplacenia);


--
--

CREATE INDEX kr_rozrachunki_idelzapisu ON kr_rozrachunki USING btree (zp_idelzapisu);


--
--

CREATE INDEX kr_rozrachunki_idklienta ON kr_rozrachunki USING btree (k_idklienta);


--
--

CREATE INDEX kr_rozrachunki_idkonta ON kr_rozrachunki USING btree (kt_idkonta);


--
--

CREATE INDEX kr_rozrachunki_idplatnosc ON kr_rozrachunki USING btree (pl_idplatnosc);


--
--

CREATE INDEX kr_rozrachunki_idtrans ON kr_rozrachunki USING btree (tr_idtrans);


--
--

CREATE INDEX kr_rozrachunki_p_tr_idtrans ON kr_rozrachunki USING btree (tr_idtrans) WHERE (((rr_flaga & 7) = 0) AND (NOT rr_isbufor) AND rr_isnormal AND (rr_wartoscpozwal <> (0)::numeric));


--
--

CREATE INDEX kr_rozrachunki_zk ON kr_rozrachunki USING btree (zp_idelzapisu);


--
--

CREATE INDEX kr_rozrachunki_zkr ON kr_rozrachunki USING btree (zp_idelzapisurk);


--
--

CREATE INDEX kr_rozrachunkiconv_i1 ON kr_rozrachunkiconv USING btree (c_typ, c_id);


--
--

CREATE INDEX kr_rozrachunkiconv_i2 ON kr_rozrachunkiconv USING btree (c_newid);


--
--

CREATE INDEX kr_salda_cent ON kr_salda USING btree (fm_idcentrali);


--
--

CREATE UNIQUE INDEX kr_salda_klientkonto ON kr_salda USING btree (k_idklienta, kt_idkonta);


--
--

CREATE INDEX kr_salda_kontotxt ON kr_salda USING btree (sd_nrkontatxt);


--
--

CREATE INDEX mad_mat_id_idx ON tb_mail_data_attachments_data USING btree (mad_mat_id);


--
--

CREATE INDEX mail_mac_id_idx ON tb_mail_data USING btree (mail_mac_id);


--
--

CREATE INDEX mal_mail_id_idx ON tb_mail_data_addresses USING btree (mal_mail_id);


--
--

CREATE INDEX mat_mail_id_idx ON tb_mail_data_attachments USING btree (mat_mail_id);


--
--

CREATE INDEX mci_menuid_idx ON tb_menucustomization USING btree (mci_menuid);


--
--

CREATE INDEX st_amortyzacja_index2 ON st_amortyzacja USING btree (st_id);


--
--

CREATE INDEX st_planst_index2 ON st_planst USING btree (str_id);


--
--

CREATE INDEX st_planst_index3 ON st_planst USING btree (am_id);


--
--

CREATE INDEX st_planst_index4 ON st_planst USING btree (nm_miesiac);


--
--

CREATE INDEX st_planst_index5 ON st_planst USING btree (p_idpracownika);


--
--

CREATE INDEX st_zdarzeniast_index2 ON st_zdarzeniast USING btree (str_id);


--
--

CREATE INDEX st_zdarzeniast_index3 ON st_zdarzeniast USING btree (nm_miesiac);


--
--

CREATE INDEX st_zdarzeniast_index4 ON st_zdarzeniast USING btree (p_idpracownika);


--
--

CREATE INDEX tb_akcja_index1 ON tb_akcja USING btree (a_nazwaakcji);


--
--

CREATE INDEX tb_akcja_index2 ON tb_akcja USING btree (ra_idrodzaju);


--
--

CREATE INDEX tb_akcja_index3 ON tb_akcja USING btree (a_datarozpoczecia);


--
--

CREATE INDEX tb_akcja_index4 ON tb_akcja USING btree (a_datazakonczenia);


--
--

CREATE INDEX tb_akcja_index5 ON tb_akcja USING btree (a_opis);


--
--

CREATE INDEX tb_akcja_index6 ON tb_akcja USING btree (a_cel);


--
--

CREATE INDEX tb_bankirel_klient ON tb_bankirel USING btree (k_idklienta);


--
--

CREATE INDEX tb_bankirel_magazyn ON tb_bankirel USING btree (tmg_idmagazynu);


--
--

CREATE INDEX tb_bankirel_norm ON tb_bankirel USING btree (br_nrkontanorm text_pattern_ops);


--
--

CREATE UNIQUE INDEX tb_bankirel_v ON tb_bankirel USING btree (bk_idbanku, (
CASE
    WHEN ((br_flaga & 5) = 4) THEN 1
    ELSE NULL::integer
END));


--
--

CREATE INDEX tb_chat_history_chh_chc_id ON tb_chat_history USING btree (chh_chc_id);


--
--

CREATE INDEX tb_chat_history_chh_p_idpracownika ON tb_chat_history USING btree (chh_p_idpracownika);


--
--

CREATE INDEX tb_chat_members_chm_chc_id ON tb_chat_members USING btree (chm_chc_id);


--
--

CREATE INDEX tb_chat_members_chm_p_idpracownika ON tb_chat_members USING btree (chm_p_idpracownika);


--
--

CREATE INDEX tb_comments_index2 ON tb_comments USING btree (com_datatype, com_subdatatype, com_context);


--
--

CREATE INDEX tb_cyklicznosc_index1 ON tb_cyklicznosc USING btree (zd_idzdarzenia);


--
--

CREATE INDEX tb_cyklwyjatki_index1 ON tb_cyklwyjatki USING btree (ck_idcyklu);


--
--

CREATE INDEX tb_etapprojektu_szl_idstatusu_idx ON tb_etapprojektu USING btree (fm_idcentrali, szl_idstatusu);


--
--

CREATE INDEX tb_euronipy_index1 ON tb_euronipy USING btree (eun_nip);


--
--

CREATE INDEX tb_flowchart_connections_fct_id_idx ON tb_flowchart_connections USING btree (fct_id);


--
--

CREATE INDEX tb_flowchart_elements_fct_id_idx ON tb_flowchart_elements USING btree (fct_id);


--
--

CREATE UNIQUE INDEX tb_flowchart_elements_idelement ON tb_flowchart_elements USING btree (fct_id, fce_element_id);


--
--

CREATE INDEX tb_funkcjepracownikow_funkcja ON tb_funkcjepracownikow USING btree (fp_funkcja);


--
--

CREATE INDEX tb_funkcjepracownikow_pracownik ON tb_funkcjepracownikow USING btree (p_idpracownika);


--
--

CREATE INDEX tb_hmsplat_index1 ON tb_hmsplat USING btree (tr_idtrans);


--
--

CREATE INDEX tb_kliencizdarzenia_index1 ON tb_kliencizdarzenia USING btree (k_idklienta);


--
--

CREATE INDEX tb_kliencizdarzenia_index2 ON tb_kliencizdarzenia USING btree (zd_idzdarzenia);


--
--

CREATE INDEX tb_klient_index1 ON tb_klient USING btree (k_nazwa);


--
--

CREATE INDEX tb_klient_index11 ON tb_klient USING btree (k_zgodanaprzetw);


--
--

CREATE INDEX tb_klient_index12 ON tb_klient USING btree (k_nip);


--
--

CREATE INDEX tb_klient_index13 ON tb_klient USING btree (lk_czdomyslny);


--
--

CREATE INDEX tb_klient_index2 ON tb_klient USING btree (rk_idrodzajklienta);


--
--

CREATE INDEX tb_klient_index3 ON tb_klient USING btree (k_ulica);


--
--

CREATE INDEX tb_klient_index4 ON tb_klient USING btree (k_miejscowosc);


--
--

CREATE INDEX tb_klient_index5 ON tb_klient USING btree (pw_idpowiatu);


--
--

CREATE INDEX tb_klient_index6 ON tb_klient USING btree (pw_idpowiatu, k_miejscowosc);


--
--

CREATE INDEX tb_klient_index7 ON tb_klient USING btree (wk_idwagi);


--
--

CREATE INDEX tb_klient_index8 ON tb_klient USING btree (k_czykobieta);


--
--

CREATE INDEX tb_klient_index9 ON tb_klient USING btree (zi_idzrodla);


--
--

CREATE INDEX tb_klient_pkeyind ON tb_klient USING btree (k_idklienta);


--
--

CREATE INDEX tb_klient_region ON tb_klient USING btree (rj_idregionu);


--
--

CREATE INDEX tb_kompensatyhand_index1 ON tb_kompensatyhand USING btree (kh_idfaktury);


--
--

CREATE INDEX tb_kompensatyhand_index2 ON tb_kompensatyhand USING btree (kh_idkorekty);


--
--

CREATE INDEX tb_kontakt_index1 ON tb_kontakt USING btree (lk_idczklienta);


--
--

CREATE INDEX tb_kontakt_index10 ON tb_kontakt USING btree (m_wykonanie);


--
--

CREATE INDEX tb_kontakt_index11 ON tb_kontakt USING btree (m_datawykonania);


--
--

CREATE INDEX tb_kontakt_index12 ON tb_kontakt USING btree (ef_idefektu);


--
--

CREATE INDEX tb_kontakt_index13 ON tb_kontakt USING btree (pc_idprocesu);


--
--

CREATE INDEX tb_kontakt_index14 ON tb_kontakt USING btree (m_pwprowadzajacy);


--
--

CREATE INDEX tb_kontakt_index15 ON tb_kontakt USING btree (m_pwykonujacy);


--
--

CREATE INDEX tb_kontakt_index2 ON tb_kontakt USING btree (a_idakcji);


--
--

CREATE INDEX tb_kontakt_index3 ON tb_kontakt USING btree (p_idpracownika);


--
--

CREATE INDEX tb_kontakt_index4 ON tb_kontakt USING btree (sl_idspotkania);


--
--

CREATE INDEX tb_kontakt_index5 ON tb_kontakt USING btree (rk_idrodzajkontaktu);


--
--

CREATE INDEX tb_kontakt_index6 ON tb_kontakt USING btree (tp_idtypspotkania);


--
--

CREATE INDEX tb_kontakt_index7 ON tb_kontakt USING btree (m_gdziespotkanie);


--
--

CREATE INDEX tb_kontakt_index8 ON tb_kontakt USING btree (m_godzinaspotkania);


--
--

CREATE INDEX tb_kontakt_index9 ON tb_kontakt USING btree (m_celspotkania);


--
--

CREATE INDEX tb_ludzieklienta_index1 ON tb_ludzieklienta USING btree (k_idklienta);


--
--

CREATE INDEX tb_ludzieklienta_index10 ON tb_ludzieklienta USING btree (lk_imieniny);


--
--

CREATE INDEX tb_ludzieklienta_index11 ON tb_ludzieklienta USING btree (lk_urodziny);


--
--

CREATE INDEX tb_ludzieklienta_index2 ON tb_ludzieklienta USING btree (zg_idzwrotu);


--
--

CREATE INDEX tb_ludzieklienta_index3 ON tb_ludzieklienta USING btree (lk_nazwisko);


--
--

CREATE INDEX tb_ludzieklienta_index4 ON tb_ludzieklienta USING btree (lk_nazwisko, lk_imie);


--
--

CREATE INDEX tb_ludzieklienta_index5 ON tb_ludzieklienta USING btree (lk_imie);


--
--

CREATE INDEX tb_ludzieklienta_index6 ON tb_ludzieklienta USING btree (lk_kobieta);


--
--

CREATE INDEX tb_ludzieklienta_index7 ON tb_ludzieklienta USING btree (wd_idwplywu);


--
--

CREATE INDEX tb_ludzieklienta_index8 ON tb_ludzieklienta USING btree (lk_miejscowosc);


--
--

CREATE INDEX tb_ludzieklienta_index9 ON tb_ludzieklienta USING btree (pw_idpowiatu);


--
--

CREATE UNIQUE INDEX tb_mail_processed_idx ON __tb_mail_processed USING btree (mr_email, mr_uid);


--
--

CREATE INDEX tb_mail_processed_maid ON tb_mail_processed USING btree (mpr_maid);


--
--

CREATE INDEX tb_multival_mv_idvalue ON tb_multival USING btree (mv_idvalue);


--
--

CREATE INDEX tb_multival_v_id ON tb_multival USING btree (v_id);


--
--

CREATE INDEX tb_pliki_index1 ON tg_pliki USING btree (tpl_notused_rodzaj);


--
--

CREATE INDEX tb_pliki_index2 ON tg_pliki USING btree (tpl_ref);


--
--

CREATE INDEX tb_powiazanieklcz_index1 ON tb_powiazanieklcz USING btree (k_idklienta);


--
--

CREATE INDEX tb_powiazanieklcz_index2 ON tb_powiazanieklcz USING btree (lk_idczklienta);


--
--

CREATE UNIQUE INDEX tb_powiazanieklcz_index3 ON tb_powiazanieklcz USING btree (k_idklienta, lk_idczklienta);


--
--

CREATE INDEX tb_pp_index1 ON tb_pp USING btree (p_idpracownikafor);


--
--

CREATE INDEX tb_pp_index2 ON tb_pp USING btree (ppm_type, ppm_refid);


--
--

CREATE INDEX tb_pracownicy_index1 ON tb_pracownicy USING btree (p_nazwisko);


--
--

CREATE INDEX tb_pracownicy_index2 ON tb_pracownicy USING btree (p_login);


--
--

CREATE INDEX tb_pracownicy_index3 ON tb_pracownicy USING btree (p_miejscowosc);


--
--

CREATE INDEX tb_pracownicy_index4 ON tb_pracownicy USING btree (p_email);


--
--

CREATE INDEX tb_pracownicy_index5 ON tb_pracownicy USING btree (p_czyaktywny);


--
--

CREATE INDEX tb_pracownicy_index6 ON tb_pracownicy USING btree (st_idstanowiska);


--
--

CREATE INDEX tb_pracownicy_index7 ON tb_pracownicy USING btree (dz_iddzialu);


--
--

CREATE INDEX tb_pracownicyzdarzenia_index1 ON tb_pracownicyzdarzenia USING btree (p_idpracownika);


--
--

CREATE INDEX tb_pracownicyzdarzenia_index2 ON tb_pracownicyzdarzenia USING btree (zd_idzdarzenia);


--
--

CREATE UNIQUE INDEX tb_pracownicyzlecenia_i2 ON tb_pracownicyzlecenia USING btree (zl_idzlecenia, p_idpracownika);


--
--

CREATE INDEX tb_proces_index1 ON tb_proces USING btree (k_idklienta);


--
--

CREATE INDEX tb_proces_index2 ON tb_proces USING btree (pc_czegoprocesdot);


--
--

CREATE INDEX tb_proces_index3 ON tb_proces USING btree (zi_idzrodla);


--
--

CREATE INDEX tb_proces_index4 ON tb_proces USING btree (k_idklienta, pc_nic);


--
--

CREATE INDEX tb_proces_index5 ON tb_proces USING btree (pc_nic);


--
--

CREATE INDEX tb_proces_index6 ON tb_proces USING btree (pc_wartosc);


--
--

CREATE INDEX tb_proces_index7 ON tb_proces USING btree (sc_idsciezki, sc_pozycjawsciezce);


--
--

CREATE INDEX tb_przechowkl_klient ON tb_przechowkl USING btree (k_idklienta);


--
--

CREATE UNIQUE INDEX tb_przechowkl_klientprzechow ON tb_przechowkl USING btree (k_idklienta, sp_idprzechow);


--
--

CREATE UNIQUE INDEX tb_rcp_agregacja_uniq_idx ON tb_rcp_agregacja USING btree (p_idpracownika, rcpa_data);


--
--

CREATE INDEX tb_schowektowarow_i1 ON tb_schowektowarow USING btree (st_hash);


--
--

CREATE UNIQUE INDEX tb_settings_storages_sts_component_sts_context_idx ON tb_settings_storages USING btree (sts_component, sts_context);


--
--

CREATE INDEX tb_settings_stt_sts_id_idx ON tb_settings USING btree (stt_sts_id);


--
--

CREATE UNIQUE INDEX tb_settings_stt_sts_id_stt_ownertype_stt_ownerid_stt_name_idx ON tb_settings USING btree (stt_sts_id, stt_ownertype, stt_ownerid, stt_name);


--
--

CREATE UNIQUE INDEX tb_sheetgui_uidx ON tb_sheetgui USING btree (sgui_sheetuid, sgui_baseuid, sgui_exuid, (COALESCE(p_idpracownika, '-1'::integer)));


--
--

CREATE INDEX tb_tab_index3 ON tb_tag USING btree (tag_datatype, tag_subdatatype, p_idpracownika);


--
--

CREATE INDEX tb_tag_dtindex ON tb_tag USING btree (tag_datatype, tag_subdatatype);


--
--

CREATE INDEX tb_telefony_i1 ON tb_telefony USING btree (ph_datatype, ph_id);


--
--

CREATE INDEX tb_telefony_norm ON tb_telefony USING btree (ph_phonenorm);


--
--

CREATE INDEX tb_telefony_phonenorm ON tb_telefony USING btree (ph_phonenorm);


--
--

CREATE INDEX tb_todo_index1 ON tb_todo USING btree (td_datawpr);


--
--

CREATE INDEX tb_todo_index2 ON tb_todo USING btree (td_zlecajacy);


--
--

CREATE INDEX tb_todo_index3 ON tb_todo USING btree (td_komu);


--
--

CREATE INDEX tb_todo_index4 ON tb_todo USING btree (td_zlecajacy, td_nakiedy);


--
--

CREATE INDEX tb_todo_index5 ON tb_todo USING btree (td_komu, td_nakiedy);


--
--

CREATE INDEX tb_todo_index6 ON tb_todo USING btree (td_datawyk);


--
--

CREATE INDEX tb_todo_index7 ON tb_todo USING btree (m_idkontaktu);


--
--

CREATE INDEX tb_universalfiles_index2 ON tb_universalfiles USING btree (tag_id, ufl_ref);


--
--

CREATE INDEX tb_universalfiles_index3 ON tb_universalfiles USING btree (ufl_ownertype, ufl_ownerid);


--
--

CREATE UNIQUE INDEX tb_ustawieniadomprac_p_f ON tb_ustawieniadomprac USING btree (p_idpracownika, fm_idcentrali);


--
--

CREATE INDEX tb_vphone_history_vph_caller_client ON tb_vphone_history USING btree (vph_caller_client);


--
--

CREATE INDEX tb_vphone_history_vph_caller_clientperson ON tb_vphone_history USING btree (vph_caller_clientperson);


--
--

CREATE INDEX tb_vphone_history_vph_caller_employee ON tb_vphone_history USING btree (vph_caller_employee);


--
--

CREATE INDEX tb_vphone_history_vph_user_employee ON tb_vphone_history USING btree (vph_user_employee);


--
--

CREATE INDEX tb_zdarzenia_extid ON tb_zdarzenia USING btree (zd_extid);


--
--

CREATE INDEX tb_zdarzenia_index1 ON tb_zdarzenia USING btree (p_wpisujacy);


--
--

CREATE INDEX tb_zdarzenia_index2 ON tb_zdarzenia USING btree (p_idpracownika);


--
--

CREATE INDEX tb_zdarzenia_index3 ON tb_zdarzenia USING btree (k_idklienta);


--
--

CREATE INDEX tb_zdarzenia_index4 ON tb_zdarzenia USING btree (lk_idczklienta);


--
--

CREATE INDEX tb_zdarzenia_index5 ON tb_zdarzenia USING btree (ob_idobiektu);


--
--

CREATE INDEX tb_zdarzenia_index6 ON tb_zdarzenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tb_zdarzenia_index7 ON tb_zdarzenia USING btree (szl_idstatusu);


--
--

CREATE INDEX tb_zdarzenia_priority_index1 ON tb_zdarzenia USING btree (zd_priority);


--
--

CREATE INDEX tb_zdarzenia_sortkonta ON tb_zdarzenia USING btree (sortkonta(tozdarzenielpfull(zd_lpprefix, zd_lp), 8, '.'::text) text_pattern_ops);


--
--

CREATE INDEX tb_zdarzenia_sortkontan ON tb_zdarzenia USING btree (sortkonta(tozdarzenielpfull(zd_lpprefix, zd_lp), 8, '.'::text));


--
--

CREATE INDEX tb_zdarzenia_zd_idparent_idx ON tb_zdarzenia USING btree (zd_idparent);


--
--

CREATE INDEX tb_zdarzenia_zd_mail_id_idx ON tb_zdarzenia USING btree (zd_mail_id);


--
--

CREATE INDEX tb_zdarzeniaco_index2 ON tb_zdarzeniaco USING btree (zd_id);


--
--

CREATE INDEX tb_zdarzeniaco_index4 ON tb_zdarzeniaco USING btree (zdo_reftype, zdo_refid, p_idpracownika);


--
--

CREATE INDEX tb_zdpowiazania_index1 ON tb_zdpowiazania USING btree (zd_idzdarzenia);


--
--

CREATE INDEX tb_zdpowiazania_index2 ON tb_zdpowiazania USING btree (zp_idref, zp_datatype);


--
--

CREATE INDEX tc_defaultpdf_idklienta ON tc_defaultpdf USING btree (k_idklienta);


--
--

CREATE INDEX tc_defaultpdf_idustawienia ON tc_defaultpdf USING btree (pdf_idustawienia);


--
--

CREATE UNIQUE INDEX tc_defaultprints_i1 ON tc_defaultprints USING btree (k_idklienta, dprn_variantuid);


--
--

CREATE INDEX tc_ediconfig_i1 ON tc_ediconfig USING btree (k_idklienta);


--
--

CREATE UNIQUE INDEX tc_etykiety_newhash ON tc_etykiety USING btree (zpl_newhash);


--
--

CREATE UNIQUE INDEX tc_params_i1 ON tc_params USING btree (prm_name);


--
--

CREATE INDEX tc_ustawieniapdf_i1 ON tc_ustawieniapdf USING btree (pdf_hashcode);


--
--

CREATE UNIQUE INDEX tc_ustawieniapdf_newhash ON tc_ustawieniapdf USING btree (pdf_newhash);


--
--

CREATE UNIQUE INDEX tc_variantmap_i1 ON tc_variantmap USING btree (vm_variant, pdf_idustawienia);


--
--

CREATE UNIQUE INDEX tc_variantmap_i2 ON tc_variantmap USING btree (vm_variant, zpl_idetykiety);


--
--

CREATE INDEX tf_wyniki_i1 ON tf_wyniki USING btree (fw_idwyniku, fw_id);


--
--

CREATE INDEX tg_abonamelem_abon ON tg_abonamelem USING btree (ab_idabonamentu);


--
--

CREATE INDEX tg_abonamelem_towar ON tg_abonamelem USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_abonamenty_centrala ON tg_abonamenty USING btree (fm_idcentrali);


--
--

CREATE INDEX tg_abonamenty_datado ON tg_abonamenty USING btree (ab_datado);


--
--

CREATE INDEX tg_abonamenty_dataod ON tg_abonamenty USING btree (ab_dataod);


--
--

CREATE INDEX tg_abonamenty_klient ON tg_abonamenty USING btree (k_idklienta);


--
--

CREATE INDEX tg_abonamenty_prac ON tg_abonamenty USING btree (p_idpracownika);


--
--

CREATE INDEX tg_abonamenty_rodzaj ON tg_abonamenty USING btree (ra_idrodzaju);


--
--

CREATE INDEX tg_avizodostawy_index_idtrans ON tg_avizodostawy USING btree (tr_idtrans);


--
--

CREATE INDEX tg_backorder_index1 ON tg_backorder USING btree (ttm_idtowmag, bo_powod);


--
--

CREATE INDEX tg_backorder_index2 ON tg_backorder USING btree (tel_idelemsrc);


--
--

CREATE INDEX tg_backorder_index3 ON tg_backorder USING btree (rc_idruchusrc);


--
--

CREATE INDEX tg_backorder_plan ON tg_backorder USING btree (pz_idplanusrc);


--
--

CREATE INDEX tg_backorder_zlec ON tg_backorder USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_bilety_agent ON tg_bilety USING btree (k_idklienta);


--
--

CREATE INDEX tg_bilety_datap ON tg_bilety USING btree (bl_dataprodukcji);


--
--

CREATE INDEX tg_bilety_datara ON tg_bilety USING btree (bl_datarozagenta);


--
--

CREATE INDEX tg_bilety_datarp ON tg_bilety USING btree (bl_datarozpilota);


--
--

CREATE INDEX tg_bilety_dataw ON tg_bilety USING btree (bl_datawydania);


--
--

CREATE INDEX tg_bilety_idelem ON tg_bilety USING btree (tel_idelem);


--
--

CREATE INDEX tg_bilety_pilot ON tg_bilety USING btree (bl_idpilota);


--
--

CREATE INDEX tg_bilety_prac ON tg_bilety USING btree (p_idpracownika);


--
--

CREATE INDEX tg_bilety_pracra ON tg_bilety USING btree (bl_pracrozagenta);


--
--

CREATE INDEX tg_bilety_pracrp ON tg_bilety USING btree (bl_pracrozpilota);


--
--

CREATE INDEX tg_bilety_pracwyd ON tg_bilety USING btree (bl_pracwydajacy);


--
--

CREATE INDEX tg_bilety_towar ON tg_bilety USING btree (ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tg_ceny_i1 ON tg_ceny USING btree (ttw_idtowaru, (
CASE
    WHEN (tcn_isdefault = true) THEN true
    ELSE NULL::boolean
END));


--
--

CREATE UNIQUE INDEX tg_ceny_i2 ON tg_ceny USING btree (ttw_idtowaru, tgc_idgrupy);


--
--

CREATE INDEX tg_charklientdlatow_ean ON tg_charklientdlatow USING btree (ckdt_ean text_pattern_ops);


--
--

CREATE UNIQUE INDEX tg_charklientdlatow_idklient ON tg_charklientdlatow USING btree (ckdt_k_idklienta, ckdt_ttw_idtowaru);


--
--

CREATE INDEX tg_charklientdlatow_typdost ON tg_charklientdlatow USING btree (ckdt_tda_idtypu);


--
--

CREATE INDEX tg_czescizamienne_index1 ON tg_czescizamienne USING btree (ttw_idtowarusrc);


--
--

CREATE INDEX tg_czescizamienne_index2 ON tg_czescizamienne USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_czescizamienne_index3 ON tg_czescizamienne USING btree (ttw_idtowarusrc, ttw_idtowaru);


--
--

CREATE INDEX tg_documentmasterelem_index1 ON tg_documentmasterelem USING btree (ob_idobiektu);


--
--

CREATE INDEX tg_dostawaelem_i1 ON tg_dostawaelem USING btree (dw_iddostawy);


--
--

CREATE INDEX tg_dostawaelem_i2 ON tg_dostawaelem USING btree (tr_idtrans);


--
--

CREATE INDEX tg_dostawaelem_i3 ON tg_dostawaelem USING btree (pk_idpaczki);


--
--

CREATE INDEX tg_dostawarozdzial_i1 ON tg_dostawarozdzial USING btree (tel_idelem_pzam);


--
--

CREATE INDEX tg_dostawarozdzial_i2 ON tg_dostawarozdzial USING btree (tel_idelem_fz);


--
--

CREATE INDEX tg_dostawy_cen_seria ON tg_dostawy USING btree (fm_idcentrali, dw_seria);


--
--

CREATE INDEX tg_elementobiektu_index2 ON tg_elementobiektu USING btree (ob_idobiektu);


--
--

CREATE INDEX tg_elementobiektu_index3 ON tg_elementobiektu USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_etapyzlecenn_index1 ON tg_etapyzlecen USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_etapyzlecenn_index2 ON tg_etapyzlecen USING btree (szl_idstatusu);


--
--

CREATE INDEX tg_grupytow_lr ON tg_grupytow USING btree (tgr_l, tgr_r);


--
--

CREATE INDEX tg_grupywww_lr ON tg_grupywww USING btree (tgw_l, tgw_r);


--
--

CREATE INDEX tg_hoteleelem_hot ON tg_hoteleelem USING btree (ht_idhotelu);


--
--

CREATE INDEX tg_hoteleelem_struk ON tg_hoteleelem USING btree (hs_idstruktury);


--
--

CREATE INDEX tg_hotelezlecen_idzlec ON tg_hotelezlecen USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_hotelezlecen_klient ON tg_hotelezlecen USING btree (k_idklienta);


--
--

CREATE INDEX tg_hotelezlecen_prac ON tg_hotelezlecen USING btree (p_idpracownika);


--
--

CREATE UNIQUE INDEX tg_inwdetails_i1 ON tg_inwdetails USING btree (ine_id, prt_idpartiipz);


--
--

CREATE INDEX tg_inwdupusty_index1 ON tg_inwdupusty USING btree (k_idklienta);


--
--

CREATE INDEX tg_inwdupusty_index2 ON tg_inwdupusty USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_inwdupusty_index3 ON tg_inwdupusty USING btree (tgr_idgrupy);


--
--

CREATE INDEX tg_inwdupusty_index4 ON tg_inwdupusty USING btree (rk_idrodzajklienta);


--
--

CREATE UNIQUE INDEX tg_inwelems_i1 ON tg_inwelems USING btree (tr_idtrans, (COALESCE(mm_idmiejsca, 0)));


--
--

CREATE INDEX tg_jednostki_index_pkey ON tg_jednostki USING btree (tjn_idjedn);


--
--

CREATE INDEX tg_jednostkialt_ean ON tg_jednostkialt USING btree (ja_ean text_pattern_ops);


--
--

CREATE INDEX tg_jednostkialt_idtowaru ON tg_jednostkialt USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_kalkulacje_tw ON tg_kalkulacje USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_kalkulacjeval_kk ON tg_kalkulacjeval USING btree (kk_idkalk);


--
--

CREATE INDEX tg_kalkulacjeval_pz ON tg_kalkulacjeval USING btree (pz_idplanu);


--
--

CREATE INDEX tg_kalkulacjeval_te ON tg_kalkulacjeval USING btree (tel_idelem);


--
--

CREATE INDEX tg_kalkulacjeval_th ON tg_kalkulacjeval USING btree (tr_idtrans);


--
--

CREATE INDEX tg_kalkulacjeval_zh ON tg_kalkulacjeval USING btree (zl_idzlecenia);


--
--

CREATE UNIQUE INDEX tg_kartypremiowe_i1 ON tg_kartypremiowe USING btree (kr_nrkarty);


--
--

CREATE INDEX tg_kartypremiowe_i2 ON tg_kartypremiowe USING btree (k_idklienta);


--
--

CREATE INDEX tg_kliencilogistyki_klient ON tg_kliencilogistyki USING btree (k_idklienta);


--
--

CREATE INDEX tg_kliencilogistyki_transport ON tg_kliencilogistyki USING btree (lt_idtransportu);


--
--

CREATE INDEX tg_klientzlecenia_kl ON tg_klientzlecenia USING btree (k_idklienta);


--
--

CREATE INDEX tg_klientzlecenia_zl ON tg_klientzlecenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_kompletyzlecenia_index1 ON tg_kompletyzlecenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_konwersje_index1 ON tg_konwersje USING btree (cv_src);


--
--

CREATE INDEX tg_konwersje_index2 ON tg_konwersje USING btree (cv_dest);


--
--

CREATE INDEX tg_konwersje_index3 ON tg_konwersje USING btree (cv_idprocesu);


--
--

CREATE INDEX tg_kpoelem_head ON tg_kpoelem USING btree (kpo_idheadu);


--
--

CREATE INDEX tg_kpoelem_towar ON tg_kpoelem USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_kpohead_centrala ON tg_kpohead USING btree (fm_idcentrali);


--
--

CREATE INDEX tg_kpohead_data ON tg_kpohead USING btree (kpo_data);


--
--

CREATE INDEX tg_kpohead_klient1 ON tg_kpohead USING btree (kpo_idklienta1);


--
--

CREATE INDEX tg_kpohead_klient2 ON tg_kpohead USING btree (kpo_idklienta2);


--
--

CREATE INDEX tg_kpohead_klient3 ON tg_kpohead USING btree (kpo_idklienta3);


--
--

CREATE INDEX tg_kpohead_klient4 ON tg_kpohead USING btree (kpo_idklienta4);


--
--

CREATE INDEX tg_kpohead_kod ON tg_kpohead USING btree (ko_idkodu);


--
--

CREATE UNIQUE INDEX tg_kpohead_numer ON tg_kpohead USING btree (ro_idrodzaju, kpo_rok, kpo_seria, kpo_numer, fm_idcentrali);


--
--

CREATE INDEX tg_kpohead_prac ON tg_kpohead USING btree (p_idpracownika);


--
--

CREATE UNIQUE INDEX tg_kursydok_i1 ON tg_kursdok USING btree (tr_idtrans, wl_idwaluty);


--
--

CREATE UNIQUE INDEX tg_kursywalut_i1 ON tg_kursywalut USING btree (wl_idwaluty, tw_idtabeli, kw_data);


--
--

CREATE INDEX tg_log_data ON tg_log USING btree (lg_date);


--
--

CREATE INDEX tg_log_datad ON tg_log USING btree (((lg_date)::date));


--
--

CREATE INDEX tg_log_index_1 ON tg_log USING btree (lg_ref, lg_typeref);


--
--

CREATE INDEX tg_log_index_2 ON tg_log USING btree (lg_aref, lg_atyperef);


--
--

CREATE UNIQUE INDEX tg_logex_i1 ON tg_logex USING btree (lgex_txt);


--
--

CREATE INDEX tg_loghis_i1 ON tg_loghis USING btree (lgh_startdate, lgh_enddate);


--
--

CREATE INDEX tg_loghis_i2 ON tg_loghis USING btree (lgh_refdatatype, lgh_refid);


--
--

CREATE INDEX tg_logkltrans_klient ON tg_logkltrans USING btree (kl_idklientalog);


--
--

CREATE INDEX tg_logkltrans_transakcja ON tg_logkltrans USING btree (tr_idtrans);


--
--

CREATE UNIQUE INDEX tg_losy_i1 ON tg_losy USING btree (lr_idloterii, los_nrkolejny);


--
--

CREATE UNIQUE INDEX tg_losyanaliza_i1 ON tg_losyanaliza USING btree (tel_idelem);


--
--

CREATE UNIQUE INDEX tg_magazynyfortk ON tg_magazyny USING btree (k_idklienta, fm_idcentrali, (
CASE
    WHEN (tmg_isfortk > 0) THEN tmg_isfortk
    ELSE NULL::smallint
END));


--
--

CREATE INDEX tg_naprawyzlecenia_index1 ON tg_naprawyzlecenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_obiekty_index1 ON tg_obiekty USING btree (k_idklienta);


--
--

CREATE INDEX tg_obiekty_index2 ON tg_obiekty USING btree (ob_datapoczatkowa);


--
--

CREATE INDEX tg_obiekty_index3 ON tg_obiekty USING btree (ob_datakoncowa);


--
--

CREATE INDEX tg_obiekty_index4 ON tg_obiekty USING btree (ob_ref);


--
--

CREATE INDEX tg_obiekty_index5 ON tg_obiekty USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_packelem_i1 ON tg_packelem USING btree (pk_idpaczki);


--
--

CREATE INDEX tg_packelem_i3 ON tg_packelem USING btree (tel_idelem_pzam);


--
--

CREATE INDEX tg_packelem_i4 ON tg_packelem USING btree (tel_idelem_zam);


--
--

CREATE INDEX tg_packelem_tel_idelem_fv ON tg_packelem USING btree (tel_idelem_fv);


--
--

CREATE INDEX tg_packhead_cen_seria ON tg_packhead USING btree (fm_idcentrali, pk_seria);


--
--

CREATE INDEX tg_packhead_i1 ON tg_packhead USING btree (k_idklienta);


--
--

CREATE INDEX tg_packhead_pkidref ON tg_packhead USING btree (pk_idref);


--
--

CREATE INDEX tg_packhead_pkidukl ON tg_packhead USING btree (pk_idukladu);


--
--

CREATE UNIQUE INDEX tg_partie_i1 ON tg_partie USING btree (ttw_idtowaru, prt_wplyw) WHERE ((prt_hashcode IS NULL) AND (k_idklienta IS NULL) AND (zl_idzlecenia IS NULL) AND (prt_serialno IS NULL) AND (prt_datawazn IS NULL) AND (prt_idref IS NULL) AND (prt_terozroznik IS NULL) AND (prt_inkj IS NULL) AND (rmp_idsposobu IS NULL));


--
--

CREATE INDEX tg_partie_i2 ON tg_partie USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_partie_i3 ON tg_partie USING btree (prt_idpartii) WHERE ((prt_hasanystan = true) AND (prt_wplyw > 0));


--
--

CREATE UNIQUE INDEX tg_partie_i4 ON tg_partie USING btree (ttw_idtowaru, prt_idref) WHERE (prt_idref IS NOT NULL);


--
--

CREATE UNIQUE INDEX tg_partie_ui ON tg_partie USING btree (ttw_idtowaru, prt_wplyw, (COALESCE(prt_hashcode, '01234567-8901-2345-6789-012345678901'::uuid)), (COALESCE(k_idklienta, '-1'::integer)), (COALESCE(zl_idzlecenia, '-1'::integer)), (COALESCE(prt_serialno, 'Dummy'::text)), (COALESCE(prt_datawazn, '1950-01-01'::date)), (COALESCE(prt_idref, '-1'::integer)), (COALESCE(prt_terozroznik, '-1'::integer)), (COALESCE((prt_inkj)::integer, '-1'::integer)), (COALESCE(rmp_idsposobu, '-1'::integer)));


--
--

CREATE INDEX tg_partiehelper_i1 ON tg_partiehelper USING btree (ttw_idtowaru, prt_idpartii);


--
--

CREATE UNIQUE INDEX tg_partietm_i1 ON tg_partietm USING btree (prt_idpartii, ttm_idtowmag);


--
--

CREATE INDEX tg_planzlecenia_idsrcelem ON tg_planzlecenia USING btree (tel_idsrcelem);


--
--

CREATE INDEX tg_planzlecenia_idzlec ON tg_planzlecenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_planzlecenia_kodn ON tg_planzlecenia USING btree (pz_kod);


--
--

CREATE INDEX tg_planzlecenia_obiekt ON tg_planzlecenia USING btree (ob_idobiektu);


--
--

CREATE INDEX tg_planzlecenia_tow ON tg_planzlecenia USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_planzlecenia_waluta ON tg_planzlecenia USING btree (wl_idwaluty);


--
--

CREATE INDEX tg_podczepieniadoetapow_index2 ON tg_podczepieniadoetapow USING btree (sz_idetapu);


--
--

CREATE INDEX tg_podczepieniadoetapow_index3 ON tg_podczepieniadoetapow USING btree (pde_ref, pde_typref);


--
--

CREATE INDEX tg_podgrupytow_lr ON tg_podgrupytow USING btree (tpg_l, tpg_r);


--
--

CREATE UNIQUE INDEX tg_powiazaniepaczek_id ON tg_powiazaniepaczek USING btree (pk_idpaczki);


--
--

CREATE UNIQUE INDEX tg_powiazanieplanu_id ON tg_powiazanieplanu USING btree (pz_idplanu);


--
--

CREATE INDEX tg_pphead_doc ON tg_pphead USING btree (tr_idtrans);


--
--

CREATE INDEX tg_ppheadelem_head ON tg_ppheadelem USING btree (pph_idheadu);


--
--

CREATE INDEX tg_ppheadelem_idelem ON tg_ppheadelem USING btree (tel_idelemsrcskoj);


--
--

CREATE UNIQUE INDEX tg_ppheadelem_ref ON tg_ppheadelem USING btree (phe_ref, ttw_idtowaru);


--
--

CREATE INDEX tg_prace_czynnosc ON tg_prace USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_prace_data ON tg_prace USING btree (pr_datapracy);


--
--

CREATE INDEX tg_prace_obiekt ON tg_prace USING btree (ob_idobiektu);


--
--

CREATE INDEX tg_prace_prac ON tg_prace USING btree (p_idpracownika);


--
--

CREATE INDEX tg_prace_zlecenie ON tg_prace USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_praceall_d1 ON tg_praceall USING btree (pra_datastart);


--
--

CREATE INDEX tg_praceall_d2 ON tg_praceall USING btree (pra_datastop);


--
--

CREATE INDEX tg_praceall_podczep ON tg_praceall USING btree (pra_idref, pra_typeref);


--
--

CREATE INDEX tg_praceall_prac ON tg_praceall USING btree (p_idpracownika);


--
--

CREATE INDEX tg_praceall_towar ON tg_praceall USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_praceall_zlec ON tg_praceall USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_produkcja_cen ON tg_produkcja USING btree (fm_idcentrali);


--
--

CREATE INDEX tg_produkcja_receptura ON tg_produkcja USING btree (tsk_idreceptury);


--
--

CREATE INDEX tg_przejazdy_data ON tg_przejazdy USING btree (pr_dataprzejazdu);


--
--

CREATE INDEX tg_przejazdy_prac ON tg_przejazdy USING btree (p_idpracownika);


--
--

CREATE INDEX tg_przejazdy_sam ON tg_przejazdy USING btree (ob_idobiektu);


--
--

CREATE INDEX tg_przejazdy_zlec ON tg_przejazdy USING btree (zl_idzlecenia);


--
--

CREATE UNIQUE INDEX tg_punktykarty_i1 ON tg_punktykarty USING btree (tr_idtrans);


--
--

CREATE INDEX tg_punktykarty_i2 ON tg_punktykarty USING btree (kr_idkarty);


--
--

CREATE INDEX tg_realizacjapzam_index1 ON tg_realizacjapzam USING btree (tel_idpzam, rm_powod);


--
--

CREATE INDEX tg_realizacjapzam_index2 ON tg_realizacjapzam USING btree (tel_idelemsrc);


--
--

CREATE INDEX tg_realizacjapzam_index3 ON tg_realizacjapzam USING btree (pe_idelemuzam);


--
--

CREATE INDEX tg_realizacjapzam_tr ON tg_realizacjapzam USING btree (tr_idtranssrc);


--
--

CREATE INDEX tg_realplanpr_elem ON tg_realizacjaplanuprod USING btree (tel_idelem);


--
--

CREATE INDEX tg_realplanpr_plan ON tg_realizacjaplanuprod USING btree (pz_idplanu);


--
--

CREATE INDEX tg_recchanges_date ON tg_recchanges USING btree (rg_date);


--
--

CREATE INDEX tg_rozliczdelegacja_index1 ON tg_rozliczdelegacja USING btree (lt_idtransportu);


--
--

CREATE INDEX tg_rozliczdelegacja_index2 ON tg_rozliczdelegacja USING btree (k_idklienta);


--
--

CREATE INDEX tg_rozliczdelegacja_index3 ON tg_rozliczdelegacja USING btree (wl_idwaluty);


--
--

CREATE INDEX tg_rozliczdelegacja_index4 ON tg_rozliczdelegacja USING btree (kd_idkartoteki);


--
--

CREATE INDEX tg_rozliczdelegacja_index5 ON tg_rozliczdelegacja USING btree (tr_idtrans);


--
--

CREATE INDEX tg_rozmsppak_kodex ON tg_rozmsppak USING btree (rmp_kodex, ttw_idtowaru_ndx);


--
--

CREATE UNIQUE INDEX tg_rozmsppakelems_i1 ON tg_rozmsppakelems USING btree (rmp_idsposobu, rme_idelemu);


--
--

CREATE UNIQUE INDEX tg_rozmsppakelems_i2 ON tg_rozmsppakelems USING btree (rmp_idsposobu, ttw_idtowaru_pdx);


--
--

CREATE INDEX tg_ruchy_index15 ON tg_ruchy USING btree (ttm_idtowmag, k_idklienta) WHERE (isrezerwacja(rc_flaga) AND (rc_iloscrez > (0)::numeric));


--
--

CREATE INDEX tg_ruchy_index16 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (((rc_iloscpoz - (rc_iloscrez - rc_iloscrezzr)) > (0)::numeric) AND (rc_iloscpoz > (0)::numeric) AND ispzet(rc_flaga) AND (NOT isblockedpz(rc_flaga)));


--
--

CREATE INDEX tg_ruchy_index19 ON tg_ruchy USING btree (rc_dostawa);


--
--

CREATE INDEX tg_ruchy_index_1 ON tg_ruchy USING btree (tel_idelem);


--
--

CREATE INDEX tg_ruchy_index_10 ON tg_ruchy USING btree (ispzet(rc_flaga));


--
--

CREATE INDEX tg_ruchy_index_11 ON tg_ruchy USING btree (isfv(rc_flaga));


--
--

CREATE INDEX tg_ruchy_index_12 ON tg_ruchy USING btree (isrezerwacja(rc_flaga));


--
--

CREATE INDEX tg_ruchy_index_13 ON tg_ruchy USING btree (isbtk(rc_flaga));


--
--

CREATE INDEX tg_ruchy_index_14 ON tg_ruchy USING btree (istk(rc_flaga));


--
--

CREATE INDEX tg_ruchy_index_2 ON tg_ruchy USING btree (tr_idtrans);


--
--

CREATE INDEX tg_ruchy_index_3 ON tg_ruchy USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_ruchy_index_4 ON tg_ruchy USING btree (ttm_idtowmag);


--
--

CREATE INDEX tg_ruchy_index_5 ON tg_ruchy USING btree (tmg_idmagazynu);


--
--

CREATE INDEX tg_ruchy_index_6 ON tg_ruchy USING btree (rc_ruch);


--
--

CREATE INDEX tg_ruchy_index_7 ON tg_ruchy USING btree (rc_rezerwacja);


--
--

CREATE INDEX tg_ruchy_index_8 ON tg_ruchy USING btree (k_idklienta);


--
--

CREATE INDEX tg_ruchy_index_9 ON tg_ruchy USING btree (rc_iloscpoz, rc_flaga);


--
--

CREATE INDEX tg_ruchy_index_seqid ON tg_ruchy USING btree (rc_seqid);


--
--

CREATE INDEX tg_ruchy_mm ON tg_ruchy USING btree (mm_idmiejsca) WHERE ((ispzet(rc_flaga) OR isapzet(rc_flaga)) AND ((rc_iloscpoz > (0)::numeric) OR (rc_iloscwzbuf > (0)::numeric)));


--
--

CREATE INDEX tg_ruchy_mm2 ON tg_ruchy USING btree (mm_idmiejsca) WHERE (ispzet(rc_flaga) OR isapzet(rc_flaga));


--
--

CREATE INDEX tg_ruchy_mrppalety ON tg_ruchy USING btree (mrpp_idpalety);


--
--

CREATE INDEX tg_ruchy_partiipz ON tg_ruchy USING btree (prt_idpartiipz);


--
--

CREATE INDEX tg_ruchy_ruchpz ON tg_ruchy USING btree (rc_ruchpz) WHERE (rc_wspmag <> 0);


--
--

CREATE INDEX tg_ruchy_tex ON tg_ruchy USING btree (tex_idelem);


--
--

CREATE INDEX tg_ruchy_wzi1 ON tg_ruchy USING btree (ttm_idtowmag) WHERE (isfv(rc_flaga) AND ((rc_ilosc - rc_iloscrezzr) > (0)::numeric) AND ((rc_flaga & (1 << 28)) <> 0));


--
--

CREATE INDEX tg_skladnikizestawu_index1 ON tg_skladnikizestawu USING btree (ttw_idtowarusrc);


--
--

CREATE INDEX tg_skladnikizestawu_index2 ON tg_skladnikizestawu USING btree (ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tg_stanyother_index1 ON tg_stanyother USING btree (ttw_idtowaru, k_idklienta);


--
--

CREATE INDEX tg_stanytowmagazyn_index3 ON tg_stanytowmagazyn USING btree (tmg_idmagazynu);


--
--

CREATE UNIQUE INDEX tg_stanytowmagazyn_index4 ON tg_stanytowmagazyn USING btree (ttw_idtowaru, tmg_idmagazynu);


--
--

CREATE INDEX tg_stanytowmagazynmiejsce ON tg_stanytowmagazyn USING btree (mm_idmiejsca);


--
--

CREATE INDEX tg_statusyhistora_tid ON tg_statusyhistoria USING btree (sh_type, sh_idref, sh_aktualny);


--
--

CREATE INDEX tg_statystykazapytan_index2 ON tg_statystykazapytan USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_statystykazapytan_index3 ON tg_statystykazapytan USING btree (p_idpracownika);


--
--

CREATE INDEX tg_swiadectwa_d1 ON tg_swiadectwa USING btree (sw_dataprzyjecia);


--
--

CREATE INDEX tg_swiadectwa_d2 ON tg_swiadectwa USING btree (sw_databadania);


--
--

CREATE INDEX tg_swiadectwa_klient ON tg_swiadectwa USING btree (k_idklienta);


--
--

CREATE INDEX tg_swiadectwa_np ON tg_swiadectwa USING btree (sw_numerproby);


--
--

CREATE UNIQUE INDEX tg_swiadectwa_numer ON tg_swiadectwa USING btree (fm_idcentrali, sw_rodzaj, sw_rok, sw_seria, sw_numer);


--
--

CREATE INDEX tg_swiadectwa_prac ON tg_swiadectwa USING btree (p_idpracownika);


--
--

CREATE INDEX tg_swiadectwa_towar ON tg_swiadectwa USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_swiadruchy_sw ON tg_swiadruchy USING btree (sw_idswiadectwa);


--
--

CREATE INDEX tg_swiadruchy_tel ON tg_swiadruchy USING btree (tel_idelem);


--
--

CREATE UNIQUE INDEX tg_tecontrol_i1 ON tg_tecontrol USING btree (tel_idelem);


--
--

CREATE INDEX tg_teex_i1 ON tg_teex USING btree (tel_idelem);


--
--

CREATE INDEX tg_teex_i2 ON tg_teex USING btree (session_id);


--
--

CREATE INDEX tg_tkelem_index1 ON tg_tkelem USING btree (tr_idtrans);


--
--

CREATE INDEX tg_tkelem_index2 ON tg_tkelem USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_tkelem_index3 ON tg_tkelem USING btree (ttm_idtowmag);


--
--

CREATE INDEX tg_towary_chod ON tg_towary USING btree (((ttw_flaga & 98304)));


--
--

CREATE INDEX tg_towary_ean ON tg_towary USING btree (ttw_ean);


--
--

CREATE INDEX tg_towary_flagatowus ON tg_towary USING btree (((ttw_flaga & ((20 + 262144) + 524288))));


--
--

CREATE INDEX tg_towary_griii ON tg_towary USING btree (((ttw_flaga & 6291456)));


--
--

CREATE INDEX tg_towary_grupai ON tg_towary USING btree (tgr_idgrupy);


--
--

CREATE INDEX tg_towary_grupaii ON tg_towary USING btree (tpg_idpodgrupy);


--
--

CREATE INDEX tg_towary_grupawww ON tg_towary USING btree (tgw_idgrupy);


--
--

CREATE INDEX tg_towary_idxref ON tg_towary USING btree (ttw_idxref) WHERE (ttw_idxref IS NOT NULL);


--
--

CREATE INDEX tg_towary_idxsufix ON tg_towary USING btree (ttw_idxsufix);


--
--

CREATE INDEX tg_towary_ind1 ON tg_towary USING btree (ttw_klucz);


--
--

CREATE INDEX tg_towary_index1 ON tg_towary USING btree (tgr_idgrupy);


--
--

CREATE INDEX tg_towary_index2 ON tg_towary USING btree (tjn_idjedn);


--
--

CREATE INDEX tg_towary_index3 ON tg_towary USING btree (ttw_nazwa);


--
--

CREATE INDEX tg_towary_jedn ON tg_towary USING btree (ttw_idopakowania);


--
--

CREATE INDEX tg_towary_jedn2 ON tg_towary USING btree (ttw_idopakowania2);


--
--

CREATE INDEX tg_towary_pkeyind ON tg_towary USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_towary_ttw_producent ON tg_towary USING btree (ttw_producent);


--
--

CREATE UNIQUE INDEX tg_towaryakcjim_i1 ON tg_towaryakcjim USING btree (zl_idzlecenia, ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tg_towaryakcjim_i2 ON tg_towaryakcjim USING btree (zl_idzlecenia, tgr_idgrupy);


--
--

CREATE UNIQUE INDEX tg_towaryakcjimdet_i1 ON tg_towaryakcjimdet USING btree (ta_idtowaru, k_idklienta);


--
--

CREATE UNIQUE INDEX tg_towaryloterii_i1 ON tg_towaryloterii USING btree (lr_idloterii, ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tg_towaryloterii_i2 ON tg_towaryloterii USING btree (lr_idloterii, tgr_idgrupy);


--
--

CREATE INDEX tg_towmag_index1 ON tg_towmag USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_towmag_index3 ON tg_towmag USING btree (ttw_idtowaru, ttm_idtowmag);


--
--

CREATE INDEX tg_towmag_pkeyind ON tg_towmag USING btree (ttm_idtowmag);


--
--

CREATE INDEX tg_transakcje_cent_rodz ON tg_transakcje USING btree (fm_idcentrali, tr_rodzaj);


--
--

CREATE INDEX tg_transakcje_centrala ON tg_transakcje USING btree (fm_idcentrali);


--
--

CREATE INDEX tg_transakcje_firma ON tg_transakcje USING btree (fm_index);


--
--

CREATE INDEX tg_transakcje_handl ON tg_transakcje USING btree (tr_zaliczonedla);


--
--

CREATE INDEX tg_transakcje_index1 ON tg_transakcje USING btree (tr_rodzaj, tr_seria);


--
--

CREATE INDEX tg_transakcje_index10 ON tg_transakcje USING btree (tr_skojarzona);


--
--

CREATE INDEX tg_transakcje_index11 ON tg_transakcje USING btree (tr_skojlog);


--
--

CREATE INDEX tg_transakcje_index2 ON tg_transakcje USING btree (p_idpracownika);


--
--

CREATE INDEX tg_transakcje_index3 ON tg_transakcje USING btree (tr_datasprzedaz);


--
--

CREATE INDEX tg_transakcje_index4 ON tg_transakcje USING btree (tr_datawystaw);


--
--

CREATE INDEX tg_transakcje_index5 ON tg_transakcje USING btree (k_idklienta);


--
--

CREATE INDEX tg_transakcje_index6 ON tg_transakcje USING btree (tr_knazwa);


--
--

CREATE INDEX tg_transakcje_index7 ON tg_transakcje USING btree (tr_dataplatnosci);


--
--

CREATE INDEX tg_transakcje_index_skojwyn ON tg_transakcje USING btree (tr_skojwyn, tr_rodzaj);


--
--

CREATE INDEX tg_transakcje_index_zlecenia ON tg_transakcje USING btree (zl_idzlecenia);


--
--

CREATE UNIQUE INDEX tg_transakcje_numeracja ON tg_transakcje USING btree (fm_idcentrali, tr_rodzaj, tr_rok, (COALESCE(tr_infix, ''::text)), tr_seria, tr_numer, (COALESCE(tr_wersja, ''::text)));


--
--

CREATE INDEX tg_transakcje_otw ON tg_transakcje USING btree (tr_idtrans) WHERE (((tr_flaga & 128) = 128) AND ((tr_flaga & 512) = 512) AND ((tr_zamknieta & 1) = 0));


--
--

CREATE INDEX tg_transakcje_pkeyind ON tg_transakcje USING btree (tr_idtrans);


--
--

CREATE INDEX tg_transakcje_skojzam ON tg_transakcje USING btree (tr_skojzam);


--
--

CREATE INDEX tg_transakcje_transport ON tg_transakcje USING btree (lt_idtransportu);


--
--

CREATE INDEX tg_transakcje_ukl ON tg_transakcje USING btree (tr_zaliczonoukl);


--
--

CREATE INDEX tg_transelem_data ON tg_transelem USING btree (tel_datawazn);


--
--

CREATE INDEX tg_transelem_idakcji ON tg_transelem USING btree (a_idakcji);


--
--

CREATE INDEX tg_transelem_index1 ON tg_transelem USING btree (tr_idtrans);


--
--

CREATE INDEX tg_transelem_index10 ON tg_transelem USING btree (iscopied(tel_flaga));


--
--

CREATE INDEX tg_transelem_index2 ON tg_transelem USING btree (ttm_idtowmag);


--
--

CREATE INDEX tg_transelem_index4 ON tg_transelem USING btree (tel_skojzam);


--
--

CREATE INDEX tg_transelem_index5 ON tg_transelem USING btree (tel_skojarzony, tel_idelem);


--
--

CREATE INDEX tg_transelem_index6 ON tg_transelem USING btree (tel_skojlog);


--
--

CREATE INDEX tg_transelem_index8 ON tg_transelem USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_transelem_index9 ON tg_transelem USING btree (tel_skojzam);


--
--

CREATE INDEX tg_transelem_partia ON tg_transelem USING btree (prt_idpartii);


--
--

CREATE INDEX tg_transelem_pkeyind ON tg_transelem USING btree (tel_idelem);


--
--

CREATE INDEX tg_transelem_tel_oidklienta1 ON tg_transelem USING btree (tel_oidklienta);


--
--

CREATE INDEX tg_transelem_zestaw ON tg_transelem USING btree (tel_skojzestaw);


--
--

CREATE INDEX tg_transport_klient ON tg_transport USING btree (k_idklienta);


--
--

CREATE INDEX tg_transport_pracownik ON tg_transport USING btree (p_idpracownika);


--
--

CREATE INDEX tg_transport_rodzaj ON tg_transport USING btree (fm_idcentrali, lt_rodzaj);


--
--

CREATE INDEX tg_transport_seria ON tg_transport USING btree (lt_seria);


--
--

CREATE INDEX tg_transport_spedytor ON tg_transport USING btree (sp_idspedytora);


--
--

CREATE INDEX tg_treemembers_f ON tg_treemembers USING btree (te_idelemu_f);


--
--

CREATE INDEX tg_treemembers_sec ON tg_treemembers USING btree (te_idelemu_s);


--
--

CREATE INDEX tg_trees_lr ON tg_trees USING btree (trr_iddrzewa, te_l, te_r);


--
--

CREATE INDEX tg_trees_parent ON tg_trees USING btree (te_parent);


--
--

CREATE INDEX tg_udzielonerabaty_index1 ON tg_udzielonerabaty USING btree (tel_idelem);


--
--

CREATE UNIQUE INDEX tg_vatykraje_i1 ON tg_vatykraje USING btree (pw_idpowiatu, ttv_idvatu);


--
--

CREATE UNIQUE INDEX tg_vatytowarow_i1 ON tg_vatytowarow USING btree (ttw_idtowaru, pw_idpowiatu);


--
--

CREATE INDEX tg_wmsmm_i1 ON tg_wmsmm USING btree (tr_idtrans);


--
--

CREATE INDEX tg_wmsmmruch_i1 ON tg_wmsmmruch USING btree (tr_idtrans);


--
--

CREATE INDEX tg_wolnenumery_index1 ON tg_wolnenumery USING btree (fm_idcentrali, tr_rodzaj, tr_seria, tr_datasprzedaz, tr_infix, tr_rok);


--
--

CREATE INDEX tg_wynagrodzenia_centr_pr ON tg_wynagrodzenia USING btree (fm_idcentrali, p_idpracownika);


--
--

CREATE INDEX tg_wynagrodzeniadok_dokhash ON tg_wynagrodzeniadok USING btree (tr_idtrans, wnd_hashcode);


--
--

CREATE UNIQUE INDEX tg_wynagrodzeniadok_i1 ON tg_wynagrodzeniadok USING btree (fm_idcentrali, tr_idtrans, p_idpracownika, wnd_hashcode, wnd_bduplicate);


--
--

CREATE INDEX tg_zamiennikitow_index2 ON tg_zamiennikitow USING btree (zt_idtowarusrc);


--
--

CREATE INDEX tg_zamiennikitow_index3 ON tg_zamiennikitow USING btree (zt_idtowarudesc);


--
--

CREATE UNIQUE INDEX tg_zamilosci_i1 ON tg_zamilosci USING btree (tel_idelem);


--
--

CREATE INDEX tg_zamilosci_i2 ON tg_zamilosci USING btree (tr_idtrans);


--
--

CREATE INDEX tg_zamilosci_i3 ON tg_zamilosci USING btree (ttw_idtowaru);


--
--

CREATE INDEX tg_zamilosci_i4 ON tg_zamilosci USING btree (tel_skojzestaw);


--
--

CREATE INDEX tg_zlecenia_index1 ON tg_zlecenia USING btree (zl_idzlecenia);


--
--

CREATE INDEX tg_zlecenia_index2 ON tg_zlecenia USING btree (k_idklienta);


--
--

CREATE INDEX tg_zlecenia_index3 ON tg_zlecenia USING btree (k_idzlecajacy);


--
--

CREATE INDEX tg_zlecenia_index4 ON tg_zlecenia USING btree (p_odpowiedzialny);


--
--

CREATE INDEX tg_zlecenia_index5 ON tg_zlecenia USING btree (fm_idcentrali, zl_typ);


--
--

CREATE INDEX tg_zlecenia_index6 ON tg_zlecenia USING btree (pw_idpowiatu);


--
--

CREATE INDEX tg_zlecenia_index7 ON tg_zlecenia USING btree (zl_nazwaold);


--
--

CREATE INDEX tg_zlecenia_index8 ON tg_zlecenia USING btree (zl_datazlecenia);


--
--

CREATE INDEX tg_zlecenia_index9 ON tg_zlecenia USING btree (zl_datazamkniecia);


--
--

CREATE INDEX tg_zlecenia_prorytet ON tg_zlecenia USING btree (zl_prorytet);


--
--

CREATE UNIQUE INDEX tg_zmianycenzakupu_i1 ON tg_zmianycenzakupu USING btree (ttw_idtowaru, tr_idtrans, zcz_typ);


--
--

CREATE INDEX tg_zmianycenzakupu_i2 ON tg_zmianycenzakupu USING btree (fm_idcentrali, zcz_typ, ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tl_tmptowary_i1 ON tl_tmptowary USING btree (ttw_idtowaru);


--
--

CREATE INDEX tl_tmptowarydel_i1 ON tl_tmptowarydel USING btree (tr_idtrans);


--
--

CREATE UNIQUE INDEX tm_customcols_i1 ON tm_customcols USING btree (cc_colid);


--
--

CREATE UNIQUE INDEX tm_dropshtowarmap_i1 ON tm_dropshtowarmap USING btree (fm_idcentralisrc, k_idklientadst, ttw_idtowarusrc);


--
--

CREATE INDEX tm_mail_i1 ON tm_mail USING btree (p_idpracownika, tma_datawyslania, tma_dataproby);


--
--

CREATE UNIQUE INDEX tm_mediainfo_uniq_idx ON tm_mediainfo USING btree (mi_type, mi_idref);


--
--

CREATE UNIQUE INDEX tm_mobileids_ext ON tm_mobileids USING btree (mb_typaplikacji, mb_datatype, mb_extid, mb_exthashcode);


--
--

CREATE INDEX tm_mobileids_v ON tm_mobileids USING btree (mb_typaplikacji, mb_datatype, mb_vid, mb_exthashcode);


--
--

CREATE INDEX tm_przynaleznosci_deleted_i1 ON tm_przynaleznosci_deleted USING btree (mp_lastchanged);


--
--

CREATE UNIQUE INDEX tm_przynaleznosci_id ON tm_przynaleznosci USING btree (mp_idref, mp_type, mp_rodzaj);


--
--

CREATE INDEX tm_przynaleznosci_idref ON tm_przynaleznosci USING btree (mp_idref);


--
--

CREATE UNIQUE INDEX tm_zastapioneidy_uniq_idx ON tm_zastapioneidy USING btree (zsi_datatype, zsi_oldid);


--
--

CREATE INDEX tp_kkwelem_i1 ON tp_kkwelem USING btree (kwh_idheadu);


--
--

CREATE INDEX tp_kkwelem_i2 ON tp_kkwelem USING btree (pp_idpolproduktu);


--
--

CREATE UNIQUE INDEX tp_kkwhead_i1 ON tp_kkwhead USING btree (kwh_sufixnumeru, kwh_nrkolejny);


--
--

CREATE INDEX tp_kkwhead_i2 ON tp_kkwhead USING btree (zl_idzlecenia);


--
--

CREATE INDEX tp_kkwhead_i3 ON tp_kkwhead USING btree (pp_idpolproduktu);


--
--

CREATE UNIQUE INDEX tp_mozliwestanowiska_i1 ON tp_mozliwestanowiska USING btree (ep_idetapu, ob_idobiektu);


--
--

CREATE INDEX tp_ruchy_r1 ON tp_ruchy USING btree (nullzero(kwr_etapsrc), nullzero(kwr_etapdst), nullzero(tel_idelemsrc), nullzero(tel_idelemdst), nullzero(kwh_idheadudst));


--
--

CREATE INDEX tp_wypal_i1 ON tp_wypal USING btree (pp_idpolproduktu);


--
--

CREATE INDEX tp_wypal_i2 ON tp_wypal USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_brygadaelem_ob_idobiektu ON tr_brygadaelem USING btree (ob_idobiektu);


--
--

CREATE INDEX tr_brygadaelem_p_idpracownika ON tr_brygadaelem USING btree (p_idpracownika);


--
--

CREATE INDEX tr_harmonogram_idref ON tr_harmonogram USING btree (hm_reftype, hm_refid);


--
--

CREATE INDEX tr_harmonogram_stanowisko ON tr_harmonogram USING btree (ob_idobiektu);


--
--

CREATE INDEX tr_harmonogram_typ ON tr_harmonogram USING btree (hm_typ);


--
--

CREATE INDEX tr_kkwhead_cen ON tr_kkwhead USING btree (fm_idcentrali);


--
--

CREATE INDEX tr_kkwhead_cen_grupa ON tr_kkwhead USING btree (fm_idcentrali, thg_idgrupy);


--
--

CREATE INDEX tr_kkwhead_datapstart ON tr_kkwhead USING btree (kwh_dataplanstart);


--
--

CREATE INDEX tr_kkwhead_datapstop ON tr_kkwhead USING btree (kwh_dataplanstop);


--
--

CREATE INDEX tr_kkwhead_dataroz ON tr_kkwhead USING btree (kwh_datarozp);


--
--

CREATE INDEX tr_kkwhead_datazak ON tr_kkwhead USING btree (kwh_datazak);


--
--

CREATE INDEX tr_kkwhead_prorytet ON tr_kkwhead USING btree (kwh_prorytet);


--
--

CREATE INDEX tr_kkwhead_sufixnumeru ON tr_kkwhead USING btree (kwh_sufixnumeru);


--
--

CREATE INDEX tr_kkwhead_technologia ON tr_kkwhead USING btree (th_idtechnologii);


--
--

CREATE INDEX tr_kkwhead_wyrob ON tr_kkwhead USING btree (ttw_idtowaru);


--
--

CREATE INDEX tr_kkwhead_zlec ON tr_kkwhead USING btree (zl_idzlecenia);


--
--

CREATE INDEX tr_kkwhead_zlecenie ON tr_kkwhead USING btree (nullzero(zl_idzlecenia));


--
--

CREATE INDEX tr_kkwnod_head ON tr_kkwnod USING btree (kwh_idheadu);


--
--

CREATE INDEX tr_kkwnodplan_kb_idkubelka ON tr_kkwnodplan USING btree (kb_idkubelka);


--
--

CREATE INDEX tr_kkwnodplan_kwe_idelemu ON tr_kkwnodplan USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_kkwnodplan_kwh_idheadu ON tr_kkwnodplan USING btree (kwh_idheadu);


--
--

CREATE UNIQUE INDEX tr_kkwnodprevnext_i1_new ON tr_kkwnodprevnext USING btree (kwh_idheadu, kwe_idnext, kwe_idprev, ((knpn_flaga & ((7 << 2) | (1 << 5)))));


--
--

CREATE INDEX tr_kkwnodprevnext_i2 ON tr_kkwnodprevnext USING btree (kwh_idheadu, kwe_idprev);


--
--

CREATE INDEX tr_kkwnodprevnext_kwe_idnext ON tr_kkwnodprevnext USING btree (kwe_idnext);


--
--

CREATE INDEX tr_kkwnodwyk_datastart ON tr_kkwnodwyk USING btree (knw_datastart);


--
--

CREATE INDEX tr_kkwnodwyk_datawyk ON tr_kkwnodwyk USING btree (knw_datawyk);


--
--

CREATE INDEX tr_kkwnodwyk_elem ON tr_kkwnodwyk USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_kkwnodwyk_flaga_wyk ON tr_kkwnodwyk USING btree (iswykonanieopkkw(knw_flaga));


--
--

CREATE INDEX tr_kkwnodwyk_head ON tr_kkwnodwyk USING btree (kwh_idheadu);


--
--

CREATE INDEX tr_kkwnodwyk_kubelek ON tr_kkwnodwyk USING btree (kb_idkubelka);


--
--

CREATE INDEX tr_kkwnodwyk_slownikwyk ON tr_kkwnodwyk USING btree (tsw_idslownika);


--
--

CREATE INDEX tr_kkwnodwyk_stanowisko ON tr_kkwnodwyk USING btree (ob_idobiektu);


--
--

CREATE INDEX tr_kkwnodwykdet_elem ON tr_kkwnodwykdet USING btree (knw_idelemu);


--
--

CREATE INDEX tr_kkwnodwykdet_head ON tr_kkwnodwykdet USING btree (kwh_idheadu);


--
--

CREATE INDEX tr_kkwnodwykdet_nodelem ON tr_kkwnodwykdet USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_kkwnodwykdet_prac ON tr_kkwnodwykdet USING btree (p_idpracownika);


--
--

CREATE INDEX tr_kkwnodwykpaleta ON tr_kkwnodwyk USING btree (mrpp_idpalety_podpieta);


--
--

CREATE INDEX tr_kubelki_stanowiska ON tr_kubelki USING btree (ob_idobiektu);


--
--

CREATE UNIQUE INDEX tr_kubelki_unikalny ON tr_kubelki USING btree (zm_idzmiany, ob_idobiektu, kb_data);


--
--

CREATE INDEX tr_kubelki_zmiana ON tr_kubelki USING btree (zm_idzmiany);


--
--

CREATE INDEX tr_nodrec_idelem ON tr_nodrec USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_nodrec_idheadu ON tr_nodrec USING btree (kwh_idheadu);


--
--

CREATE INDEX tr_nodrec_towar ON tr_nodrec USING btree (ttw_idtowaru);


--
--

CREATE INDEX tr_nodrec_towmag ON tr_nodrec USING btree (ttm_idtowmag);


--
--

CREATE INDEX tr_powiazanieplanprzychod_nodrec ON tr_powiazanieplanprzychod USING btree (knr_idelemu);


--
--

CREATE INDEX tr_powiazanieplanprzychod_plan ON tr_powiazanieplanprzychod USING btree (pz_idplanu);


--
--

CREATE UNIQUE INDEX tr_pracochlonnosc_uniq_idx ON tr_pracochlonnosc USING btree (ttw_idtowaru, rb_idrodzaju);


--
--

CREATE INDEX tr_pracownicykubelka_kub ON tr_pracownicykubelka USING btree (kb_idkubelka);


--
--

CREATE INDEX tr_pracownicykubelka_prac ON tr_pracownicykubelka USING btree (p_idpracownika);


--
--

CREATE UNIQUE INDEX tr_pracownicykubelka_unikalny ON tr_pracownicykubelka USING btree (kb_idkubelka, p_idpracownika);


--
--

CREATE INDEX tr_rrozchodu_technologia ON tr_rrozchodu USING btree (th_idtechnologii);


--
--

CREATE INDEX tr_ruchy_ii2 ON tr_ruchy USING btree (knr_idelemudst);


--
--

CREATE INDEX tr_ruchy_ii3 ON tr_ruchy USING btree (tel_idelemsrc);


--
--

CREATE INDEX tr_ruchy_ii4 ON tr_ruchy USING btree (tel_idelemdst);


--
--

CREATE INDEX tr_ruchy_ii5 ON tr_ruchy USING btree (kwe_idelemusrc);


--
--

CREATE INDEX tr_ruchy_ii6 ON tr_ruchy USING btree (kwe_idelemudst);


--
--

CREATE INDEX tr_ruchy_ii7 ON tr_ruchy USING btree (knw_idelemusrc);


--
--

CREATE INDEX tr_strukturakonstrukcyjna_centrala ON tr_strukturakonstrukcyjna USING btree (fm_idcentrali);


--
--

CREATE INDEX tr_strukturakonstrukcyjna_technologia ON tr_strukturakonstrukcyjna USING btree (th_idtechnologii);


--
--

CREATE INDEX tr_strukturakonstrukcyjna_towar ON tr_strukturakonstrukcyjna USING btree (ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tr_strukturakonstrukcyjnarel_idstruktur ON tr_strukturakonstrukcyjnarel USING btree (sk_idstrukturyp, sk_idstrukturyc);


--
--

CREATE INDEX tr_technoelem_head ON tr_technoelem USING btree (th_idtechnologii);


--
--

CREATE UNIQUE INDEX tr_technoelem_lp ON tr_technoelem USING btree (th_idtechnologii, the_lp);


--
--

CREATE INDEX tr_technoelemwsp_elem ON tr_technoelemwsp USING btree (the_idelem);


--
--

CREATE INDEX tr_technoelemwsp_tech ON tr_technoelemwsp USING btree (th_idtechnologii);


--
--

CREATE INDEX tr_technologie_cen ON tr_kkwhead USING btree (fm_idcentrali);


--
--

CREATE INDEX tr_technologie_cen_grupa ON tr_kkwhead USING btree (fm_idcentrali, thg_idgrupy);


--
--

CREATE INDEX tr_technologie_plan ON tr_kkwhead USING btree (pz_idplanu);


--
--

CREATE INDEX tr_technologie_towar ON tr_technologie USING btree (ttw_idtowaru);


--
--

CREATE UNIQUE INDEX tr_technoprevnext_i1 ON tr_technoprevnext USING btree (th_idtechnologii, the_idnext, the_idprev);


--
--

CREATE INDEX tr_technoprevnext_idnext ON tr_technoprevnext USING btree (the_idnext);


--
--

CREATE INDEX tr_technostpracy_ob_idobiektu ON tr_technostpracy USING btree (ob_idobiektu);


--
--

CREATE INDEX tr_technostpracy_the_idelem ON tr_technostpracy USING btree (the_idelem);


--
--

CREATE UNIQUE INDEX tr_wariantelem_kwe_idelemu ON tr_wariantelem USING btree (kwe_idelemu);


--
--

CREATE INDEX tr_wt_tmp_id ON tr_wt_tmp USING btree (ide);


--
--

CREATE INDEX tr_wt_tmp_seq ON tr_wt_tmp USING btree (seq);


--
--

CREATE UNIQUE INDEX ts_banki_v ON ts_banki USING btree (bk_nrkontanorm text_pattern_ops, (
CASE
    WHEN (bk_type = 8) THEN 1
    ELSE NULL::integer
END));


--
--

CREATE INDEX ts_branze_index1 ON ts_branze USING btree (br_nazwa);


--
--

CREATE INDEX ts_branze_index2 ON ts_branze USING btree (br_opis);


--
--

CREATE INDEX ts_branze_index3 ON ts_branze USING btree (pf_idprofilu);


--
--

CREATE INDEX ts_dniustawowowolne_data ON ts_dniustawowowolne USING btree (duw_data);


--
--

CREATE INDEX ts_dzialy_index1 ON ts_dzialy USING btree (dz_nazwa);


--
--

CREATE INDEX ts_dzialy_index2 ON ts_dzialy USING btree (dz_opis);


--
--

CREATE INDEX ts_efekt_index1 ON ts_efekt USING btree (ef_opis);


--
--

CREATE INDEX ts_elementyrodzajuobiektu_index1 ON ts_elementyrodzajuobiektu USING btree (rb_idrodzaju);


--
--

CREATE INDEX ts_elementyrodzajuobiektu_index2 ON ts_elementyrodzajuobiektu USING btree (ero_typ);


--
--

CREATE INDEX ts_elementyrodzajuobiektu_index3 ON ts_elementyrodzajuobiektu USING btree (rb_idrodzaju, ero_typ);


--
--

CREATE UNIQUE INDEX ts_exsystems_i1 ON ts_exsystems USING btree (exs_kod);


--
--

CREATE INDEX ts_kartotekadelegacji_index1 ON ts_kartotekadelegacji USING btree (wl_idwaluty);


--
--

CREATE UNIQUE INDEX ts_miejscamagazynowe_docfor ON ts_miejscamagazynowe USING btree (mm_magazyn, tr_idtransfor) WHERE (tr_idtransfor IS NOT NULL);


--
--

CREATE UNIQUE INDEX ts_miejscamagazynowe_eafs ON ts_miejscamagazynowe USING btree (mm_idmiejsca) WHERE (mm_isleaf = true);


--
--

CREATE INDEX ts_miejscamagazynowe_lr ON ts_miejscamagazynowe USING btree (mm_l, mm_r);


--
--

CREATE INDEX ts_miejscamagazynowe_parent ON ts_miejscamagazynowe USING btree (mm_parent);


--
--

CREATE INDEX ts_multivalues_i1 ON ts_multivalues USING btree (mv_type, mv_znaczenie, mv_nzmiennej);


--
--

CREATE INDEX ts_osrodkipk_lr ON ts_osrodkipk USING btree (opk_l, opk_r);


--
--

CREATE INDEX ts_powiaty_index1 ON ts_powiaty USING btree (pw_nazwa);


--
--

CREATE INDEX ts_powiaty_index2 ON ts_powiaty USING btree (pw_wojewodztwo);


--
--

CREATE INDEX ts_powiaty_index3 ON ts_powiaty USING btree (pw_wojewodztwo, pw_nazwa);


--
--

CREATE INDEX ts_powiaty_index4 ON ts_powiaty USING btree (pw_nazwa, pw_wojewodztwo);


--
--

CREATE UNIQUE INDEX ts_powiaty_wojewodztwo ON ts_powiaty USING btree (pw_wojewodztwo);


--
--

CREATE INDEX ts_powiazaniapnapni_index1 ON ts_powiazaniapnapni USING btree (pnapni_pni);


--
--

CREATE INDEX ts_powiazaniapnapni_index2 ON ts_powiazaniapnapni USING btree (pnapni_pna);


--
--

CREATE INDEX ts_punktywydaniaeprzesylek_index1 ON ts_punktywydaniaeprzesylek USING btree (pwep_pni);


--
--

CREATE INDEX ts_punktywydaniaeprzesylek_index2 ON ts_punktywydaniaeprzesylek USING btree (pwep_kod);


--
--

CREATE INDEX ts_punktywydaniaeprzesylek_index3 ON ts_punktywydaniaeprzesylek USING btree (pwep_miejscowosc);


--
--

CREATE INDEX ts_rodzajklienta_index1 ON ts_rodzajklienta USING btree (rk_typrodzaju);


--
--

CREATE INDEX ts_rodzajklienta_lr ON ts_rodzajklienta USING btree (rk_l, rk_r);


--
--

CREATE INDEX ts_rodzajkontaktu_index1 ON ts_rodzajkontaktu USING btree (rk_opis);


--
--

CREATE UNIQUE INDEX ts_rozmiarykubelkow_uniq_idx ON ts_rozmiarykubelkow USING btree (rk_typrozmiaru, rk_rozmiar);


--
--

CREATE INDEX ts_stanowisko_index1 ON ts_stanowisko USING btree (st_nazwa);


--
--

CREATE INDEX ts_typspotkania_index1 ON ts_typspotkania USING btree (tp_opis);


--
--

CREATE INDEX ts_typzdarzenia_index1 ON ts_typzdarzenia USING btree (tsz_nazwatypu);


--
--

CREATE INDEX ts_wagiklienta_index1 ON ts_wagiklienta USING btree (wk_liczba);


--
--

CREATE INDEX ts_wagiklienta_index2 ON ts_wagiklienta USING btree (wk_opis);


--
--

CREATE INDEX ts_wplywdecyzje_index1 ON ts_wplywdecyzje USING btree (wd_wplyw);


--
--

CREATE INDEX ts_zrodloinf_index1 ON ts_zrodloinf USING btree (zi_opis);


--
--

CREATE INDEX ts_zwrotgrzeczn_index1 ON ts_zwrotgrzeczn USING btree (zg_opiszwrotu);


--
--

CREATE UNIQUE INDEX tvs_services_i1 ON tvs_services USING btree (sv_code, sv_dbhash);


SET search_path = qopt, pg_catalog;
