ALTER TABLE ONLY tb_ecod
    ADD CONSTRAINT ecod_index1 UNIQUE (ecod_symbol);


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_pkey PRIMARY KEY (dkh_id);


--
--

ALTER TABLE ONLY kh_dziennik
    ADD CONSTRAINT kh_dziennik_index_u1 UNIQUE (dz_kod);


--
--

ALTER TABLE ONLY kh_dziennik
    ADD CONSTRAINT kh_dziennik_index_u2 UNIQUE (dz_nazwa);


--
--

ALTER TABLE ONLY kh_dziennik
    ADD CONSTRAINT kh_dziennik_pkey PRIMARY KEY (dz_iddziennika);


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_index_u2 UNIQUE (ro_idroku, kt_ref, p_idpracownika);


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_index_u3 UNIQUE (ro_idroku, kt_ref, k_idklienta);


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_pkey PRIMARY KEY (kt_idkonta);


--
--

ALTER TABLE ONLY kh_kontanorm
    ADD CONSTRAINT kh_kontanorm_pkey PRIMARY KEY (ktn_idkonta);


--
--

ALTER TABLE ONLY kh_kontatyp
    ADD CONSTRAINT kh_kontatyp_pkey PRIMARY KEY (ktt_idtypu);


--
--

ALTER TABLE ONLY kh_kontavatowekh
    ADD CONSTRAINT kh_kontavatowekh_pkey PRIMARY KEY (kv_idkonta);


--
--

ALTER TABLE ONLY kh_konwersjakpir
    ADD CONSTRAINT kh_konwersjakpir_pkey PRIMARY KEY (kk_idkonwersji);


--
--

ALTER TABLE ONLY kh_lata
    ADD CONSTRAINT kh_lata_pkey PRIMARY KEY (ro_idroku);


--
--

ALTER TABLE ONLY kh_obroty
    ADD CONSTRAINT kh_obroty_pkey PRIMARY KEY (ob_id);


--
--

ALTER TABLE ONLY kh_obroty
    ADD CONSTRAINT kh_obroty_u UNIQUE (ro_idroku, kt_idkonta, mn_miesiac);


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT kh_platelem_pkey PRIMARY KEY (pp_idplatelem);


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_pkey PRIMARY KEY (po_idfifo);


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_pkey PRIMARY KEY (pl_idplatnosc);


--
--

ALTER TABLE ONLY kh_predekretacjainfo
    ADD CONSTRAINT kh_predekretacjainfo_pkey PRIMARY KEY (pd_id);


--
--

ALTER TABLE ONLY kh_raportelem
    ADD CONSTRAINT kh_raportelem_pkey PRIMARY KEY (re_idelementu);


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT kh_raportlisc_pkey PRIMARY KEY (rl_idliscia);


--
--

ALTER TABLE ONLY kh_raportplan
    ADD CONSTRAINT kh_raportplan_pkey PRIMARY KEY (pl_idplanu);


--
--

ALTER TABLE ONLY kh_raportplanelem
    ADD CONSTRAINT kh_raportplanelem_pkey PRIMARY KEY (pe_idelemu);


--
--

ALTER TABLE ONLY kh_raporty
    ADD CONSTRAINT kh_raporty_pkey PRIMARY KEY (rp_idraportu);


--
--

ALTER TABLE ONLY kh_rejestrelem
    ADD CONSTRAINT kh_rejestrelem_pkey PRIMARY KEY (rve_idelem);


--
--

ALTER TABLE ONLY kh_rejestrhead
    ADD CONSTRAINT kh_rejestrhead_pkey PRIMARY KEY (rh_idrejestru);


--
--

ALTER TABLE ONLY kh_wydrukiips_ustawienia
    ADD CONSTRAINT kh_wydrukiips_ustawienia_pkey PRIMARY KEY (wu_idustawienia);


--
--

ALTER TABLE ONLY kh_wymiaryelems
    ADD CONSTRAINT kh_wymiaryelems_pkey PRIMARY KEY (wme_idelemu);


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_pkey PRIMARY KEY (wmo_idobrotu);


--
--

ALTER TABLE ONLY kh_wymiaryonkonto
    ADD CONSTRAINT kh_wymiaryonkonto_pkey PRIMARY KEY (wmk_idelemu);


--
--

ALTER TABLE ONLY kh_wymiaryslownik
    ADD CONSTRAINT kh_wymiaryslownik_pkey PRIMARY KEY (wms_idwymiaru);


--
--

ALTER TABLE ONLY kh_wymiarysumvalues
    ADD CONSTRAINT kh_wymiarysumvalues_pkey PRIMARY KEY (wmm_idsumy);


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_pkey PRIMARY KEY (wmv_idvalue);


--
--

ALTER TABLE ONLY kh_wzorce
    ADD CONSTRAINT kh_wzorce_pkey PRIMARY KEY (wz_idwzorca);


--
--

ALTER TABLE ONLY kh_wzorceelem
    ADD CONSTRAINT kh_wzorceelem_pkey PRIMARY KEY (we_idelementu);


--
--

ALTER TABLE ONLY kh_wzorceelemkpir
    ADD CONSTRAINT kh_wzorceelemkpir_pkey PRIMARY KEY (wk_idelemu);


--
--

ALTER TABLE ONLY kh_wzorceelempks
    ADD CONSTRAINT kh_wzorceelempks_pkey PRIMARY KEY (wep_idelementu);


--
--

ALTER TABLE ONLY kh_wzorceelfiltr
    ADD CONSTRAINT kh_wzorceelfiltr_pkey PRIMARY KEY (wf_idfiltru);


--
--

ALTER TABLE ONLY kh_wzorcekpir
    ADD CONSTRAINT kh_wzorcekpir_pkey PRIMARY KEY (wzk_idwzorca);


--
--

ALTER TABLE ONLY kh_wzorcewymiarow
    ADD CONSTRAINT kh_wzorcewymiarow_pkey PRIMARY KEY (wzw_idwzorca);


--
--

ALTER TABLE ONLY kh_zapisskoj
    ADD CONSTRAINT kh_zapisskoj_pkey PRIMARY KEY (zs_idskoj);


--
--

ALTER TABLE ONLY kh_zapisyelem
    ADD CONSTRAINT kh_zapisyelem_pkey PRIMARY KEY (zp_idelzapisu);


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT kh_zapisyhead_pkey PRIMARY KEY (zk_idzapisu);


--
--

ALTER TABLE ONLY kh_zapisykpir
    ADD CONSTRAINT kh_zapisykpir_pkey PRIMARY KEY (kp_idzapisu);


--
--

ALTER TABLE ONLY kh_zledlugi
    ADD CONSTRAINT kh_zledlugi_pkey PRIMARY KEY (kzl_id);


--
--

ALTER TABLE ONLY kh_zledlugidet
    ADD CONSTRAINT kh_zledlugidet_pkey PRIMARY KEY (kzld_id);


--
--

ALTER TABLE ONLY kr_conv
    ADD CONSTRAINT kr_conv_pkey PRIMARY KEY (cv_id);


--
--

ALTER TABLE ONLY kr_convrr
    ADD CONSTRAINT kr_convrr_pkey PRIMARY KEY (cvr_rrid);


--
--

ALTER TABLE ONLY kr_kompensaty
    ADD CONSTRAINT kr_kompensaty_pkey PRIMARY KEY (km_idkompensaty);


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_pkey PRIMARY KEY (rl_idrozliczenia);


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_pkey PRIMARY KEY (rr_idrozrachunku);


--
--

ALTER TABLE ONLY kr_salda
    ADD CONSTRAINT kr_salda_pkey PRIMARY KEY (sd_idsalda);


--
--

ALTER TABLE ONLY st_amortyzacja
    ADD CONSTRAINT st_amortyzacja_pkey PRIMARY KEY (am_id);


--
--

ALTER TABLE ONLY st_kontastwlatach
    ADD CONSTRAINT st_kontastwlatach_pkey PRIMARY KEY (kwl_id);


--
--

ALTER TABLE ONLY st_planst
    ADD CONSTRAINT st_planst_pkey PRIMARY KEY (pl_idplanu);


--
--

ALTER TABLE ONLY st_srodkitrwale
    ADD CONSTRAINT st_srodkitrwale_index2 UNIQUE (str_nrinwent);


--
--

ALTER TABLE ONLY st_srodkitrwale
    ADD CONSTRAINT st_srodkitrwale_pkey PRIMARY KEY (str_id);


--
--

ALTER TABLE ONLY st_zdarzeniast
    ADD CONSTRAINT st_zdarzeniast_pkey PRIMARY KEY (zd_idzdarzenia);


--
--

ALTER TABLE ONLY tb_akcja
    ADD CONSTRAINT tb_akcja_pkey PRIMARY KEY (a_idakcji);


--
--

ALTER TABLE ONLY tb_api_actiongroup_access
    ADD CONSTRAINT tb_api_actiongroup_access_pkey PRIMARY KEY (aga_id);


--
--

ALTER TABLE ONLY tb_api_actiongroup
    ADD CONSTRAINT tb_api_actiongroup_pkey PRIMARY KEY (apg_id);


--
--

ALTER TABLE ONLY tb_api_profile_access_action
    ADD CONSTRAINT tb_api_profile_access_action_pkey PRIMARY KEY (apa_id);


--
--

ALTER TABLE ONLY tb_api_profile_access_actiongroup
    ADD CONSTRAINT tb_api_profile_access_actiongroup_pkey PRIMARY KEY (apga_id);


--
--

ALTER TABLE ONLY tb_api_profile
    ADD CONSTRAINT tb_api_profile_pkey PRIMARY KEY (apc_id);


--
--

ALTER TABLE ONLY tb_appcustomwindows
    ADD CONSTRAINT tb_appcustomwindows_pkey PRIMARY KEY (acw_id);


--
--

ALTER TABLE ONLY tb_appwindowsstats
    ADD CONSTRAINT tb_appwindowsstats_pkey PRIMARY KEY (aws_id);


--
--

ALTER TABLE ONLY tb_assemblies_content
    ADD CONSTRAINT tb_assemblies_content_pkey PRIMARY KEY (asc_id);


--
--

ALTER TABLE ONLY tb_assemblies
    ADD CONSTRAINT tb_assemblies_pkey PRIMARY KEY (asm_id);


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_pkey PRIMARY KEY (br_idrelacji);


--
--

ALTER TABLE ONLY tb_binarydata
    ADD CONSTRAINT tb_binarydata_pkey PRIMARY KEY (bd_iddata);


--
--

ALTER TABLE ONLY tb_biometricdata
    ADD CONSTRAINT tb_biometricdata_pkey PRIMARY KEY (bmd_id);


--
--

ALTER TABLE ONLY tb_chat_conversation
    ADD CONSTRAINT tb_chat_conversation_pkey PRIMARY KEY (chc_id);


--
--

ALTER TABLE ONLY tb_chat_history
    ADD CONSTRAINT tb_chat_history_pkey PRIMARY KEY (chh_id);


--
--

ALTER TABLE ONLY tb_chat_members
    ADD CONSTRAINT tb_chat_members_pkey PRIMARY KEY (chm_id);


--
--

ALTER TABLE ONLY tb_chatfriends
    ADD CONSTRAINT tb_chatfriends_pkey PRIMARY KEY (ctf_id);


--
--

ALTER TABLE ONLY tb_chatgroup
    ADD CONSTRAINT tb_chatgroup_pkey PRIMARY KEY (ctg_id);


--
--

ALTER TABLE ONLY tb_chatgroupmembers
    ADD CONSTRAINT tb_chatgroupmembers_pkey PRIMARY KEY (ctm_id);


--
--

ALTER TABLE ONLY tb_chatuser
    ADD CONSTRAINT tb_chatuser_pkey PRIMARY KEY (ctu_id);


--
--

ALTER TABLE ONLY tb_comments
    ADD CONSTRAINT tb_comments_pkey PRIMARY KEY (com_id);


--
--

ALTER TABLE ONLY tb_cyklicznosc
    ADD CONSTRAINT tb_cyklicznosc_pkey PRIMARY KEY (ck_idcyklu);


--
--

ALTER TABLE ONLY tb_cyklicznosc
    ADD CONSTRAINT tb_cyklicznosc_zd_idzdarzenia_key UNIQUE (zd_idzdarzenia);


--
--

ALTER TABLE ONLY tb_cyklwyjatki
    ADD CONSTRAINT tb_cyklwyjatki_pkey PRIMARY KEY (cw_idwyjatku);


--
--

ALTER TABLE ONLY tb_datalist_reports
    ADD CONSTRAINT tb_datalist_reports_pkey PRIMARY KEY (dll_id);


--
--

ALTER TABLE ONLY tb_datalist_units
    ADD CONSTRAINT tb_datalist_units_pkey PRIMARY KEY (dlu_id);


--
--

ALTER TABLE ONLY tb_ecod
    ADD CONSTRAINT tb_ecod_pkey PRIMARY KEY (ecod_id);


--
--

ALTER TABLE ONLY tb_etapprojektu
    ADD CONSTRAINT tb_etapprojektu_pkey PRIMARY KEY (pt_idetapu);


--
--

ALTER TABLE ONLY tb_euronipy
    ADD CONSTRAINT tb_euronipy_pkey PRIMARY KEY (eun_ideuronipu);


--
--

ALTER TABLE ONLY tb_filtrelem
    ADD CONSTRAINT tb_filtrelem_pkey PRIMARY KEY (fe_idelemu);


--
--

ALTER TABLE ONLY tb_filtrhead
    ADD CONSTRAINT tb_filtrhead_pkey PRIMARY KEY (fh_idfiltru);


--
--

ALTER TABLE ONLY tb_firma
    ADD CONSTRAINT tb_firma_pkey PRIMARY KEY (fm_index);


--
--

ALTER TABLE ONLY tb_flowchart_connections
    ADD CONSTRAINT tb_flowchart_connections_pkey PRIMARY KEY (fcc_id);


--
--

ALTER TABLE ONLY tb_flowchart_elements
    ADD CONSTRAINT tb_flowchart_elements_pkey PRIMARY KEY (fce_id);


--
--

ALTER TABLE ONLY tb_flowchart
    ADD CONSTRAINT tb_flowchart_pkey PRIMARY KEY (fct_id);


--
--

ALTER TABLE ONLY tb_ftphost
    ADD CONSTRAINT tb_ftphost_pkey PRIMARY KEY (fth_idhost);


--
--

ALTER TABLE ONLY tb_ftpuser
    ADD CONSTRAINT tb_ftpuser_pkey PRIMARY KEY (ftu_iduser);


--
--

ALTER TABLE ONLY tb_funkcjepracownikow
    ADD CONSTRAINT tb_funkcjepracownikow_pkey PRIMARY KEY (fp_idfunprac);


--
--

ALTER TABLE ONLY tb_googleaccounts
    ADD CONSTRAINT tb_googleaccounts_pkey PRIMARY KEY (gga_id);


--
--

ALTER TABLE ONLY tb_googlesynchronize
    ADD CONSTRAINT tb_googlesynchronize_pkey PRIMARY KEY (ggs_id);


--
--

ALTER TABLE ONLY tb_googlesynchronize_remove
    ADD CONSTRAINT tb_googlesynchronize_remove_pkey PRIMARY KEY (gsr_id);


--
--

ALTER TABLE ONLY tb_hmsplat
    ADD CONSTRAINT tb_hmsplat_pkey PRIMARY KEY (hs_idelementu);


--
--

ALTER TABLE ONLY tb_kalendarzelem
    ADD CONSTRAINT tb_kalendarzelem_pkey PRIMARY KEY (kale_idkalendarzaelem);


--
--

ALTER TABLE ONLY tb_kalendarzhead
    ADD CONSTRAINT tb_kalendarzhead_pkey PRIMARY KEY (kalh_idkalendarzahead);


--
--

ALTER TABLE ONLY tb_keyscontrollers
    ADD CONSTRAINT tb_keyscontrollers_pkey PRIMARY KEY (kct_id);


--
--

ALTER TABLE ONLY tb_klbranza
    ADD CONSTRAINT tb_klbranza_pkey PRIMARY KEY (kb_idklbranza);


--
--

ALTER TABLE ONLY tb_kliencizdarzenia
    ADD CONSTRAINT tb_kliencizdarzenia_pkey PRIMARY KEY (kzd_idklientazd);


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_pkey PRIMARY KEY (k_idklienta);


--
--

ALTER TABLE ONLY tb_kompensatyhand
    ADD CONSTRAINT tb_kompensatyhand_pkey PRIMARY KEY (kh_idkompensaty);


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT tb_kontakt_pkey PRIMARY KEY (m_idkontaktu);


--
--

ALTER TABLE ONLY tb_ludzieklienta
    ADD CONSTRAINT tb_ludzieklienta_pkey PRIMARY KEY (lk_idczklienta);


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_pkey PRIMARY KEY (mac_id);


--
--

ALTER TABLE ONLY tb_mail_certificates
    ADD CONSTRAINT tb_mail_certificates_pkey PRIMARY KEY (mct_id);


--
--

ALTER TABLE ONLY tb_mail_data_addresses
    ADD CONSTRAINT tb_mail_data_addresses_pkey PRIMARY KEY (mal_id);


--
--

ALTER TABLE ONLY tb_mail_data_attachments_data
    ADD CONSTRAINT tb_mail_data_attachments_data_pkey PRIMARY KEY (mad_id);


--
--

ALTER TABLE ONLY tb_mail_data_attachments
    ADD CONSTRAINT tb_mail_data_attachments_pkey PRIMARY KEY (mat_id);


--
--

ALTER TABLE ONLY tb_mail_data
    ADD CONSTRAINT tb_mail_data_pkey PRIMARY KEY (mail_id);


--
--

ALTER TABLE ONLY __tb_mail_processed
    ADD CONSTRAINT tb_mail_processed_pkey PRIMARY KEY (mr_id);


--
--

ALTER TABLE ONLY tb_mail_processed
    ADD CONSTRAINT tb_mail_processed_pkey1 PRIMARY KEY (mpr_id);


--
--

ALTER TABLE ONLY tb_mail_templates
    ADD CONSTRAINT tb_mail_templates_pkey PRIMARY KEY (mtpl_id);


--
--

ALTER TABLE ONLY tb_maps_gpshistory
    ADD CONSTRAINT tb_maps_gpshistory_pkey PRIMARY KEY (gps_id);


--
--

ALTER TABLE ONLY tb_masspayment
    ADD CONSTRAINT tb_masspayment_pkey PRIMARY KEY (mp_idmp);


--
--

ALTER TABLE ONLY tb_menucustomization
    ADD CONSTRAINT tb_menucustomization_pkey PRIMARY KEY (mci_id);


--
--

ALTER TABLE ONLY tb_multival
    ADD CONSTRAINT tb_multival_pkey PRIMARY KEY (v_idvalue);


--
--

ALTER TABLE ONLY tb_packages_arrangement
    ADD CONSTRAINT tb_packages_arrangement_pkey PRIMARY KEY (paa_id);


--
--

ALTER TABLE ONLY tb_packages_containers
    ADD CONSTRAINT tb_packages_containers_pkey PRIMARY KEY (pac_id);


--
--

ALTER TABLE ONLY tb_plugins
    ADD CONSTRAINT tb_plugins_pkey PRIMARY KEY (plu_id);


--
--

ALTER TABLE ONLY tb_plugins_references
    ADD CONSTRAINT tb_plugins_references_pkey PRIMARY KEY (pas_id);


--
--

ALTER TABLE ONLY tb_powiazanieklcz
    ADD CONSTRAINT tb_powiazanieklcz_pkey PRIMARY KEY (pkl_idpowiazania);


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT tb_pp_pkey PRIMARY KEY (ppm_id);


--
--

ALTER TABLE ONLY tb_pracownicy
    ADD CONSTRAINT tb_pracownicy_pkey PRIMARY KEY (p_idpracownika);


--
--

ALTER TABLE ONLY tb_pracownicyzdarzenia
    ADD CONSTRAINT tb_pracownicyzdarzenia_pkey PRIMARY KEY (pzd_idpracownika);


--
--

ALTER TABLE ONLY tb_pracownicyzlecenia
    ADD CONSTRAINT tb_pracownicyzlecenia_pkey PRIMARY KEY (pzl_id);


--
--

ALTER TABLE ONLY tb_proces
    ADD CONSTRAINT tb_proces_pkey PRIMARY KEY (pc_idprocesu);


--
--

ALTER TABLE ONLY tb_progispedycji
    ADD CONSTRAINT tb_progispedycji_pkey PRIMARY KEY (ps_idprogu);


--
--

ALTER TABLE ONLY tb_przechowkl
    ADD CONSTRAINT tb_przechowkl_pkey PRIMARY KEY (pk_idprzechowkl);


--
--

ALTER TABLE ONLY tb_raportgui
    ADD CONSTRAINT tb_raportgui_pkey PRIMARY KEY (rgui_id);


--
--

ALTER TABLE ONLY tb_rcp_agregacja
    ADD CONSTRAINT tb_rcp_agregacja_pkey PRIMARY KEY (rcpa_idagregacji);


--
--

ALTER TABLE ONLY tb_rcp_wydarzenia
    ADD CONSTRAINT tb_rcp_wydarzenia_pkey PRIMARY KEY (rcp_idwydarzenia);


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_pkey PRIMARY KEY (ll_idrelacji);


--
--

ALTER TABLE ONLY tb_rguilists
    ADD CONSTRAINT tb_rguilists_pkey PRIMARY KEY (rguil_id);


--
--

ALTER TABLE ONLY tb_rguival
    ADD CONSTRAINT tb_rguival_pkey PRIMARY KEY (rguiv_id);


--
--

ALTER TABLE ONLY tb_role
    ADD CONSTRAINT tb_role_pkey PRIMARY KEY (rol_id);


--
--

ALTER TABLE ONLY tb_rolepdz
    ADD CONSTRAINT tb_rolepdz_pkey PRIMARY KEY (rpd_id);


--
--

ALTER TABLE ONLY tb_schowektowarow
    ADD CONSTRAINT tb_schowektowarow_pkey PRIMARY KEY (st_idelementu);


--
--

ALTER TABLE ONLY tb_scriptfiles
    ADD CONSTRAINT tb_scriptfiles_pkey PRIMARY KEY (scf_id);


--
--

ALTER TABLE ONLY tb_scripts
    ADD CONSTRAINT tb_scripts_pkey PRIMARY KEY (scr_id);


--
--

ALTER TABLE ONLY tb_settings
    ADD CONSTRAINT tb_settings_pkey PRIMARY KEY (stt_id);


--
--

ALTER TABLE ONLY tb_settings_storages
    ADD CONSTRAINT tb_settings_storages_pkey PRIMARY KEY (sts_id);


--
--

ALTER TABLE ONLY tb_sheetgui
    ADD CONSTRAINT tb_sheetgui_pkey PRIMARY KEY (sgui_id);


--
--

ALTER TABLE ONLY tb_signparams
    ADD CONSTRAINT tb_signparams_pkey PRIMARY KEY (sprms_id);


--
--

ALTER TABLE ONLY tb_tag
    ADD CONSTRAINT tb_tag_pkey PRIMARY KEY (tag_id);


--
--

ALTER TABLE ONLY tb_telefony
    ADD CONSTRAINT tb_telefony_pkey PRIMARY KEY (ph_idtelefonu);


--
--

ALTER TABLE ONLY tb_telemarketing_telefony
    ADD CONSTRAINT tb_telemarketing_telefony_pkey PRIMARY KEY (tlpr_id);


--
--

ALTER TABLE ONLY tb_todo
    ADD CONSTRAINT tb_todo_pkey PRIMARY KEY (td_idtodo);


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_pkey PRIMARY KEY (plt_id);


--
--

ALTER TABLE ONLY tb_universalfiles
    ADD CONSTRAINT tb_universalfiles_pkey PRIMARY KEY (ufl_id);


--
--

ALTER TABLE ONLY tb_ustawieniadomprac
    ADD CONSTRAINT tb_ustawieniadomprac_pkey PRIMARY KEY (pu_idustawienia);


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_pkey PRIMARY KEY (vz_id);


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_pkey PRIMARY KEY (vph_id);


--
--

ALTER TABLE ONLY tb_wiadomoscdnia
    ADD CONSTRAINT tb_wiadomoscdnia_pkey PRIMARY KEY (wd_idwiadomosci);


--
--

ALTER TABLE ONLY tb_zdarzenia_flags
    ADD CONSTRAINT tb_zdarzenia_flags_pkey PRIMARY KEY (zdf_id);


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_pkey PRIMARY KEY (zd_idzdarzenia);


--
--

ALTER TABLE ONLY tb_zdarzenia_priority
    ADD CONSTRAINT tb_zdarzenia_priority_pkey PRIMARY KEY (zpr_zd_idzdarzenia);


--
--

ALTER TABLE ONLY tb_zdarzeniaco
    ADD CONSTRAINT tb_zdarzeniaco_pkey PRIMARY KEY (zdo_id);


--
--

ALTER TABLE ONLY tb_zdarzeniaetapzlecenia
    ADD CONSTRAINT tb_zdarzeniaetapzlecenia_pkey PRIMARY KEY (zez_id);


--
--

ALTER TABLE ONLY tb_zdarzeniainfo
    ADD CONSTRAINT tb_zdarzeniainfo_pkey PRIMARY KEY (zdi_id);


--
--

ALTER TABLE ONLY tb_zdarzeniapt
    ADD CONSTRAINT tb_zdarzeniapt_pkey PRIMARY KEY (zdp_id);


--
--

ALTER TABLE ONLY tb_zdarzeniaptlist
    ADD CONSTRAINT tb_zdarzeniaptlist_pkey PRIMARY KEY (zdl_id);


--
--

ALTER TABLE ONLY tb_zdpowiazania
    ADD CONSTRAINT tb_zdpowiazania_pkey PRIMARY KEY (zp_idpowiazania);


--
--

ALTER TABLE ONLY tb_zlecenia_skojarzone
    ADD CONSTRAINT tb_zlecenia_skojarzone_pkey PRIMARY KEY (zls_id);


--
--

ALTER TABLE ONLY tc_config
    ADD CONSTRAINT tc_config_pkey PRIMARY KEY (cf_idconf);


--
--

ALTER TABLE ONLY tc_defaultpdf
    ADD CONSTRAINT tc_defaultpdf_pkey PRIMARY KEY (dpdf_id);


--
--

ALTER TABLE ONLY tc_defaultprints
    ADD CONSTRAINT tc_defaultprints_pkey PRIMARY KEY (dprn_id);


--
--

ALTER TABLE ONLY tc_ediconfig
    ADD CONSTRAINT tc_ediconfig_pkey PRIMARY KEY (edi_idkonta);


--
--

ALTER TABLE ONLY tc_etykiety
    ADD CONSTRAINT tc_etykiety_pkey PRIMARY KEY (zpl_idetykiety);


--
--

ALTER TABLE ONLY tc_pdfaktualizacja
    ADD CONSTRAINT tc_pdfaktualizacja_pkey PRIMARY KEY (sza_idaktualizacji);


--
--

ALTER TABLE ONLY tc_powiazaniastatusowlp
    ADD CONSTRAINT tc_powiazaniastatusowlp_pkey PRIMARY KEY (psl_idpowiazania);


--
--

ALTER TABLE ONLY tc_powiazaniastatusowlp
    ADD CONSTRAINT tc_powiazaniastatusowlp_uniq_idx UNIQUE (sp_idspedytora, psl_remotestatus);


--
--

ALTER TABLE ONLY tc_sekwencje
    ADD CONSTRAINT tc_sekwencje_pkey PRIMARY KEY (skw_id);


--
--

ALTER TABLE ONLY tc_ustawieniapdf
    ADD CONSTRAINT tc_ustawieniapdf_pkey PRIMARY KEY (pdf_idustawienia);


--
--

ALTER TABLE ONLY tc_variantmap
    ADD CONSTRAINT tc_variantmap_pkey PRIMARY KEY (vm_id);


--
--

ALTER TABLE ONLY tf_klocekparams
    ADD CONSTRAINT tf_klocekparams_pkey PRIMARY KEY (fp_idparamu);


--
--

ALTER TABLE ONLY tf_raport
    ADD CONSTRAINT tf_raport_pkey PRIMARY KEY (fr_idraportu);


--
--

ALTER TABLE ONLY tf_raportklocki
    ADD CONSTRAINT tf_raportklocki_pkey PRIMARY KEY (fk_idklocka);


--
--

ALTER TABLE ONLY tf_wyniki
    ADD CONSTRAINT tf_wyniki_pkey PRIMARY KEY (fw_idrekordu);


--
--

ALTER TABLE ONLY tg_abonamelem
    ADD CONSTRAINT tg_abonamelem_pkey PRIMARY KEY (ae_idelemu);


--
--

ALTER TABLE ONLY tg_abonamenty
    ADD CONSTRAINT tg_abonamenty_pkey PRIMARY KEY (ab_idabonamentu);


--
--

ALTER TABLE ONLY tg_avizodostawy
    ADD CONSTRAINT tg_avizodostawy_pkey PRIMARY KEY (ad_idaviza);


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_pkey PRIMARY KEY (bo_idbackord);


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_pkey PRIMARY KEY (bl_idbiletu);


--
--

ALTER TABLE ONLY tg_ceny
    ADD CONSTRAINT tg_ceny_pkey PRIMARY KEY (tcn_idceny);


--
--

ALTER TABLE ONLY tg_charklientdlatow
    ADD CONSTRAINT tg_charklientdlatow_pkey PRIMARY KEY (ckdt_idkartoteki);


--
--

ALTER TABLE ONLY tg_czescizamienne
    ADD CONSTRAINT tg_czescizamienne_pkey PRIMARY KEY (cz_idczesci);


--
--

ALTER TABLE ONLY tg_documentmasterelem
    ADD CONSTRAINT tg_documentmasterelem_pkey PRIMARY KEY (dme_idelem);


--
--

ALTER TABLE ONLY tg_dostawaelem
    ADD CONSTRAINT tg_dostawaelem_pkey PRIMARY KEY (de_idelemu);


--
--

ALTER TABLE ONLY tg_dostawarozdzial
    ADD CONSTRAINT tg_dostawarozdzial_pkey PRIMARY KEY (dr_idrozdzialu);


--
--

ALTER TABLE ONLY tg_dostawy
    ADD CONSTRAINT tg_dostawy_pkey PRIMARY KEY (dw_iddostawy);


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_pkey PRIMARY KEY (eo_idelementu);


--
--

ALTER TABLE ONLY tg_elslownika
    ADD CONSTRAINT tg_elslownika_pkey PRIMARY KEY (es_idelem);


--
--

ALTER TABLE ONLY tg_eltabeli
    ADD CONSTRAINT tg_eltabeli_pkey PRIMARY KEY (et_idelementu);


--
--

ALTER TABLE ONLY tg_etapyzlecen
    ADD CONSTRAINT tg_etapyzlecennew_pkey PRIMARY KEY (sz_idetapu);


--
--

ALTER TABLE ONLY tg_fkalkulacji
    ADD CONSTRAINT tg_fkalkulacji_i1 UNIQUE (ttw_idtowaru);


--
--

ALTER TABLE ONLY tg_fkalkulacji
    ADD CONSTRAINT tg_fkalkulacji_pkey PRIMARY KEY (f_idformuly);


--
--

ALTER TABLE ONLY tg_grupytow
    ADD CONSTRAINT tg_grupytow_pkey PRIMARY KEY (tgr_idgrupy);


--
--

ALTER TABLE ONLY tg_grupywww
    ADD CONSTRAINT tg_grupywww_pkey PRIMARY KEY (tgw_idgrupy);


--
--

ALTER TABLE ONLY tg_hoteleelem
    ADD CONSTRAINT tg_hoteleelem_pkey PRIMARY KEY (he_idelemu);


--
--

ALTER TABLE ONLY tg_hotelezlecen
    ADD CONSTRAINT tg_hotelezlecen_pkey PRIMARY KEY (ht_idhotelu);


--
--

ALTER TABLE ONLY tg_ignorowaneeany
    ADD CONSTRAINT tg_ignorowaneeany_pkey PRIMARY KEY (ie_ideanu);


--
--

ALTER TABLE ONLY tg_inwdetailclicks
    ADD CONSTRAINT tg_inwdetailclicks_pkey PRIMARY KEY (inc_id);


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_pkey PRIMARY KEY (ind_id);


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_pkey PRIMARY KEY (iu_idinwdupusty);


--
--

ALTER TABLE ONLY tg_inwelems
    ADD CONSTRAINT tg_inwelems_pkey PRIMARY KEY (ine_id);


--
--

ALTER TABLE ONLY tg_jednostki
    ADD CONSTRAINT tg_jednostki_pkey PRIMARY KEY (tjn_idjedn);


--
--

ALTER TABLE ONLY tg_jednostkialt
    ADD CONSTRAINT tg_jednostkialt_pkey PRIMARY KEY (ja_idjednostki);


--
--

ALTER TABLE ONLY tg_kalkulacje
    ADD CONSTRAINT tg_kalkulacje_pkey PRIMARY KEY (kk_idkalk);


--
--

ALTER TABLE ONLY tg_kalkulacjeval
    ADD CONSTRAINT tg_kalkulacjeval_pkey PRIMARY KEY (kv_idwartosci);


--
--

ALTER TABLE ONLY tg_kartypremiowe
    ADD CONSTRAINT tg_kartypremiowe_pkey PRIMARY KEY (kr_idkarty);


--
--

ALTER TABLE ONLY tg_kliencilogistyki
    ADD CONSTRAINT tg_kliencilogistyki_pkey PRIMARY KEY (kl_idklientalog);


--
--

ALTER TABLE ONLY tg_klientzlecenia
    ADD CONSTRAINT tg_klientzlecenia_pkey PRIMARY KEY (kz_idklienta);


--
--

ALTER TABLE ONLY tg_kompletyzlecenia
    ADD CONSTRAINT tg_kompletyzlecenia_pkey PRIMARY KEY (kz_idkompletu);


--
--

ALTER TABLE ONLY tg_konwersje
    ADD CONSTRAINT tg_konwersje_pkey PRIMARY KEY (cv_idkonwersji);


--
--

ALTER TABLE ONLY tg_kpoelem
    ADD CONSTRAINT tg_kpoelem_pkey PRIMARY KEY (kpe_idelemu);


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_pkey PRIMARY KEY (kpo_idheadu);


--
--

ALTER TABLE ONLY tg_kursdok
    ADD CONSTRAINT tg_kursdok_pkey PRIMARY KEY (kd_idkursu);


--
--

ALTER TABLE ONLY tg_kursywalut
    ADD CONSTRAINT tg_kursywalut_pkey PRIMARY KEY (kw_idkursu);


--
--

ALTER TABLE ONLY tg_listprzewozowy
    ADD CONSTRAINT tg_listprzewozowy_pkey PRIMARY KEY (lt_idtransportu);


--
--

ALTER TABLE ONLY tg_listprzewozowyzbior
    ADD CONSTRAINT tg_listprzewozowyzbior_pkey PRIMARY KEY (lpz_idzbioru);


--
--

ALTER TABLE ONLY tg_log
    ADD CONSTRAINT tg_log_pkey PRIMARY KEY (lg_id);


--
--

ALTER TABLE ONLY tg_logex
    ADD CONSTRAINT tg_logex_pkey PRIMARY KEY (lgex_id);


--
--

ALTER TABLE ONLY tg_loghis
    ADD CONSTRAINT tg_loghis_pkey PRIMARY KEY (lgh_id);


--
--

ALTER TABLE ONLY tg_logkltrans
    ADD CONSTRAINT tg_logkltrans_pkey PRIMARY KEY (lkt_idpowiazania);


--
--

ALTER TABLE ONLY tg_losy
    ADD CONSTRAINT tg_losy_pkey PRIMARY KEY (los_idlosu);


--
--

ALTER TABLE ONLY tg_losyanaliza
    ADD CONSTRAINT tg_losyanaliza_pkey PRIMARY KEY (lan_idanalizy);


--
--

ALTER TABLE ONLY tg_losyelem
    ADD CONSTRAINT tg_losyelem_pkey PRIMARY KEY (lem_idelem);


--
--

ALTER TABLE ONLY tg_loteria
    ADD CONSTRAINT tg_loteria_pkey PRIMARY KEY (lr_idloterii);


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_pkey PRIMARY KEY (tmg_idmagazynu);


--
--

ALTER TABLE ONLY tg_naprawyzlecenia
    ADD CONSTRAINT tg_naprawyzlecenia_pkey PRIMARY KEY (nz_idnaprawy);


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT tg_obiekty_pkey PRIMARY KEY (ob_idobiektu);


--
--

ALTER TABLE ONLY tg_odsetki
    ADD CONSTRAINT tg_odsetki_pkey PRIMARY KEY (os_idstawki);


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_pkey PRIMARY KEY (pe_idelemu);


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_pkey PRIMARY KEY (pk_idpaczki);


--
--

ALTER TABLE ONLY tg_packinfo
    ADD CONSTRAINT tg_packinfo_pkey PRIMARY KEY (pki_idtrans);


--
--

ALTER TABLE ONLY tg_paczkaspedycyjna
    ADD CONSTRAINT tg_paczkaspedycyjna_pkey PRIMARY KEY (ps_idpaczki);


--
--

ALTER TABLE ONLY tg_paczkiprzewozowe
    ADD CONSTRAINT tg_paczkiprzewozowe_pkey PRIMARY KEY (pp_idpaczki);


--
--

ALTER TABLE ONLY tg_partie_narzedzia
    ADD CONSTRAINT tg_partie_narzedzia_pkey PRIMARY KEY (pnr_idpartiinarzedzi);


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_pkey PRIMARY KEY (prt_idpartii);


--
--

ALTER TABLE ONLY tg_partiehelper
    ADD CONSTRAINT tg_partiehelper_pkey PRIMARY KEY (prh_idpartii);


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_pkey PRIMARY KEY (ptm_id);


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_pkey PRIMARY KEY (pz_idplanu);


--
--

ALTER TABLE ONLY tg_pliki
    ADD CONSTRAINT tg_pliki_pkey PRIMARY KEY (tpl_idpliku);


--
--

ALTER TABLE ONLY tg_podczepieniadoetapow
    ADD CONSTRAINT tg_podczepieniadoetapow_pkey PRIMARY KEY (pde_idpodczepienia);


--
--

ALTER TABLE ONLY tg_podgrupytow
    ADD CONSTRAINT tg_podgrupytow_pkey PRIMARY KEY (tpg_idpodgrupy);


--
--

ALTER TABLE ONLY tg_powiazaniepaczek
    ADD CONSTRAINT tg_powiazaniepaczek_pkey PRIMARY KEY (pp_idpowpack);


--
--

ALTER TABLE ONLY tg_powiazanieplanu
    ADD CONSTRAINT tg_powiazanieplanu_pkey PRIMARY KEY (pw_idpowiazania);


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_pkey PRIMARY KEY (ppe_idelemu);


--
--

ALTER TABLE ONLY tg_pphead
    ADD CONSTRAINT tg_pphead_pkey PRIMARY KEY (pph_idheadu);


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_pkey PRIMARY KEY (phe_idheadelemu);


--
--

ALTER TABLE ONLY tg_prace
    ADD CONSTRAINT tg_prace_pkey PRIMARY KEY (pr_idpracy);


--
--

ALTER TABLE ONLY tg_praceall
    ADD CONSTRAINT tg_praceall_pkey PRIMARY KEY (pra_idpracy);


--
--

ALTER TABLE ONLY tg_produkcja
    ADD CONSTRAINT tg_produkcja_pkey PRIMARY KEY (tsk_idskladnika);


--
--

ALTER TABLE ONLY tg_punktykarty
    ADD CONSTRAINT tg_punktykarty_pkey PRIMARY KEY (tr_idtrans);


--
--

ALTER TABLE ONLY tg_realizacjaplanuprod
    ADD CONSTRAINT tg_realizacjaplanuprod_pkey PRIMARY KEY (rpp_idrealizacji);


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_pkey PRIMARY KEY (rm_idrealizacji);


--
--

ALTER TABLE ONLY tg_recchanges
    ADD CONSTRAINT tg_recchanges_pkey PRIMARY KEY (rg_type, rg_id);


--
--

ALTER TABLE ONLY tg_rodzajtransakcji
    ADD CONSTRAINT tg_rodzajtransakcji_pkey PRIMARY KEY (trt_idrodzaju);


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_pkey PRIMARY KEY (rd_idrozliczenia);


--
--

ALTER TABLE ONLY tg_rozmrodzaje
    ADD CONSTRAINT tg_rozmrodzaje_pkey PRIMARY KEY (rmr_idrodzaju);


--
--

ALTER TABLE ONLY tg_rozmrodzajeelems
    ADD CONSTRAINT tg_rozmrodzajeelems_pkey PRIMARY KEY (rme_idelemu);


--
--

ALTER TABLE ONLY tg_rozmsppak
    ADD CONSTRAINT tg_rozmsppak_pkey PRIMARY KEY (rmp_idsposobu);


--
--

ALTER TABLE ONLY tg_rozmsppakelems
    ADD CONSTRAINT tg_rozmsppakelems_pkey PRIMARY KEY (rmk_idelemu);


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_pkey PRIMARY KEY (rc_idruchu);


--
--

ALTER TABLE ONLY tg_skladnikizestawu
    ADD CONSTRAINT tg_skladnikizestawu_pkey PRIMARY KEY (sz_idskladnika);


--
--

ALTER TABLE ONLY tg_slownik
    ADD CONSTRAINT tg_slownik_pkey PRIMARY KEY (sl_idslownika);


--
--

ALTER TABLE ONLY tg_stanyother
    ADD CONSTRAINT tg_stanyother_pkey PRIMARY KEY (so_idstanu);


--
--

ALTER TABLE ONLY tg_stanytowmagazyn
    ADD CONSTRAINT tg_stanytowmagazyn_pkey PRIMARY KEY (stm_idstanu);


--
--

ALTER TABLE ONLY tg_statusyhistoria
    ADD CONSTRAINT tg_statusyhistoria_pkey PRIMARY KEY (sh_idstathis);


--
--

ALTER TABLE ONLY tg_statystykazapytan
    ADD CONSTRAINT tg_statystykazapytan_pkey PRIMARY KEY (sz_idstatystyki);


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_pkey PRIMARY KEY (sw_idswiadectwa);


--
--

ALTER TABLE ONLY tg_swiadruchy
    ADD CONSTRAINT tg_swiadruchy_pkey PRIMARY KEY (sr_idruchu);


--
--

ALTER TABLE ONLY tg_tabelavalues
    ADD CONSTRAINT tg_tabelavalues_i1 UNIQUE (et_idelementux, et_idelementuy);


--
--

ALTER TABLE ONLY tg_tabelavalues
    ADD CONSTRAINT tg_tabelavalues_pkey PRIMARY KEY (vt_idvalue);


--
--

ALTER TABLE ONLY tg_tabele
    ADD CONSTRAINT tg_tabele_pkey PRIMARY KEY (tb_idtabeli);


--
--

ALTER TABLE ONLY tg_tecontrol
    ADD CONSTRAINT tg_tecontrol_pkey PRIMARY KEY (tec_id);


--
--

ALTER TABLE ONLY tg_teex
    ADD CONSTRAINT tg_teex_pkey PRIMARY KEY (tex_idelem);


--
--

ALTER TABLE ONLY tg_tkelem
    ADD CONSTRAINT tg_tkelem_pkey PRIMARY KEY (tk_idelem);


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_pkey PRIMARY KEY (ttw_idtowaru);


--
--

ALTER TABLE ONLY tg_towaryakcjim
    ADD CONSTRAINT tg_towaryakcjim_pkey PRIMARY KEY (ta_idtowaru);


--
--

ALTER TABLE ONLY tg_towaryakcjimdet
    ADD CONSTRAINT tg_towaryakcjimdet_pkey PRIMARY KEY (tad_id);


--
--

ALTER TABLE ONLY tg_towaryloterii
    ADD CONSTRAINT tg_towaryloterii_pkey PRIMARY KEY (ltw_idtowaru);


--
--

ALTER TABLE ONLY tg_towaryzlecotwartego
    ADD CONSTRAINT tg_towaryzlecotwartego_pkey PRIMARY KEY (tzt_idtowaruzlec);


--
--

ALTER TABLE ONLY tg_towmag
    ADD CONSTRAINT tg_towmag_pkey PRIMARY KEY (ttm_idtowmag);


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_pkey PRIMARY KEY (tr_idtrans);


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_pkey PRIMARY KEY (tel_idelem);


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_pkey PRIMARY KEY (lt_idtransportu);


--
--

ALTER TABLE ONLY tg_treemembers
    ADD CONSTRAINT tg_treemembers_pkey PRIMARY KEY (tt_idelemu);


--
--

ALTER TABLE ONLY tg_trees
    ADD CONSTRAINT tg_trees_pkey PRIMARY KEY (te_idelemu);


--
--

ALTER TABLE ONLY tg_udzielonerabaty
    ADD CONSTRAINT tg_udzielonerabaty_pkey PRIMARY KEY (ur_idrabatu);


--
--

ALTER TABLE ONLY tg_vaty
    ADD CONSTRAINT tg_vaty_pkey PRIMARY KEY (ttv_idvatu);


--
--

ALTER TABLE ONLY tg_vatykraje
    ADD CONSTRAINT tg_vatykraje_pkey PRIMARY KEY (vk_idvatkraj);


--
--

ALTER TABLE ONLY tg_vatytowarow
    ADD CONSTRAINT tg_vatytowarow_pkey PRIMARY KEY (tv_idvatu);


--
--

ALTER TABLE ONLY tg_voucher
    ADD CONSTRAINT tg_voucher_pkey PRIMARY KEY (vc_idvoucher);


--
--

ALTER TABLE ONLY tg_waluty
    ADD CONSTRAINT tg_waluty_pkey PRIMARY KEY (wl_idwaluty);


--
--

ALTER TABLE ONLY tg_wmsmm
    ADD CONSTRAINT tg_wmsmm_pkey PRIMARY KEY (wmm_idelem);


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_pkey PRIMARY KEY (wmr_idelem);


--
--

ALTER TABLE ONLY tg_wskrez
    ADD CONSTRAINT tg_wskrez_pkey PRIMARY KEY (wr_idwsk);


--
--

ALTER TABLE ONLY tg_wsktkelem
    ADD CONSTRAINT tg_wsktkelem_pkey PRIMARY KEY (wt_idwsk);


--
--

ALTER TABLE ONLY tg_wynagrodzenia
    ADD CONSTRAINT tg_wynagrodzenia_pkey PRIMARY KEY (wg_idwynagrodzenia);


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_pkey PRIMARY KEY (wnd_idwynagrodzenia);


--
--

ALTER TABLE ONLY tg_zamiennikitow
    ADD CONSTRAINT tg_zamiennikitow_pkey PRIMARY KEY (zt_idzamiennika);


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_pkey PRIMARY KEY (zmi_idelemu);


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_new_pkey PRIMARY KEY (zl_idzlecenia);


--
--

ALTER TABLE ONLY tg_zmianacenypz
    ADD CONSTRAINT tg_zmianacenypz_pkey PRIMARY KEY (cpz_idzmiany);


--
--

ALTER TABLE ONLY tg_zmianycenzakupu
    ADD CONSTRAINT tg_zmianycenzakupu_pkey PRIMARY KEY (zcz_id);


--
--

ALTER TABLE ONLY tl_tmptowary
    ADD CONSTRAINT tl_tmptowary_pkey PRIMARY KEY (tl_idtowaru);


--
--

ALTER TABLE ONLY tl_tmptowarydel
    ADD CONSTRAINT tl_tmptowarydel_pkey PRIMARY KEY (tld_idtowaru);


--
--

ALTER TABLE ONLY tm_customcols
    ADD CONSTRAINT tm_customcols_pkey PRIMARY KEY (cc_id);


--
--

ALTER TABLE ONLY tm_customcolvariables
    ADD CONSTRAINT tm_customcolvariables_pkey PRIMARY KEY (ccv_varid);


--
--

ALTER TABLE ONLY tm_debuglog
    ADD CONSTRAINT tm_debuglog_pkey PRIMARY KEY (dl_id);


--
--

ALTER TABLE ONLY tm_dropshtowarmap
    ADD CONSTRAINT tm_dropshtowarmap_pkey PRIMARY KEY (dst_id);


--
--

ALTER TABLE ONLY tm_hasla
    ADD CONSTRAINT tm_hasla_pkey PRIMARY KEY (hh_idhasla);


--
--

ALTER TABLE ONLY tm_mail
    ADD CONSTRAINT tm_mail_pkey PRIMARY KEY (tma_idmail);


--
--

ALTER TABLE ONLY tm_mediainfo
    ADD CONSTRAINT tm_mediainfo_pkey PRIMARY KEY (mi_idmediainfo);


--
--

ALTER TABLE ONLY tm_mobileids
    ADD CONSTRAINT tm_mobileids_pkey PRIMARY KEY (mb_idrelacji);


--
--

ALTER TABLE ONLY tm_mobileprofiles
    ADD CONSTRAINT tm_mobileprofiles_pkey PRIMARY KEY (mpf_id);


--
--

ALTER TABLE ONLY tm_mobileprofiles
    ADD CONSTRAINT tm_mobileprofiles_uniq_idx UNIQUE (mpf_typaplikacji, mpf_nazwa);


--
--

ALTER TABLE ONLY tm_przynaleznosci_deleted
    ADD CONSTRAINT tm_przynaleznosci_deleted_pkey PRIMARY KEY (mp_idref, mp_type, mp_rodzaj);


--
--

ALTER TABLE ONLY tm_przynaleznosci
    ADD CONSTRAINT tm_przynaleznosci_pkey PRIMARY KEY (mp_idprzywiazania);


--
--

ALTER TABLE ONLY tm_uprawnienia
    ADD CONSTRAINT tm_uprawnienia_pkey PRIMARY KEY (tu_iduprawnienia);


--
--

ALTER TABLE ONLY tm_volatiles
    ADD CONSTRAINT tm_volatiles_pkey PRIMARY KEY (vs_ctx, vs_key);


--
--

ALTER TABLE ONLY to_zmianacenypz
    ADD CONSTRAINT to_zmianacenypz_pkey PRIMARY KEY (ocpz_idorder);


--
--

ALTER TABLE ONLY tp_etappolproduktu
    ADD CONSTRAINT tp_etappolproduktu_pkey PRIMARY KEY (ep_idetapu);


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT tp_kkwelem_pkey PRIMARY KEY (kwe_idelemu);


--
--

ALTER TABLE ONLY tp_kkwhead
    ADD CONSTRAINT tp_kkwhead_pkey PRIMARY KEY (kwh_idheadu);


--
--

ALTER TABLE ONLY tp_kkwplan
    ADD CONSTRAINT tp_kkwplan_pkey PRIMARY KEY (kwp_idplanu);


--
--

ALTER TABLE ONLY tp_kkwrecrozchodu
    ADD CONSTRAINT tp_kkwrecrozchodu_pkey PRIMARY KEY (rr_idskladnika);


--
--

ALTER TABLE ONLY tp_mozliwestanowiska
    ADD CONSTRAINT tp_mozliwestanowiska_pkey PRIMARY KEY (ms_idmozliwosci);


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT tp_planonkkw_pkey PRIMARY KEY (kwl_idplanu);


--
--

ALTER TABLE ONLY tp_polprodukty
    ADD CONSTRAINT tp_polprodukty_pkey PRIMARY KEY (pp_idpolproduktu);


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tp_ruchy_pkey PRIMARY KEY (kwr_idruchu);


--
--

ALTER TABLE ONLY tp_stanowiskapracy
    ADD CONSTRAINT tp_stanowiskapracy_pkey PRIMARY KEY (sp_idstanowiska);


--
--

ALTER TABLE ONLY tp_wydzialy
    ADD CONSTRAINT tp_wydzialy_pkey PRIMARY KEY (w_idwydzialu);


--
--

ALTER TABLE ONLY tp_wypal
    ADD CONSTRAINT tp_wypal_pkey PRIMARY KEY (wp_idwypalu);


--
--

ALTER TABLE ONLY tr_brygadaelem
    ADD CONSTRAINT tr_brygadaelem_pkey PRIMARY KEY (be_idbrygadaelemu);


--
--

ALTER TABLE ONLY tr_ciagtech
    ADD CONSTRAINT tr_ciagtech_pkey PRIMARY KEY (ct_idciagu);


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_pkey PRIMARY KEY (dmag_iddyspozycji);


--
--

ALTER TABLE ONLY tr_harmonogram
    ADD CONSTRAINT tr_harmonogram_pkey PRIMARY KEY (hm_idharmonogramu);


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_pkey PRIMARY KEY (kwh_idheadu);


--
--

ALTER TABLE ONLY tr_kkwheadrozm
    ADD CONSTRAINT tr_kkwheadrozm_pkey PRIMARY KEY (kwhr_idelemu);


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_pkey PRIMARY KEY (kwe_idelemu);


--
--

ALTER TABLE ONLY tr_kkwnodplan
    ADD CONSTRAINT tr_kkwnodplan_pkey PRIMARY KEY (knp_idplanu);


--
--

ALTER TABLE ONLY tr_kkwnodprevnext
    ADD CONSTRAINT tr_kkwnodprevnext_pkey PRIMARY KEY (knpn_idelem);


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_pkey PRIMARY KEY (knw_idelemu);


--
--

ALTER TABLE ONLY tr_kkwnodwykdet
    ADD CONSTRAINT tr_kkwnodwykdet_pkey PRIMARY KEY (kwd_idelemu);


--
--

ALTER TABLE ONLY tr_kkwnodwykdetkooperacja
    ADD CONSTRAINT tr_kkwnodwykdetkooperacja_pkey PRIMARY KEY (kwk_idelemu);


--
--

ALTER TABLE ONLY tr_kubelki
    ADD CONSTRAINT tr_kubelki_pkey PRIMARY KEY (kb_idkubelka);


--
--

ALTER TABLE ONLY tr_kubelkisymulacyjne
    ADD CONSTRAINT tr_kubelkisymulacyjne_pkey PRIMARY KEY (ksym_idkubelka);


--
--

ALTER TABLE ONLY tr_matrycaumiejetnosci
    ADD CONSTRAINT tr_matrycaumiejetnosci_pkey PRIMARY KEY (mau_id);


--
--

ALTER TABLE ONLY tr_mrpkalkulacje
    ADD CONSTRAINT tr_mrpkalkulacje_pkey PRIMARY KEY (th_idtechnologii);


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_pkey PRIMARY KEY (mrpp_idpalety);


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_pkey PRIMARY KEY (nrr_idruchu);


--
--

ALTER TABLE ONLY tr_narzedzie_wyk
    ADD CONSTRAINT tr_narzedzie_wyk_pkey PRIMARY KEY (nrw_idwykonania);


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_pkey PRIMARY KEY (knr_idelemu);


--
--

ALTER TABLE ONLY tr_nodrecrozmiarowka
    ADD CONSTRAINT tr_nodrecrozmiarowka_pkey PRIMARY KEY (knr_idelemu);


--
--

ALTER TABLE ONLY tr_operacjetech
    ADD CONSTRAINT tr_operacjetech_pkey PRIMARY KEY (top_idoperacji);


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_pkey PRIMARY KEY (pd_iddefinicji);


--
--

ALTER TABLE ONLY tr_pomiary_powiazania
    ADD CONSTRAINT tr_pomiary_powiazania_pkey PRIMARY KEY (pp_idpowiazania);


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_pkey PRIMARY KEY (pw_idpomiarukkw);


--
--

ALTER TABLE ONLY tr_powiazanieplanprzychod
    ADD CONSTRAINT tr_powiazanieplanprzychod_pkey PRIMARY KEY (ppp_idelem);


--
--

ALTER TABLE ONLY tr_pracochlonnosc
    ADD CONSTRAINT tr_pracochlonnosc_pkey PRIMARY KEY (pch_idpracochlonnosci);


--
--

ALTER TABLE ONLY tr_pracownicykubelka
    ADD CONSTRAINT tr_pracownicykubelka_pkey PRIMARY KEY (pk_idprac);


--
--

ALTER TABLE ONLY tr_przeliczeniestruktur
    ADD CONSTRAINT tr_przeliczeniestruktur_pkey PRIMARY KEY (psk_isprzeliczenia);


--
--

ALTER TABLE ONLY tr_przyczynaprzestojow
    ADD CONSTRAINT tr_przyczynaprzestojow_pkey PRIMARY KEY (pp_idprzyczyny);


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_pkey PRIMARY KEY (trr_idelemu);


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_pkey PRIMARY KEY (kwc_idruchu);


--
--

ALTER TABLE ONLY tr_spinaczoperacji
    ADD CONSTRAINT tr_spinaczoperacji_pkey PRIMARY KEY (spo_idspinacza);


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_pkey PRIMARY KEY (sk_idstruktury);


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjnarel
    ADD CONSTRAINT tr_strukturakonstrukcyjnarel_pkey PRIMARY KEY (skr_idrelacji);


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tr_technoelem_pkey PRIMARY KEY (the_idelem);


--
--

ALTER TABLE ONLY tr_technoelemwsp
    ADD CONSTRAINT tr_technoelemwsp_pkey PRIMARY KEY (knwp_idwspolczynnika);


--
--

ALTER TABLE ONLY tr_technogrupy
    ADD CONSTRAINT tr_technogrupy_pkey PRIMARY KEY (thg_idgrupy);


--
--

ALTER TABLE ONLY tr_technologie
    ADD CONSTRAINT tr_technologie_pkey PRIMARY KEY (th_idtechnologii);


--
--

ALTER TABLE ONLY tr_technoprevnext
    ADD CONSTRAINT tr_technoprevnext_pkey PRIMARY KEY (thpn_idelem);


--
--

ALTER TABLE ONLY tr_technostpracy
    ADD CONSTRAINT tr_technostpracy_pkey PRIMARY KEY (tsp_idstanowiska);


--
--

ALTER TABLE ONLY tr_wariantelem
    ADD CONSTRAINT tr_wariantelem_pkey PRIMARY KEY (ve_idelemu);


--
--

ALTER TABLE ONLY tr_warianthead
    ADD CONSTRAINT tr_warianthead_pkey PRIMARY KEY (vmp_idwariantu);


--
--

ALTER TABLE ONLY tr_zmiany
    ADD CONSTRAINT tr_zmiany_pkey PRIMARY KEY (zm_idzmiany);


--
--

ALTER TABLE ONLY ts_banki
    ADD CONSTRAINT ts_banki_pkey PRIMARY KEY (bk_idbanku);


--
--

ALTER TABLE ONLY ts_bledy
    ADD CONSTRAINT ts_bledy_pkey PRIMARY KEY (bl_idbledu);


--
--

ALTER TABLE ONLY ts_branze
    ADD CONSTRAINT ts_branze_pkey PRIMARY KEY (br_idbranzy);


--
--

ALTER TABLE ONLY ts_charakter_towaru_raben
    ADD CONSTRAINT ts_charakter_towaru_raben_pkey PRIMARY KEY (ctr_idcharak);


--
--

ALTER TABLE ONLY ts_dniustawowowolne
    ADD CONSTRAINT ts_dniustawowowolne_pkey PRIMARY KEY (duw_iddnia);


--
--

ALTER TABLE ONLY ts_drzewa
    ADD CONSTRAINT ts_drzewa_pkey PRIMARY KEY (trr_iddrzewa);


--
--

ALTER TABLE ONLY ts_dzialy
    ADD CONSTRAINT ts_dzialy_pkey PRIMARY KEY (dz_iddzialu);


--
--

ALTER TABLE ONLY ts_efekt
    ADD CONSTRAINT ts_efekt_pkey PRIMARY KEY (ef_idefektu);


--
--

ALTER TABLE ONLY ts_elementyrodzajuobiektu
    ADD CONSTRAINT ts_elementyrodzajuobiektu_pkey PRIMARY KEY (ero_idelementu);


--
--

ALTER TABLE ONLY ts_etapkkw
    ADD CONSTRAINT ts_etapkkw_pkey PRIMARY KEY (ek_idetapu);


--
--

ALTER TABLE ONLY ts_exsystems
    ADD CONSTRAINT ts_exsystems_pkey PRIMARY KEY (exs_id);


--
--

ALTER TABLE ONLY ts_formaplat
    ADD CONSTRAINT ts_formaplat_pkey PRIMARY KEY (pl_formaplat);


--
--

ALTER TABLE ONLY ts_funkcjepracownikow
    ADD CONSTRAINT ts_funkcjepracownikow_pkey PRIMARY KEY (fps_idfunprac);


--
--

ALTER TABLE ONLY ts_grupycen
    ADD CONSTRAINT ts_grupycen_pkey PRIMARY KEY (tgc_idgrupy);


--
--

ALTER TABLE ONLY ts_grupysrtrw
    ADD CONSTRAINT ts_grupysrtrw_index1 UNIQUE (gst_opis);


--
--

ALTER TABLE ONLY ts_grupysrtrw
    ADD CONSTRAINT ts_grupysrtrw_pkey PRIMARY KEY (gst_id);


--
--

ALTER TABLE ONLY ts_hotelestruktura
    ADD CONSTRAINT ts_hotelestruktura_pkey PRIMARY KEY (hs_idstruktury);


--
--

ALTER TABLE ONLY ts_kartotekadelegacji
    ADD CONSTRAINT ts_kartotekadelegacji_pkey PRIMARY KEY (kd_idkartoteki);


--
--

ALTER TABLE ONLY ts_kodyodpadu
    ADD CONSTRAINT ts_kodyodpadu_pkey PRIMARY KEY (ko_idkodu);


--
--

ALTER TABLE ONLY ts_kontavoip
    ADD CONSTRAINT ts_kontavoip_pkey PRIMARY KEY (voip_idkonta);


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_pkey PRIMARY KEY (mm_idmiejsca);


--
--

ALTER TABLE ONLY ts_multivalues
    ADD CONSTRAINT ts_multivalues_pkey PRIMARY KEY (mv_idvalue);


--
--

ALTER TABLE ONLY ts_nazwarejestru
    ADD CONSTRAINT ts_nazwarejestru_pkey PRIMARY KEY (nr_idnazwy);


--
--

ALTER TABLE ONLY ts_operacjagoskpir
    ADD CONSTRAINT ts_operacjagoskpir_pkey PRIMARY KEY (og_idoperacji);


--
--

ALTER TABLE ONLY ts_osrodkipk
    ADD CONSTRAINT ts_osrodkipk_pkey PRIMARY KEY (opk_idosrodka);


--
--

ALTER TABLE ONLY ts_pcn_old
    ADD CONSTRAINT ts_pcn_pkey PRIMARY KEY (pcn_numer);


--
--

ALTER TABLE ONLY ts_pcns
    ADD CONSTRAINT ts_pcns_pkey PRIMARY KEY (pcn_id);


--
--

ALTER TABLE ONLY ts_powiaty
    ADD CONSTRAINT ts_powiaty_pkey PRIMARY KEY (pw_idpowiatu);


--
--

ALTER TABLE ONLY ts_powiazaniapnapni
    ADD CONSTRAINT ts_powiazaniapnapni_pkey PRIMARY KEY (pnapni_id);


--
--

ALTER TABLE ONLY ts_profile
    ADD CONSTRAINT ts_profile_pkey PRIMARY KEY (pf_idprofilu);


--
--

ALTER TABLE ONLY ts_przyczynaawarii
    ADD CONSTRAINT ts_przyczynaawarii_pkey PRIMARY KEY (pa_idawarii);


--
--

ALTER TABLE ONLY ts_punktywydaniaeprzesylek
    ADD CONSTRAINT ts_punktywydaniaeprzesylek_pkey PRIMARY KEY (pwep_idpunktu);


--
--

ALTER TABLE ONLY ts_rabatykwotowe
    ADD CONSTRAINT ts_rabatykwotowe_pkey PRIMARY KEY (rk_idrabatu);


--
--

ALTER TABLE ONLY ts_regiony
    ADD CONSTRAINT ts_regiony_pkey PRIMARY KEY (rj_idregionu);


--
--

ALTER TABLE ONLY ts_rodzajabonamentu
    ADD CONSTRAINT ts_rodzajabonamentu_pkey PRIMARY KEY (ra_idrodzaju);


--
--

ALTER TABLE ONLY ts_rodzajebledow
    ADD CONSTRAINT ts_rodzajebledow_pkey PRIMARY KEY (rbl_idbledu);


--
--

ALTER TABLE ONLY ts_rodzajeobiektow
    ADD CONSTRAINT ts_rodzajeobiektow_pkey PRIMARY KEY (rb_idrodzaju);


--
--

ALTER TABLE ONLY ts_rodzajeodsetek
    ADD CONSTRAINT ts_rodzajeodsetek_pkey PRIMARY KEY (ros_idrodzaju);


--
--

ALTER TABLE ONLY ts_rodzajklienta
    ADD CONSTRAINT ts_rodzajklienta_pkey PRIMARY KEY (rk_idrodzajklienta);


--
--

ALTER TABLE ONLY ts_rodzajkontaktu
    ADD CONSTRAINT ts_rodzajkontaktu_pkey PRIMARY KEY (rk_idrodzajkontaktu);


--
--

ALTER TABLE ONLY ts_rozmiarykubelkow
    ADD CONSTRAINT ts_rozmiarykubelkow_pkey PRIMARY KEY (rk_idrozmiaru);


--
--

ALTER TABLE ONLY ts_rozne
    ADD CONSTRAINT ts_rozne_pkey PRIMARY KEY (rn_idrozne);


--
--

ALTER TABLE ONLY ts_schematexpplat
    ADD CONSTRAINT ts_schematexpplat_pkey PRIMARY KEY (ep_idschematu);


--
--

ALTER TABLE ONLY ts_schematy_wymiany
    ADD CONSTRAINT ts_schematy_wymiany_pkey PRIMARY KEY (sch_id);


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_pkey PRIMARY KEY (sp_idserie);


--
--

ALTER TABLE ONLY ts_slownikkolornika
    ADD CONSTRAINT ts_slownikkolornika_pkey PRIMARY KEY (skol_idslownika);


--
--

ALTER TABLE ONLY ts_slownikwykonania
    ADD CONSTRAINT ts_slownikwykonania_pkey PRIMARY KEY (tsw_idslownika);


--
--

ALTER TABLE ONLY ts_spedycje
    ADD CONSTRAINT ts_spedycje_pkey PRIMARY KEY (sp_idspedytora);


--
--

ALTER TABLE ONLY ts_sposobprzechowania
    ADD CONSTRAINT ts_sposobprzechowania_pkey PRIMARY KEY (sp_idprzechow);


--
--

ALTER TABLE ONLY ts_stanowisko
    ADD CONSTRAINT ts_stanowisko_pkey PRIMARY KEY (st_idstanowiska);


--
--

ALTER TABLE ONLY ts_statustransportu
    ADD CONSTRAINT ts_statustransportu_pkey PRIMARY KEY (sl_idstatusu);


--
--

ALTER TABLE ONLY ts_statusy
    ADD CONSTRAINT ts_statusy_pkey PRIMARY KEY (st_idstatusu);


--
--

ALTER TABLE ONLY ts_statusyzachowanie
    ADD CONSTRAINT ts_statusyzachowanie_pkey PRIMARY KEY (stz_idzachowania);


--
--

ALTER TABLE ONLY ts_statuszlecenia
    ADD CONSTRAINT ts_statuszlecenia_pkey PRIMARY KEY (szl_idstatusu);


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_pkey PRIMARY KEY (szd_idszablonu);


--
--

ALTER TABLE ONLY ts_tabelakursow
    ADD CONSTRAINT ts_tabelakursow_pkey PRIMARY KEY (tw_idtabeli);


--
--

ALTER TABLE ONLY ts_typdostawcyalt
    ADD CONSTRAINT ts_typdostawcyalt_pkey PRIMARY KEY (tda_idtypu);


--
--

ALTER TABLE ONLY ts_typpaczkispedycyjnej
    ADD CONSTRAINT ts_typpaczkispedycyjnej_pkey PRIMARY KEY (tps_idtypu);


--
--

ALTER TABLE ONLY ts_typspotkania
    ADD CONSTRAINT ts_typspotkania_pkey PRIMARY KEY (tp_idtypspotkania);


--
--

ALTER TABLE ONLY ts_typspzakup
    ADD CONSTRAINT ts_typspzakup_pkey PRIMARY KEY (szt_id);


--
--

ALTER TABLE ONLY ts_typzdarzenia
    ADD CONSTRAINT ts_typzdarzenia_pkey PRIMARY KEY (tsz_idtypu);


--
--

ALTER TABLE ONLY ts_wlascicielefirmy
    ADD CONSTRAINT ts_wlascicielefirmy_pkey PRIMARY KEY (wf_idwlasciciela);


--
--

ALTER TABLE ONLY ts_wymaganiataboru
    ADD CONSTRAINT ts_wymaganiataboru_pkey PRIMARY KEY (wt_idwymagania);


--
--

ALTER TABLE ONLY ts_zmiennedoskryptow
    ADD CONSTRAINT ts_zmiennedoskryptow_pkey PRIMARY KEY (zds_idzmiennej);


--
--

ALTER TABLE ONLY ts_znacznikprt
    ADD CONSTRAINT ts_znacznikprt_pkey PRIMARY KEY (zprt_id);


--
--

ALTER TABLE ONLY tu_impplat
    ADD CONSTRAINT tu_impplat_pkey PRIMARY KEY (ipp_id);


--
--

ALTER TABLE ONLY tu_impplatelem
    ADD CONSTRAINT tu_impplatelem_pkey PRIMARY KEY (ipe_idelem);


--
--

ALTER TABLE ONLY tu_numeryseryjne
    ADD CONSTRAINT tu_numeryseryjne_pkey PRIMARY KEY (ns_idnumeru);


--
--

ALTER TABLE ONLY tu_uprawnienia
    ADD CONSTRAINT tu_uprawnienia_pkey PRIMARY KEY (u_iduprawnienia);


--
--

ALTER TABLE ONLY tu_zalogowani
    ADD CONSTRAINT tu_zalogowani_pkey PRIMARY KEY (zs_idzalogowani);


--
--

ALTER TABLE ONLY tvs_services
    ADD CONSTRAINT tvs_services_pkey PRIMARY KEY (sv_id);
