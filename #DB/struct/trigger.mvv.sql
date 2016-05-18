CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_technologie_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('146', 'th_idtechnologii');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_klient_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('1', 'k_idklienta');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_obiekty_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('2', 'ob_idobiektu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_transakcje_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('8', 'tr_idtrans');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_magazyny_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('9', 'tmg_idmagazynu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_towary_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('10', 'ttw_idtowaru');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_pracownicy_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('11', 'p_idpracownika');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_grupytow_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('12', 'tgr_idgrupy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_podgrupytow_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('13', 'tpg_idpodgrupy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_transelem_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('17', 'tel_idelem');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON kh_platnosci_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('19', 'pl_idplatnosc');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_banki_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('21', 'bk_idbanku');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_jednostki_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('22', 'tjn_idjedn');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_zlecenia_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('32', 'zl_idzlecenia');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_ludzieklienta_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('35', 'lk_idczklienta');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('56', 'pz_idplanu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_firma_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('66', 'fm_index');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON st_srodkitrwale_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('80', 'str_id');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_spedycje_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('130', 'sp_idspedytora');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_transport_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('140', 'lt_idtransportu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_technoelem_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('147', 'the_idelem');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_rrozchodu_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('150', 'trr_idelemu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwhead_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('152', 'kwh_idheadu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_nodrec_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('157', 'knr_idelemu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_formaplat_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('161', 'pl_formaplat');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_ciagtech_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('163', 'ct_idciagu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_abonamenty_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('166', 'ab_idabonamentu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_grupycen_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('168', 'tgc_idgrupy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_grupywww_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('189', 'tgw_idgrupy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_zdarzenia_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('206', 'zd_idzdarzenia');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_swiadectwa_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('214', 'sw_idswiadectwa');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_rodzajedokumentow_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('216', 'tr_rodzaj');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_slownikwykonania_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('226', 'tsw_idslownika');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_kpohead_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('241', 'kpo_idheadu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_operacjetech_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('148', 'top_idoperacji');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnod_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('153', 'kwe_idelemu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwyk_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('155', 'knw_idelemu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_klientzlecenia_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('58', 'kz_idklienta');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_abonamelem_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('167', 'ae_idelemu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_technogrupy_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('174', 'thg_idgrupy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_partie_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('318', 'prt_idpartii');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_teex_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('320', 'tex_idelem');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_partiehelper_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('338', 'prh_idpartii');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_praceall_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('218', 'pra_idpracy');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_charklientdlatow_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('400', 'ckdt_idkartoteki');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON ts_powiaty_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('24', 'pw_idpowiatu');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tg_elslownika_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('70', 'es_idelem');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tb_kalendarzhead_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('311', 'kalh_idkalendarzahead');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_pomiary_definicje_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('432', 'pd_iddefinicji');


--
--

CREATE TRIGGER onaiudmultivalt AFTER INSERT OR DELETE OR UPDATE ON tr_pomiary_wykonanie_mv FOR EACH ROW EXECUTE PROCEDURE public.onaiudnewmultivalues('435', 'pw_idpomiarukkw');
