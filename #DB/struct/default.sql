ALTER TABLE ONLY tb_api_actiongroup ALTER COLUMN apg_id SET DEFAULT nextval('tb_api_actiongroup_apg_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_api_actiongroup_access ALTER COLUMN aga_id SET DEFAULT nextval('tb_api_actiongroup_access_aga_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_api_profile ALTER COLUMN apc_id SET DEFAULT nextval('tb_api_profile_apc_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_api_profile_access_action ALTER COLUMN apa_id SET DEFAULT nextval('tb_api_profile_access_action_apa_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_api_profile_access_actiongroup ALTER COLUMN apga_id SET DEFAULT nextval('tb_api_profile_access_actiongroup_apga_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_appcustomwindows ALTER COLUMN acw_id SET DEFAULT nextval('tb_appcustomwindows_acw_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_appwindowsstats ALTER COLUMN aws_id SET DEFAULT nextval('tb_appwindowsstats_aws_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_assemblies ALTER COLUMN asm_id SET DEFAULT nextval('tb_assemblies_asm_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_assemblies_content ALTER COLUMN asc_id SET DEFAULT nextval('tb_assemblies_content_asc_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_chat_conversation ALTER COLUMN chc_id SET DEFAULT nextval('tb_chat_conversation_chc_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_chat_history ALTER COLUMN chh_id SET DEFAULT nextval('tb_chat_history_chh_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_chat_members ALTER COLUMN chm_id SET DEFAULT nextval('tb_chat_members_chm_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_datalist_reports ALTER COLUMN dll_id SET DEFAULT nextval('tb_datalist_reports_dll_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_datalist_units ALTER COLUMN dlu_id SET DEFAULT nextval('tb_datalist_units_dlu_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_data ALTER COLUMN mail_id SET DEFAULT nextval('tb_mail_data_mail_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_data_addresses ALTER COLUMN mal_id SET DEFAULT nextval('tb_mail_data_addresses_mal_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_data_attachments ALTER COLUMN mat_id SET DEFAULT nextval('tb_mail_data_attachments_mat_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_data_attachments_data ALTER COLUMN mad_id SET DEFAULT nextval('tb_mail_data_attachments_data_mad_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_processed ALTER COLUMN mpr_id SET DEFAULT nextval('tb_mail_processed_mpr_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_mail_templates ALTER COLUMN mtpl_id SET DEFAULT nextval('tb_mail_templates_mtpl_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_maps_gpshistory ALTER COLUMN gps_id SET DEFAULT nextval('tb_maps_gpshistory_gps_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_menucustomization ALTER COLUMN mci_id SET DEFAULT nextval('tb_menucustomization_mci_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_packages_arrangement ALTER COLUMN paa_id SET DEFAULT nextval('tb_packages_arrangement_paa_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_packages_containers ALTER COLUMN pac_id SET DEFAULT nextval('tb_packages_containers_pac_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_plugins ALTER COLUMN plu_id SET DEFAULT nextval('tb_plugins_plu_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_plugins_references ALTER COLUMN pas_id SET DEFAULT nextval('tb_plugins_references_pas_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_rcp_agregacja ALTER COLUMN rcpa_idagregacji SET DEFAULT nextval('tb_rcp_agregacja_rcpa_idagregacji_seq'::regclass);


--
--

ALTER TABLE ONLY tb_rcp_wydarzenia ALTER COLUMN rcp_idwydarzenia SET DEFAULT nextval('tb_rcp_wydarzenia_rcp_idwydarzenia_seq'::regclass);


--
--

ALTER TABLE ONLY tb_scriptfiles ALTER COLUMN scf_id SET DEFAULT nextval('tb_scriptfiles_scf_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_scripts ALTER COLUMN scr_id SET DEFAULT nextval('tb_scripts_scr_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_settings ALTER COLUMN stt_id SET DEFAULT nextval('tb_settings_stt_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_settings_storages ALTER COLUMN sts_id SET DEFAULT nextval('tb_settings_storages_sts_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_telemarketing_telefony ALTER COLUMN tlpr_id SET DEFAULT nextval('tb_telemarketing_telefony_tlpr_id_seq'::regclass);


--
--

ALTER TABLE ONLY tb_vphone_history ALTER COLUMN vph_id SET DEFAULT nextval('tb_vphone_history_vph_id_seq'::regclass);


--
--

ALTER TABLE ONLY tg_towaryzlecotwartego ALTER COLUMN tzt_idtowaruzlec SET DEFAULT nextval('tg_towaryzlecotwartego_tzt_idtowaruzlec_seq'::regclass);


--
--

ALTER TABLE ONLY tr_matrycaumiejetnosci ALTER COLUMN mau_id SET DEFAULT nextval('tr_matrycaumiejetnosci_mau_id_seq'::regclass);


--
--

ALTER TABLE ONLY ts_szablonzdarzenia ALTER COLUMN szd_idszablonu SET DEFAULT nextval('ts_szablonzdarzenia_szd_idszablonu_seq'::regclass);


SET search_path = gm, pg_catalog;
