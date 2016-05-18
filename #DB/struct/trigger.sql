CREATE TRIGGER a_a_gmr_pzrozmiarowka AFTER INSERT OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE gmr.onaiudplanzleceniarozmiarowka();


--
--

CREATE TRIGGER a_a_syncrpzam AFTER INSERT OR DELETE OR UPDATE ON tg_zamilosci FOR EACH ROW EXECUTE PROCEDURE gm.onaiudzamiloscisyncrpzam();


--
--

CREATE TRIGGER a_checkinwmiejscamag AFTER UPDATE ON ts_miejscamagazynowe FOR EACH ROW WHEN ((new.mm_openinwscount > 0)) EXECUTE PROCEDURE gm.inwwm_checkinwmiejscamagazynowe();


--
--

CREATE TRIGGER a_checknadrealizacja AFTER UPDATE ON tg_transelem FOR EACH ROW WHEN ((new.tel_nadmiarzam > (0)::numeric)) EXECUTE PROCEDURE onaiutranselemnadrealizacja();


--
--

CREATE TRIGGER a_gm_a_normalizertowaru BEFORE INSERT OR UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE gm.onnormalizertowaru();


--
--

CREATE TRIGGER a_gm_towarchanged_xref BEFORE INSERT OR UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE gm.onbiupodindexes();


--
--

CREATE TRIGGER a_gm_towarchangedafter_xref AFTER INSERT OR UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE gm.onaiupodindexes();


--
--

CREATE TRIGGER a_gmr_onaiudrozmsppakelems AFTER INSERT OR DELETE OR UPDATE ON tg_rozmsppakelems FOR EACH ROW EXECUTE PROCEDURE gmr.onaiudrozmsppakelems();


--
--

CREATE TRIGGER a_onbiuddeferredkh BEFORE INSERT OR DELETE OR UPDATE ON kh_deferredkh FOR EACH ROW EXECUTE PROCEDURE onbiuddeferredkh();


--
--

CREATE TRIGGER a_onibanki BEFORE INSERT ON tg_transakcje FOR EACH ROW WHEN (((new.tr_zamknieta & 64) = 64)) EXECUTE PROCEDURE gm.onubanki();


--
--

CREATE TRIGGER a_onubanki BEFORE UPDATE ON tg_transakcje FOR EACH ROW WHEN (((new.fm_idcentrali IS DISTINCT FROM old.fm_idcentrali) OR (new.k_idklienta IS DISTINCT FROM old.k_idklienta) OR (new.tmg_idmagazynu IS DISTINCT FROM old.tmg_idmagazynu) OR (new.wl_idwaluty IS DISTINCT FROM old.wl_idwaluty) OR ((new.tr_zamknieta & 64) IS DISTINCT FROM (old.tr_zamknieta & 64)))) EXECUTE PROCEDURE gm.onubanki();


--
--

CREATE TRIGGER a_recalcnvb_a1 AFTER DELETE ON tg_transelem FOR EACH ROW WHEN ((vat.disablerecalcing(old.tr_idtrans, 0) > 0)) EXECUTE PROCEDURE vat.needrecalct();


--
--

CREATE TRIGGER a_recalcnvb_a2 AFTER INSERT OR UPDATE ON tg_transelem FOR EACH ROW WHEN ((vat.disablerecalcing(new.tr_idtrans, 0) > 0)) EXECUTE PROCEDURE vat.needrecalct();


--
--

CREATE TRIGGER a_recalcnvb_d AFTER DELETE ON tg_transelem FOR EACH ROW WHEN ((vat.disablerecalcing(old.tr_idtrans, 0) = 0)) EXECUTE PROCEDURE gm.ontevatrecalc();


--
--

CREATE TRIGGER a_recalcnvb_iu AFTER INSERT OR UPDATE ON tg_transelem FOR EACH ROW WHEN ((vat.disablerecalcing(new.tr_idtrans, 0) = 0)) EXECUTE PROCEDURE gm.ontevatrecalc();


--
--

CREATE TRIGGER aa_partie_fillrozmparent BEFORE INSERT ON tg_partie FOR EACH ROW WHEN (((new.prt_idparent_rozm IS NULL) AND (new.prt_wplyw > 0))) EXECUTE PROCEDURE gmr.ipartie_rozm();


--
--

CREATE TRIGGER aa_protectte_d AFTER DELETE ON tg_transelem FOR EACH ROW WHEN (((old.tel_new2flaga & (1 << 24)) <> 0)) EXECUTE PROCEDURE gmr.onprotectte();


--
--

CREATE TRIGGER aa_protectte_iu AFTER INSERT OR UPDATE ON tg_transelem FOR EACH ROW WHEN (((new.tel_new2flaga & (1 << 24)) <> 0)) EXECUTE PROCEDURE gmr.onprotectte();


--
--

CREATE TRIGGER aoniudplanst AFTER INSERT OR DELETE OR UPDATE ON st_planst FOR EACH ROW EXECUTE PROCEDURE aoniudplanst();


--
--

CREATE TRIGGER aoniudzdarzeniast AFTER INSERT OR DELETE OR UPDATE ON st_zdarzeniast FOR EACH ROW EXECUTE PROCEDURE aoniudzdarzeniast();


--
--

CREATE TRIGGER b_onrecalczamilosci_d AFTER DELETE ON tg_transelem FOR EACH ROW WHEN (((old.tel_newflaga & (1 << 19)) <> 0)) EXECUTE PROCEDURE gm.onrecalczamilosci();


--
--

CREATE TRIGGER b_onrecalczamilosci_i AFTER INSERT ON tg_transelem FOR EACH ROW WHEN (((new.tel_newflaga & (1 << 19)) <> 0)) EXECUTE PROCEDURE gm.onrecalczamilosci();


--
--

CREATE TRIGGER b_onrecalczamilosci_u AFTER UPDATE ON tg_transelem FOR EACH ROW WHEN ((((new.tel_newflaga & (1 << 19)) <> 0) OR ((new.tel_newflaga & (1 << 19)) <> (old.tel_newflaga & (1 << 19))))) EXECUTE PROCEDURE gm.onrecalczamilosci();


--
--

CREATE TRIGGER c_onadelemt AFTER DELETE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE gm.onadtranselem();


--
--

CREATE TRIGGER c_onaiudloselemt AFTER INSERT OR DELETE OR UPDATE ON tg_losyelem FOR EACH ROW EXECUTE PROCEDURE onaiudlosyelem();


--
--

CREATE TRIGGER c_onaiudpartietm AFTER INSERT OR DELETE OR UPDATE ON tg_partietm FOR EACH ROW EXECUTE PROCEDURE gm.onaiudpartietm();


--
--

CREATE TRIGGER c_onaiuelemt AFTER INSERT OR UPDATE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE gm.onaiutranselem();


--
--

CREATE TRIGGER c_onbiudloselemt BEFORE INSERT OR DELETE OR UPDATE ON tg_losyelem FOR EACH ROW EXECUTE PROCEDURE onbiudlosyelem();


--
--

CREATE TRIGGER c_onbiudtranselemt BEFORE INSERT OR DELETE OR UPDATE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE gm.onbiudtranselem();


--
--

CREATE TRIGGER c_onbiudwskrezt BEFORE INSERT OR DELETE OR UPDATE ON tg_wskrez FOR EACH ROW EXECUTE PROCEDURE gm.onbiudwskrez();


--
--

CREATE TRIGGER d_gmronaiudpartetm_d AFTER DELETE ON tg_partietm FOR EACH ROW WHEN ((old.ptm_idparent IS NOT NULL)) EXECUTE PROCEDURE gmr.onaiudpartetm_rozm();


--
--

CREATE TRIGGER d_gmronaiudpartetm_iu AFTER INSERT OR UPDATE ON tg_partietm FOR EACH ROW WHEN ((new.ptm_idparent IS NOT NULL)) EXECUTE PROCEDURE gmr.onaiudpartetm_rozm();


--
--

CREATE TRIGGER debugchodlowosct AFTER UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE debugchodliwosc();


--
--

CREATE TRIGGER i_mrpp_onbiud BEFORE INSERT OR DELETE OR UPDATE ON tr_mrppalety FOR EACH ROW EXECUTE PROCEDURE gm.mrpp_onbiud();


--
--

CREATE TRIGGER i_onaiudppheadelem AFTER INSERT OR DELETE OR UPDATE ON tg_ppheadelem FOR EACH ROW EXECUTE PROCEDURE gmr.onppheadelemiud();


--
--

CREATE TRIGGER i_onbiudppheadelem BEFORE INSERT OR DELETE OR UPDATE ON tg_ppheadelem FOR EACH ROW EXECUTE PROCEDURE gmr.onppheadelembiud();


--
--

CREATE TRIGGER k_onautranselemkompletyt AFTER UPDATE ON tg_transelem FOR EACH ROW WHEN (((new.tel_newflaga & 256) = 256)) EXECUTE PROCEDURE gm.onautranselemkomplety();


--
--

CREATE TRIGGER kompensatyhandt BEFORE INSERT OR DELETE OR UPDATE ON tb_kompensatyhand FOR EACH ROW EXECUTE PROCEDURE onkompensatahand();


--
--

CREATE TRIGGER n_onaiudinwdets AFTER INSERT OR DELETE OR UPDATE ON tg_inwdetails FOR EACH ROW EXECUTE PROCEDURE gm.inwwm_onaiudinwdetails();


--
--

CREATE TRIGGER n_onaiudinwdetsclick AFTER INSERT OR UPDATE ON tg_inwdetails FOR EACH ROW EXECUTE PROCEDURE gm.inwwm_onaiudinwdetailsclicks();


--
--

CREATE TRIGGER n_onaiudinwelss AFTER INSERT OR DELETE OR UPDATE ON tg_inwelems FOR EACH ROW EXECUTE PROCEDURE gm.inwwm_onaiudinwelems();


--
--

CREATE TRIGGER n_onupdatepackinginfot AFTER UPDATE ON tg_transakcje FOR EACH ROW WHEN (((old.tr_idspakowal IS NULL) AND (new.tr_idspakowal IS NOT NULL))) EXECUTE PROCEDURE gm.onupdatepackinginfo();


--
--

CREATE TRIGGER o_aiudzledlugi AFTER INSERT OR DELETE OR UPDATE ON kh_zledlugidet FOR EACH ROW EXECUTE PROCEDURE onaiudzledlugi();


--
--

CREATE TRIGGER o_onaiudppelemt AFTER INSERT OR DELETE OR UPDATE ON tg_ppelem FOR EACH ROW EXECUTE PROCEDURE gm.onaiudppelem();


--
--

CREATE TRIGGER o_onaiudteext AFTER INSERT OR DELETE OR UPDATE ON tg_teex FOR EACH ROW EXECUTE PROCEDURE gm.onaiudteex();


--
--

CREATE TRIGGER o_onaiudtowaryakcjimdet AFTER INSERT OR DELETE OR UPDATE ON tg_towaryakcjimdet FOR EACH ROW EXECUTE PROCEDURE onaiudtowaryakcjimdet();


--
--

CREATE TRIGGER o_onaiudtowmagt AFTER INSERT OR DELETE OR UPDATE ON tg_towmag FOR EACH ROW EXECUTE PROCEDURE gm.onaiudtowmag();


--
--

CREATE TRIGGER o_onaiuruchyt AFTER INSERT OR DELETE OR UPDATE ON tg_ruchy FOR EACH ROW EXECUTE PROCEDURE gm.onaiuruchy();


--
--

CREATE TRIGGER o_onbiudteext BEFORE INSERT OR DELETE OR UPDATE ON tg_teex FOR EACH ROW EXECUTE PROCEDURE gm.onbiudteex();


--
--

CREATE TRIGGER o_oniudtowmagt BEFORE INSERT OR DELETE OR UPDATE ON tg_towmag FOR EACH ROW EXECUTE PROCEDURE gm.oniudtowmag();


--
--

CREATE TRIGGER o_oniuruchyt BEFORE INSERT OR DELETE OR UPDATE ON tg_ruchy FOR EACH ROW EXECUTE PROCEDURE gm.onuruchy();


--
--

CREATE TRIGGER on_a_iud_dyspozycjamag AFTER INSERT OR DELETE OR UPDATE ON tr_dyspozycjamag FOR EACH ROW EXECUTE PROCEDURE on_a_iud_dyspozycjamag();


--
--

CREATE TRIGGER on_a_iud_dyspozycjamag_child AFTER INSERT OR DELETE OR UPDATE ON tr_dyspozycjamag FOR EACH ROW EXECUTE PROCEDURE on_a_iud_dyspozycjamag_child();


--
--

CREATE TRIGGER on_a_iud_kkwheadrozm_ilosc AFTER INSERT OR DELETE OR UPDATE ON tr_kkwheadrozm FOR EACH ROW EXECUTE PROCEDURE on_a_iud_kkwheadrozm_ilosc();


--
--

CREATE TRIGGER on_a_iud_kkwnodrec_rozmiarowka AFTER INSERT OR DELETE OR UPDATE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE on_a_iud_kkwnodrec_rozmiarowka();


--
--

CREATE TRIGGER on_a_iud_nodrecrozmiarowka AFTER INSERT OR DELETE OR UPDATE ON tr_nodrecrozmiarowka FOR EACH ROW EXECUTE PROCEDURE on_a_iud_nodrecrozmiarowka();


--
--

CREATE TRIGGER on_a_iud_nodrecrozmiarowka_bo AFTER INSERT OR DELETE OR UPDATE ON tr_nodrecrozmiarowka FOR EACH ROW EXECUTE PROCEDURE on_a_iud_nodrecrozmiarowka_bo();


--
--

CREATE TRIGGER on_a_iud_planzlecnormatywykkw AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE on_a_iud_planzlecnormatywykkw();


--
--

CREATE TRIGGER on_a_iud_powiazanieplanprzychod AFTER INSERT OR DELETE OR UPDATE ON tr_powiazanieplanprzychod FOR EACH ROW EXECUTE PROCEDURE on_a_iud_powiazanieplanprzychod();


--
--

CREATE TRIGGER on_a_u_kkwhead_dyspozycja AFTER UPDATE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE on_a_u_kkwhead_dyspozycja();


--
--

CREATE TRIGGER on_b_i_rozmrodzajeelems_lp BEFORE INSERT ON tg_rozmrodzajeelems FOR EACH ROW EXECUTE PROCEDURE on_b_i_rozmrodzajeelems_lp();


--
--

CREATE TRIGGER on_b_i_trruchy BEFORE INSERT ON tr_ruchy FOR EACH ROW EXECUTE PROCEDURE on_b_i_trruchy();


--
--

CREATE TRIGGER on_b_iu_kkwhead_rozmiarowka BEFORE INSERT OR UPDATE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE on_b_iu_kkwhead_rozmiarowka();


--
--

CREATE TRIGGER on_b_iu_nodrecrozmiarowka BEFORE INSERT OR UPDATE ON tr_nodrecrozmiarowka FOR EACH ROW EXECUTE PROCEDURE on_b_iu_nodrecrozmiarowka();


--
--

CREATE TRIGGER on_b_iud_kkwheadrozm BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwheadrozm FOR EACH ROW EXECUTE PROCEDURE on_b_iud_kkwheadrozm();


--
--

CREATE TRIGGER on_b_iud_kkwnodrec_magazynowka BEFORE INSERT OR DELETE OR UPDATE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE on_b_iud_kkwnodrec_magazynowka();


--
--

CREATE TRIGGER on_b_iud_pomiary_wykonanie BEFORE INSERT OR DELETE OR UPDATE ON tr_pomiary_wykonanie FOR EACH ROW EXECUTE PROCEDURE on_b_iud_pomiary_wykonanie();


--
--

CREATE TRIGGER onadkartotekadelegacji AFTER DELETE ON ts_kartotekadelegacji FOR EACH ROW EXECUTE PROCEDURE onadkartotekadelegacji();


--
--

CREATE TRIGGER onadkkwnod_lp AFTER DELETE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE onadkkwnod_lp();


--
--

CREATE TRIGGER onadstrukturakonstrukcyjnarel_lpt AFTER DELETE ON tr_strukturakonstrukcyjnarel FOR EACH ROW EXECUTE PROCEDURE onadstrukturakonstrukcyjnarel_lp();


--
--

CREATE TRIGGER onadtechnorrozchodu_lp AFTER DELETE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE onadtechnorrozchodu_lp();


--
--

CREATE TRIGGER onai_tb_chat_history AFTER INSERT ON tb_chat_history FOR EACH ROW EXECUTE PROCEDURE onai_tb_chat_history();


--
--

CREATE TRIGGER onai_tb_chat_members AFTER INSERT OR UPDATE ON tb_chat_members FOR EACH ROW EXECUTE PROCEDURE onai_tb_chat_members();


--
--

CREATE TRIGGER onaidutechnorrozchodu_zammtech AFTER INSERT OR DELETE OR UPDATE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE onaiudtechnorrozchodu_zammtech();


--
--

CREATE TRIGGER onaielementobiektu AFTER INSERT ON tg_elementobiektu FOR EACH ROW EXECUTE PROCEDURE onai_elementobiektu();


--
--

CREATE TRIGGER onaitbrcpwydarzeniat AFTER INSERT ON tb_rcp_wydarzenia FOR EACH ROW EXECUTE PROCEDURE onaitbrcpwydarzenia();


--
--

CREATE TRIGGER onaitechnoelemstkl AFTER INSERT ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE onaitechnoelemstkl();


--
--

CREATE TRIGGER onaiud_kartapremiowat AFTER INSERT OR DELETE OR UPDATE ON tg_kartypremiowe FOR EACH ROW EXECUTE PROCEDURE onaiud_kartapremiowa();


--
--

CREATE TRIGGER onaiudbanki AFTER INSERT OR DELETE OR UPDATE ON ts_banki FOR EACH ROW EXECUTE PROCEDURE onaiudbanki();


--
--

CREATE TRIGGER onaiudgrupatowarowt AFTER INSERT OR DELETE OR UPDATE ON tg_grupytow FOR EACH ROW EXECUTE PROCEDURE onaiudgrupatowarow();


--
--

CREATE TRIGGER onaiudgrupawwwtowarowt AFTER INSERT OR DELETE OR UPDATE ON tg_grupywww FOR EACH ROW EXECUTE PROCEDURE onaiudgrupawwwtowarow();


--
--

CREATE TRIGGER onaiudkhwymiarysumvaluest AFTER INSERT OR DELETE OR UPDATE ON kh_wymiarysumvalues FOR EACH ROW EXECUTE PROCEDURE onaiudkhwymiarysumvalues();


--
--

CREATE TRIGGER onaiudkhwymiaryvaluest AFTER INSERT OR DELETE OR UPDATE ON kh_wymiaryvalues FOR EACH ROW EXECUTE PROCEDURE onaiudkhwymiaryvalues();


--
--

CREATE TRIGGER onaiudkkwnod_wymiary BEFORE INSERT OR UPDATE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnod_wymiary();


--
--

CREATE TRIGGER onaiudkkwnod_zammtech AFTER INSERT OR DELETE OR UPDATE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnod_zammtech();


--
--

CREATE TRIGGER onaiudkkwnodplant AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodplan FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnodplan();


--
--

CREATE TRIGGER onaiudkkwnodprevnext AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodprevnext FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnodprevnext();


--
--

CREATE TRIGGER onaiudkkwnodt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnod();


--
--

CREATE TRIGGER onaiudkkwnodwykdetkooperacja AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwykdetkooperacja FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnodwykdetkooperacja();


--
--

CREATE TRIGGER onaiudkkwnodwykdett AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwykdet FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnodwykdet();


--
--

CREATE TRIGGER onaiudkkwnodwykt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwyk FOR EACH ROW EXECUTE PROCEDURE onaiudkkwnodwyk();


--
--

CREATE TRIGGER onaiudkrrozliczeniat AFTER INSERT OR DELETE OR UPDATE ON kr_rozliczenia FOR EACH ROW EXECUTE PROCEDURE onaiudkrrozliczenia();


--
--

CREATE TRIGGER onaiudkrrozrachunkit AFTER INSERT OR DELETE OR UPDATE ON kr_rozrachunki FOR EACH ROW EXECUTE PROCEDURE onaiudkrrozrachunki();


--
--

CREATE TRIGGER onaiudkursywalutt AFTER INSERT OR DELETE OR UPDATE ON tg_kursywalut FOR EACH ROW EXECUTE PROCEDURE onaiudkursywalut();


--
--

CREATE TRIGGER onaiudmiejscamagazynowet AFTER INSERT OR DELETE OR UPDATE ON ts_miejscamagazynowe FOR EACH ROW EXECUTE PROCEDURE onaiudmiejscamagazynowe();


--
--

CREATE TRIGGER onaiudosrodekpkt AFTER INSERT OR DELETE OR UPDATE ON ts_osrodkipk FOR EACH ROW EXECUTE PROCEDURE onaiudosrodekpk();


--
--

CREATE TRIGGER onaiudpaczkiprzewozowe AFTER INSERT OR DELETE OR UPDATE ON tg_paczkiprzewozowe FOR EACH ROW EXECUTE PROCEDURE oniudpaczkiprzewozowe();


--
--

CREATE TRIGGER onaiudplanzleceniat AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE onaiudplanzlecenia();


--
--

CREATE TRIGGER onaiudplanzleceniat_backordery AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE oniudplanzlecenia_backordery();


--
--

CREATE TRIGGER onaiudplatnosct AFTER INSERT OR DELETE OR UPDATE ON kh_platnosci FOR EACH ROW EXECUTE PROCEDURE onaiudplatnosc();


--
--

CREATE TRIGGER onaiudpodgrupatowarowt AFTER INSERT OR DELETE OR UPDATE ON tg_podgrupytow FOR EACH ROW EXECUTE PROCEDURE onaiudpodgrupatowarow();


--
--

CREATE TRIGGER onaiudpowiazanieklcz AFTER INSERT OR DELETE OR UPDATE ON tb_powiazanieklcz FOR EACH ROW EXECUTE PROCEDURE onaiudpowiazanieklcz();


--
--

CREATE TRIGGER onaiudpracownicyzleceniat AFTER DELETE OR UPDATE ON tb_pracownicyzlecenia FOR EACH ROW EXECUTE PROCEDURE onudpracownicyzlecenia();


--
--

CREATE TRIGGER onaiudraporttc AFTER INSERT OR DELETE OR UPDATE ON kh_raportelem FOR EACH ROW EXECUTE PROCEDURE onaiudraportc();


--
--

CREATE TRIGGER onaiudrealizacjapzamt AFTER INSERT OR DELETE OR UPDATE ON tg_realizacjapzam FOR EACH ROW EXECUTE PROCEDURE onaiudrealizacjapzam();


--
--

CREATE TRIGGER onaiudrodzajklientat AFTER INSERT OR DELETE OR UPDATE ON ts_rodzajklienta FOR EACH ROW EXECUTE PROCEDURE onaiudrodzajklienta();


--
--

CREATE TRIGGER onaiudrozliczdelegacja AFTER INSERT OR DELETE OR UPDATE ON tg_rozliczdelegacja FOR EACH ROW EXECUTE PROCEDURE onaiudrozliczdelegacja();


--
--

CREATE TRIGGER onaiudskladnikizestawut AFTER INSERT OR DELETE OR UPDATE ON tg_skladnikizestawu FOR EACH ROW EXECUTE PROCEDURE onaiudskladnikizestawu();


--
--

CREATE TRIGGER onaiudtechnostpracyt AFTER INSERT OR DELETE OR UPDATE ON tr_technostpracy FOR EACH ROW EXECUTE PROCEDURE onaiudtechnostpracy();


--
--

CREATE TRIGGER onaiudtelefonyt AFTER INSERT OR DELETE OR UPDATE ON tb_telefony FOR EACH ROW EXECUTE PROCEDURE onaiudtelefony();


--
--

CREATE TRIGGER onaiudtkt AFTER INSERT OR DELETE OR UPDATE ON tg_tkelem FOR EACH ROW EXECUTE PROCEDURE onaiudtk();


--
--

CREATE TRIGGER onaiudtpkkwplant AFTER INSERT OR DELETE OR UPDATE ON tp_kkwplan FOR EACH ROW EXECUTE PROCEDURE onaiudtpkkwplan();


--
--

CREATE TRIGGER onaiudtpruchyt AFTER INSERT OR DELETE OR UPDATE ON tp_ruchy FOR EACH ROW EXECUTE PROCEDURE onaiudtpruchy();


--
--

CREATE TRIGGER onaiudtranselemkorwithruch AFTER INSERT OR DELETE OR UPDATE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE onaiudtranselemkorwithruch();


--
--

CREATE TRIGGER onaiudtranselemwithakcjat AFTER INSERT OR DELETE OR UPDATE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE onaiudtranselemwithakcja();


--
--

CREATE TRIGGER onaiudtranselemwithplanzlecsrc AFTER INSERT OR DELETE OR UPDATE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE onaiudtranselemplanzlecsrc();


--
--

CREATE TRIGGER onaiudtrkkwheadt AFTER INSERT OR DELETE OR UPDATE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE onaiudtrkkwhead();


--
--

CREATE TRIGGER onaiudtrruchyt AFTER INSERT OR DELETE OR UPDATE ON tr_ruchy FOR EACH ROW EXECUTE PROCEDURE onaiudtrruchy();


--
--

CREATE TRIGGER onaiudvatykrajet AFTER INSERT OR DELETE OR UPDATE ON tg_vatykraje FOR EACH ROW EXECUTE PROCEDURE onaiudvatykraje();


--
--

CREATE TRIGGER onaiudvatytowarowt AFTER INSERT OR DELETE OR UPDATE ON tg_vatytowarow FOR EACH ROW EXECUTE PROCEDURE onaiudvatytowarow();


--
--

CREATE TRIGGER onaiudvatzalt AFTER INSERT OR DELETE OR UPDATE ON tb_vatzal FOR EACH ROW EXECUTE PROCEDURE onaiudvatzal();


--
--

CREATE TRIGGER onaiudwariantheadt AFTER INSERT OR DELETE OR UPDATE ON tr_warianthead FOR EACH ROW EXECUTE PROCEDURE onaiudwarianthead();


--
--

CREATE TRIGGER onaiudwypalt AFTER INSERT OR DELETE OR UPDATE ON tp_wypal FOR EACH ROW EXECUTE PROCEDURE onaiudwypal();


--
--

CREATE TRIGGER onaiudzamiennikit AFTER INSERT OR DELETE OR UPDATE ON tg_zamiennikitow FOR EACH ROW EXECUTE PROCEDURE onaiudzamienniki();


--
--

CREATE TRIGGER onaiudzapisyelem AFTER INSERT OR DELETE OR UPDATE ON kh_zapisyelem FOR EACH ROW EXECUTE PROCEDURE onauelzapisu();


--
--

CREATE TRIGGER onaiudzdarzenialpt AFTER INSERT OR DELETE OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE onaiudzdarzenialp();


--
--

CREATE TRIGGER onaiudzdpowiazaniat AFTER INSERT OR DELETE OR UPDATE ON tb_zdpowiazania FOR EACH ROW EXECUTE PROCEDURE onaiudzdpowiazania();


--
--

CREATE TRIGGER onaiudzleceniat AFTER INSERT OR DELETE OR UPDATE ON tg_zlecenia FOR EACH ROW EXECUTE PROCEDURE onaiudzlecenie();


--
--

CREATE TRIGGER onaiudzleceniat_podzlecenia AFTER INSERT OR DELETE OR UPDATE ON tg_zlecenia FOR EACH ROW EXECUTE PROCEDURE oniudzlecenie_podzlecenia();


--
--

CREATE TRIGGER onaiutechnorrozchodu_wymiary BEFORE INSERT OR UPDATE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE onaiutechnorrozchodu_wymiary();


--
--

CREATE TRIGGER onakonta AFTER UPDATE ON kh_konta FOR EACH ROW EXECUTE PROCEDURE onakonta();


--
--

CREATE TRIGGER onaudharmonogramsplatt AFTER INSERT OR DELETE OR UPDATE ON tb_hmsplat FOR EACH ROW EXECUTE PROCEDURE onaiudharmonogramsplat();


--
--

CREATE TRIGGER onauludzieklienta AFTER UPDATE ON tb_ludzieklienta FOR EACH ROW EXECUTE PROCEDURE onauludzieklienta();


--
--

CREATE TRIGGER onaupdatetowvatt AFTER INSERT OR DELETE OR UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE onaiudtowaryvat();


--
--

CREATE TRIGGER onauskojarzenia AFTER UPDATE ON kh_zapisskoj FOR EACH ROW EXECUTE PROCEDURE onauzapisskoj();


--
--

CREATE TRIGGER onauspinaczoperacji BEFORE UPDATE ON tr_spinaczoperacji FOR EACH ROW EXECUTE PROCEDURE onauspinaczoperacji();


--
--

CREATE TRIGGER onaustrukturakonstrukcyjnarel_lpt AFTER UPDATE ON tr_strukturakonstrukcyjnarel FOR EACH ROW EXECUTE PROCEDURE onaustrukturakonstrukcyjnarel_lp();


--
--

CREATE TRIGGER onauszablonzdarzenia AFTER UPDATE ON ts_szablonzdarzenia FOR EACH ROW EXECUTE PROCEDURE onauszablonzdarzenia();


--
--

CREATE TRIGGER onautbrcpwydarzeniat AFTER UPDATE ON tb_rcp_wydarzenia FOR EACH ROW EXECUTE PROCEDURE onautbrcpwydarzenia();


--
--

CREATE TRIGGER onautowarymmt AFTER UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE onautowarymm();


--
--

CREATE TRIGGER onautransakcje AFTER DELETE OR UPDATE ON tg_transakcje FOR EACH ROW EXECUTE PROCEDURE onautrans();


--
--

CREATE TRIGGER onazapisy AFTER INSERT OR DELETE OR UPDATE ON kh_zapisyhead FOR EACH ROW EXECUTE PROCEDURE onazapisy();


--
--

CREATE TRIGGER onbdszablonzdarzenia BEFORE DELETE ON ts_szablonzdarzenia FOR EACH ROW EXECUTE PROCEDURE onbdszablonzdarzenia();


--
--

CREATE TRIGGER onbdzdarzenia_gsr BEFORE DELETE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE onbdzdarzenia_gsr();


--
--

CREATE TRIGGER onbeforeiuzdarzenia BEFORE INSERT OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE onbeforeiuzdarzenia();


--
--

CREATE TRIGGER onbidelementobiektu BEFORE INSERT OR DELETE ON tg_elementobiektu FOR EACH ROW EXECUTE PROCEDURE onbid_elementobiektu();


--
--

CREATE TRIGGER onbikkwnod_lp BEFORE INSERT ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE onbikkwnod_lp();


--
--

CREATE TRIGGER onbipracownicyzdarzenia BEFORE INSERT ON tb_pracownicyzdarzenia FOR EACH ROW EXECUTE PROCEDURE onbipracownicyzdarzenia();


--
--

CREATE TRIGGER onbitechnorrozchodu_lp BEFORE INSERT ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE onbitechnorrozchodu_lp();


--
--

CREATE TRIGGER onbitranselem_lpt BEFORE INSERT ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE onbitranselem_lp();


--
--

CREATE TRIGGER onbiud_kartapremiowat BEFORE INSERT OR DELETE OR UPDATE ON tg_kartypremiowe FOR EACH ROW EXECUTE PROCEDURE oniud_kartapremiowa();


--
--

CREATE TRIGGER onbiudfirmat BEFORE INSERT OR DELETE OR UPDATE ON tb_firma FOR EACH ROW EXECUTE PROCEDURE onbiudfirma();


--
--

CREATE TRIGGER onbiudgrupatowarowt BEFORE INSERT OR DELETE OR UPDATE ON tg_grupytow FOR EACH ROW EXECUTE PROCEDURE onbiudgrupatowarow();


--
--

CREATE TRIGGER onbiudgrupawwwtowarowt BEFORE INSERT OR DELETE OR UPDATE ON tg_grupywww FOR EACH ROW EXECUTE PROCEDURE onbiudgrupawwwtowarow();


--
--

CREATE TRIGGER onbiudkrrozliczeniat BEFORE INSERT OR DELETE OR UPDATE ON kr_rozliczenia FOR EACH ROW EXECUTE PROCEDURE onbiudkrrozliczenia();


--
--

CREATE TRIGGER onbiudkrrozrachunkit BEFORE INSERT OR DELETE OR UPDATE ON kr_rozrachunki FOR EACH ROW EXECUTE PROCEDURE onbiudkrrozrachunki();


--
--

CREATE TRIGGER onbiudkrsaldat BEFORE INSERT OR DELETE OR UPDATE ON kr_salda FOR EACH ROW EXECUTE PROCEDURE onbiudkrsalda();


--
--

CREATE TRIGGER onbiudmiejscamagazynowet BEFORE INSERT OR DELETE OR UPDATE ON ts_miejscamagazynowe FOR EACH ROW EXECUTE PROCEDURE onbiudmiejscamagazynowe();


--
--

CREATE TRIGGER onbiudosrodekpkt BEFORE INSERT OR DELETE OR UPDATE ON ts_osrodkipk FOR EACH ROW EXECUTE PROCEDURE onbiudosrodekpk();


--
--

CREATE TRIGGER onbiudplatfifot BEFORE INSERT OR DELETE OR UPDATE ON kh_platfifo FOR EACH ROW EXECUTE PROCEDURE onbiudplatfifo();


--
--

CREATE TRIGGER onbiudpodgrupatowarowt BEFORE INSERT OR DELETE OR UPDATE ON tg_podgrupytow FOR EACH ROW EXECUTE PROCEDURE onbiudpodgrupatowarow();


--
--

CREATE TRIGGER onbiudpowiazanieplanprzychodt BEFORE INSERT OR DELETE OR UPDATE ON tr_powiazanieplanprzychod FOR EACH ROW EXECUTE PROCEDURE onbiudpowiazanieplanprzychod();


--
--

CREATE TRIGGER onbiudpraceallt AFTER INSERT OR DELETE OR UPDATE ON tg_praceall FOR EACH ROW EXECUTE PROCEDURE onbiudpraceall();


--
--

CREATE TRIGGER onbiudprodukcjat BEFORE INSERT OR DELETE OR UPDATE ON tg_produkcja FOR EACH ROW EXECUTE PROCEDURE onbiudprodukcja();


--
--

CREATE TRIGGER onbiudrodzajklientat BEFORE INSERT OR DELETE OR UPDATE ON ts_rodzajklienta FOR EACH ROW EXECUTE PROCEDURE onbiudrodzajklienta();


--
--

CREATE TRIGGER onbiudrozliczdelegacja BEFORE INSERT OR DELETE OR UPDATE ON tg_rozliczdelegacja FOR EACH ROW EXECUTE PROCEDURE onbiudrozliczdelegacja();


--
--

CREATE TRIGGER onbiudskladnikizestawut BEFORE INSERT OR DELETE OR UPDATE ON tg_skladnikizestawu FOR EACH ROW EXECUTE PROCEDURE onbiudskladnikizestawu();


--
--

CREATE TRIGGER onbiudstrukturakonstrukcyjnat BEFORE INSERT OR DELETE OR UPDATE ON tr_strukturakonstrukcyjna FOR EACH ROW EXECUTE PROCEDURE onbiudstrukturakonstrukcyjna();


--
--

CREATE TRIGGER onbiudtpetapproduktu BEFORE INSERT OR DELETE OR UPDATE ON tp_etappolproduktu FOR EACH ROW EXECUTE PROCEDURE onbiudtpetappolproduktu();


--
--

CREATE TRIGGER onbiudtpkkwelemt BEFORE INSERT OR DELETE OR UPDATE ON tp_kkwelem FOR EACH ROW EXECUTE PROCEDURE onbiudtpkkwelem();


--
--

CREATE TRIGGER onbiudtpkkwheadt BEFORE INSERT OR DELETE OR UPDATE ON tp_kkwhead FOR EACH ROW EXECUTE PROCEDURE onbiudtpkkwhead();


--
--

CREATE TRIGGER onbiudtpkkwplant BEFORE INSERT OR DELETE OR UPDATE ON tp_kkwplan FOR EACH ROW EXECUTE PROCEDURE onbiudtpkkwplan();


--
--

CREATE TRIGGER onbiudtpruchyt BEFORE INSERT OR DELETE OR UPDATE ON tp_ruchy FOR EACH ROW EXECUTE PROCEDURE onbiudtpruchy();


--
--

CREATE TRIGGER onbiudtrkkwheadt BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE onbiudtrkkwhead();


--
--

CREATE TRIGGER onbiudtrruchyt BEFORE INSERT OR DELETE OR UPDATE ON tr_ruchy FOR EACH ROW EXECUTE PROCEDURE onbiudtrruchy();


--
--

CREATE TRIGGER onbiudwariantheadt BEFORE INSERT OR DELETE OR UPDATE ON tr_warianthead FOR EACH ROW EXECUTE PROCEDURE oniudwarianthead();


--
--

CREATE TRIGGER onbiudwmsmmrucht BEFORE INSERT OR DELETE OR UPDATE ON tg_wmsmmruch FOR EACH ROW EXECUTE PROCEDURE onbiudwmsmmruch();


--
--

CREATE TRIGGER onbiudwmsmmt BEFORE INSERT OR DELETE OR UPDATE ON tg_wmsmm FOR EACH ROW EXECUTE PROCEDURE onbiudwmsmm();


--
--

CREATE TRIGGER onbiudzdarzenialpt BEFORE INSERT OR DELETE OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE onbiudzdarzenialp();


--
--

CREATE TRIGGER onbiudzdpowiazaniat BEFORE INSERT OR DELETE OR UPDATE ON tb_zdpowiazania FOR EACH ROW EXECUTE PROCEDURE onbiudzdpowiazania();


--
--

CREATE TRIGGER onbiutplprojektu BEFORE INSERT OR UPDATE ON tb_tplprojektu FOR EACH ROW EXECUTE PROCEDURE onbiutplprojektu();


--
--

CREATE TRIGGER onbudtechnoelemstkl BEFORE DELETE OR UPDATE ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE onbudtechnoelemstkl();


--
--

CREATE TRIGGER onbumediainfot BEFORE UPDATE ON tm_mediainfo FOR EACH ROW EXECUTE PROCEDURE onbumediainfo();


--
--

CREATE TRIGGER onbutmhaslat BEFORE UPDATE ON tm_hasla FOR EACH ROW EXECUTE PROCEDURE onbutmhasla();


--
--

CREATE TRIGGER onbutowaryakcjimt BEFORE INSERT OR UPDATE ON tg_towaryakcjim FOR EACH ROW EXECUTE PROCEDURE onbitowaryakcjim();


--
--

CREATE TRIGGER onchange_towmag_id AFTER UPDATE ON tg_towmag FOR EACH ROW EXECUTE PROCEDURE onchangeatowmagupdate();


--
--

CREATE TRIGGER onchangeajednostkaaltinsertdeletet AFTER INSERT OR DELETE OR UPDATE ON tg_jednostkialt FOR EACH ROW EXECUTE PROCEDURE onchangeajednostkaaltinsertdelete();


--
--

CREATE TRIGGER onchangeatelefoninsertdeletet AFTER INSERT OR DELETE OR UPDATE ON tb_telefony FOR EACH ROW EXECUTE PROCEDURE onchangeatelefoninsertdelete();


--
--

CREATE TRIGGER oncheckvatt AFTER INSERT ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE oncheckvat();


--
--

CREATE TRIGGER onidkalkulacjet AFTER INSERT OR DELETE ON tg_kalkulacje FOR EACH ROW EXECUTE PROCEDURE onidkalkulacje();


--
--

CREATE TRIGGER onidkalkulacjevalt AFTER INSERT OR DELETE ON tg_kalkulacjeval FOR EACH ROW EXECUTE PROCEDURE onidkalkulacjeval();


--
--

CREATE TRIGGER onidmultivaluest AFTER INSERT OR DELETE OR UPDATE ON tb_multival FOR EACH ROW EXECUTE PROCEDURE onidmultivalues();


--
--

CREATE TRIGGER onietapyzlecent AFTER INSERT ON tg_etapyzlecen FOR EACH ROW EXECUTE PROCEDURE onietapyzlecen();


--
--

CREATE TRIGGER onieuronip AFTER INSERT ON tb_euronipy FOR EACH ROW EXECUTE PROCEDURE onieuronip();


--
--

CREATE TRIGGER onikontaktyt BEFORE INSERT ON tb_kontakt FOR EACH ROW EXECUTE PROCEDURE onikontakty();


--
--

CREATE TRIGGER oninklient BEFORE INSERT ON tb_klient FOR EACH ROW EXECUTE PROCEDURE oninklient();


--
--

CREATE TRIGGER oninsertkonw BEFORE INSERT OR DELETE OR UPDATE ON tg_konwersje FOR EACH ROW EXECUTE PROCEDURE on_ikonwersje();


--
--

CREATE TRIGGER onistrukturakonstrukcyjnarel_lpt BEFORE INSERT ON tr_strukturakonstrukcyjnarel FOR EACH ROW EXECUTE PROCEDURE onistrukturakonstrukcyjnarel_lp();


--
--

CREATE TRIGGER oniu_tb_zdarzenia_for_mail_t BEFORE INSERT OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE oniu_tb_zdarzenia_for_mail();


--
--

CREATE TRIGGER oniud_tb_mail_data_addresses AFTER INSERT OR DELETE OR UPDATE ON tb_mail_data_addresses FOR EACH ROW EXECUTE PROCEDURE tb_mail_data_addresses_updateaddresses();


--
--

CREATE TRIGGER oniud_tb_mail_data_attachments AFTER INSERT OR DELETE OR UPDATE ON tb_mail_data_attachments FOR EACH ROW EXECUTE PROCEDURE tb_mail_data_attachments_refresh();


--
--

CREATE TRIGGER oniudamortyzacja BEFORE INSERT OR DELETE OR UPDATE ON st_amortyzacja FOR EACH ROW EXECUTE PROCEDURE oniudamortyzacja();


--
--

CREATE TRIGGER oniudarchiwum BEFORE INSERT OR DELETE OR UPDATE ON tg_archiwum FOR EACH ROW EXECUTE PROCEDURE oniudarchiwum();


--
--

CREATE TRIGGER oniudbackordert BEFORE INSERT OR DELETE OR UPDATE ON tg_backorder FOR EACH ROW EXECUTE PROCEDURE oniudbackorder();


--
--

CREATE TRIGGER oniudbankit BEFORE INSERT OR DELETE OR UPDATE ON ts_banki FOR EACH ROW EXECUTE PROCEDURE oniudbanki();


--
--

CREATE TRIGGER oniudbiletyt BEFORE INSERT OR DELETE OR UPDATE ON tg_bilety FOR EACH ROW EXECUTE PROCEDURE oniudbilety();


--
--

CREATE TRIGGER oniudcenyt BEFORE INSERT OR DELETE OR UPDATE ON tg_ceny FOR EACH ROW EXECUTE PROCEDURE oniudceny();


--
--

CREATE TRIGGER oniuddostawarozdzialt BEFORE INSERT OR DELETE OR UPDATE ON tg_dostawarozdzial FOR EACH ROW EXECUTE PROCEDURE oniuddostawarozdzial();


--
--

CREATE TRIGGER oniudharmonogramsplatt BEFORE INSERT OR DELETE OR UPDATE ON tb_hmsplat FOR EACH ROW EXECUTE PROCEDURE onbiudharmonogramsplat();


--
--

CREATE TRIGGER oniudharmonogramt AFTER INSERT OR DELETE OR UPDATE ON tr_harmonogram FOR EACH ROW EXECUTE PROCEDURE oniudharmonogram();


--
--

CREATE TRIGGER oniudhoteleelemt BEFORE INSERT OR DELETE OR UPDATE ON tg_hoteleelem FOR EACH ROW EXECUTE PROCEDURE oniudhotelelem();


--
--

CREATE TRIGGER oniudkhwymiarysumvaluest BEFORE INSERT OR DELETE OR UPDATE ON kh_wymiarysumvalues FOR EACH ROW EXECUTE PROCEDURE oniudkhwymiarysumvalues();


--
--

CREATE TRIGGER oniudkhwymiaryvaluest BEFORE INSERT OR DELETE OR UPDATE ON kh_wymiaryvalues FOR EACH ROW EXECUTE PROCEDURE oniudkhwymiaryvalues();


--
--

CREATE TRIGGER oniudkkwnodplant BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwnodplan FOR EACH ROW EXECUTE PROCEDURE oniudkkwnodplan();


--
--

CREATE TRIGGER oniudkkwnodprevnextt BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwnodprevnext FOR EACH ROW EXECUTE PROCEDURE oniudkkwnodprevnext();


--
--

CREATE TRIGGER oniudkkwnodrect BEFORE INSERT OR DELETE OR UPDATE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE oniudkkwnodrec();


--
--

CREATE TRIGGER oniudkkwnodt BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE oniudkkwnod();


--
--

CREATE TRIGGER oniudkkwnodwykdett BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwnodwykdet FOR EACH ROW EXECUTE PROCEDURE oniudkkwnodwykdet();


--
--

CREATE TRIGGER oniudkkwnodwykt BEFORE INSERT OR DELETE OR UPDATE ON tr_kkwnodwyk FOR EACH ROW EXECUTE PROCEDURE oniudkkwnodwyk();


--
--

CREATE TRIGGER oniudkliencilogistykit BEFORE INSERT OR DELETE OR UPDATE ON tg_kliencilogistyki FOR EACH ROW EXECUTE PROCEDURE oniudkliencilogistyki();


--
--

CREATE TRIGGER oniudkliencizdarzenia AFTER INSERT OR DELETE OR UPDATE ON tb_kliencizdarzenia FOR EACH ROW EXECUTE PROCEDURE oniudkliencizdarzenia();


--
--

CREATE TRIGGER oniudklientzlecenia BEFORE INSERT OR DELETE OR UPDATE ON tg_klientzlecenia FOR EACH ROW EXECUTE PROCEDURE oniudklientzlecenia();


--
--

CREATE TRIGGER oniudklocekparamt BEFORE INSERT OR DELETE OR UPDATE ON tf_klocekparams FOR EACH ROW EXECUTE PROCEDURE oniudklocekparam();


--
--

CREATE TRIGGER oniudkonta BEFORE INSERT OR DELETE OR UPDATE ON kh_konta FOR EACH ROW EXECUTE PROCEDURE onukonta();


--
--

CREATE TRIGGER oniudkonwersjakpir BEFORE INSERT OR DELETE OR UPDATE ON kh_konwersjakpir FOR EACH ROW EXECUTE PROCEDURE oniudkonwersjakpir();


--
--

CREATE TRIGGER oniudkpoelemt BEFORE INSERT OR DELETE OR UPDATE ON tg_kpoelem FOR EACH ROW EXECUTE PROCEDURE oniudkpoelem();


--
--

CREATE TRIGGER oniudkursdokt AFTER INSERT OR DELETE OR UPDATE ON tg_kursdok FOR EACH ROW EXECUTE PROCEDURE oniudkursdok();


--
--

CREATE TRIGGER oniudlisct BEFORE INSERT OR DELETE OR UPDATE ON kh_raportlisc FOR EACH ROW EXECUTE PROCEDURE oniudlisc();


--
--

CREATE TRIGGER oniudlistprzewozowyt BEFORE INSERT OR DELETE OR UPDATE ON tg_listprzewozowy FOR EACH ROW EXECUTE PROCEDURE oniudlistprzewozowy();


--
--

CREATE TRIGGER oniudmagazynyt BEFORE INSERT OR DELETE OR UPDATE ON tg_magazyny FOR EACH ROW EXECUTE PROCEDURE oniudmagazyny();


--
--

CREATE TRIGGER oniudmrpkalkulacja BEFORE INSERT OR DELETE OR UPDATE ON tr_mrpkalkulacje FOR EACH ROW EXECUTE PROCEDURE oniudmrpkalkulacja();


--
--

CREATE TRIGGER oniudmrpkubelkit BEFORE INSERT OR DELETE OR UPDATE ON tr_kubelki FOR EACH ROW EXECUTE PROCEDURE oniudmrpkubelki();


--
--

CREATE TRIGGER oniudmrpzmianyt BEFORE INSERT OR DELETE OR UPDATE ON tr_zmiany FOR EACH ROW EXECUTE PROCEDURE oniudmrpzmiany();


--
--

CREATE TRIGGER oniudmultivalt BEFORE INSERT OR DELETE OR UPDATE ON tb_multival FOR EACH ROW EXECUTE PROCEDURE oniudmultival();


--
--

CREATE TRIGGER oniudobiektyt BEFORE INSERT OR DELETE OR UPDATE ON tg_obiekty FOR EACH ROW EXECUTE PROCEDURE oniudobiekty();


--
--

CREATE TRIGGER oniudobrotyt BEFORE INSERT OR DELETE OR UPDATE ON kh_obroty FOR EACH ROW EXECUTE PROCEDURE oniudobroty();


--
--

CREATE TRIGGER oniudodsetki BEFORE INSERT OR DELETE OR UPDATE ON tg_odsetki FOR EACH ROW EXECUTE PROCEDURE oniudodsetki();


--
--

CREATE TRIGGER oniudpackelemt BEFORE INSERT OR DELETE OR UPDATE ON tg_packelem FOR EACH ROW EXECUTE PROCEDURE oniudpackelem();


--
--

CREATE TRIGGER oniudpackheadt BEFORE INSERT OR DELETE OR UPDATE ON tg_packhead FOR EACH ROW EXECUTE PROCEDURE oniudpackhead();


--
--

CREATE TRIGGER oniudpaczkaspedycyjna BEFORE INSERT OR DELETE OR UPDATE ON tg_paczkaspedycyjna FOR EACH ROW EXECUTE PROCEDURE oniudpaczkaspedycyjna();


--
--

CREATE TRIGGER oniudplanonkkwt BEFORE INSERT OR DELETE OR UPDATE ON tp_planonkkw FOR EACH ROW EXECUTE PROCEDURE oniudplanonkkw();


--
--

CREATE TRIGGER oniudplanzlecenia BEFORE INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE oniudplanzlecenia();


--
--

CREATE TRIGGER oniudpowiazaniepaczekt BEFORE INSERT OR DELETE OR UPDATE ON tg_powiazaniepaczek FOR EACH ROW EXECUTE PROCEDURE oniudpowiazaniepaczek();


--
--

CREATE TRIGGER oniudpowiazanieplanut BEFORE INSERT OR DELETE OR UPDATE ON tg_powiazanieplanu FOR EACH ROW EXECUTE PROCEDURE oniudpowiazanieplanu();


--
--

CREATE TRIGGER oniudprace BEFORE INSERT OR DELETE OR UPDATE ON tg_prace FOR EACH ROW EXECUTE PROCEDURE oniudprace();


--
--

CREATE TRIGGER oniudpraceallt BEFORE INSERT OR DELETE OR UPDATE ON tg_praceall FOR EACH ROW EXECUTE PROCEDURE oniudpraceall();


--
--

CREATE TRIGGER oniudprzejazdy BEFORE INSERT OR DELETE OR UPDATE ON tg_przejazdy FOR EACH ROW EXECUTE PROCEDURE oniudprzejazdy();


--
--

CREATE TRIGGER oniudpunktykartyt BEFORE INSERT OR DELETE OR UPDATE ON tg_punktykarty FOR EACH ROW EXECUTE PROCEDURE oniudpunktykarty();


--
--

CREATE TRIGGER oniudraporttc BEFORE INSERT OR DELETE OR UPDATE ON kh_raportelem FOR EACH ROW EXECUTE PROCEDURE oniudraportc();


--
--

CREATE TRIGGER oniudrealizacjapzamt BEFORE INSERT OR DELETE OR UPDATE ON tg_realizacjapzam FOR EACH ROW EXECUTE PROCEDURE oniudrealizacjapzam();


--
--

CREATE TRIGGER oniudrejestrelem BEFORE INSERT OR DELETE OR UPDATE ON kh_rejestrelem FOR EACH ROW EXECUTE PROCEDURE oniudrejestrelem();


--
--

CREATE TRIGGER oniudrejestrhead BEFORE INSERT OR DELETE OR UPDATE ON kh_rejestrhead FOR EACH ROW EXECUTE PROCEDURE oniudrejestrhead();


--
--

CREATE TRIGGER oniudrodzajtransakcjit AFTER INSERT OR DELETE OR UPDATE ON tg_rodzajtransakcji FOR EACH ROW EXECUTE PROCEDURE oniudrodzajtransakcji();


--
--

CREATE TRIGGER oniudrrozchodukalk AFTER INSERT OR DELETE OR UPDATE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE oniudrrozchodukalk();


--
--

CREATE TRIGGER oniudskojarzenia BEFORE INSERT OR DELETE OR UPDATE ON kh_zapisskoj FOR EACH ROW EXECUTE PROCEDURE oniudzapisskoj();


--
--

CREATE TRIGGER oniudsrodkitrwale BEFORE INSERT OR DELETE OR UPDATE ON st_srodkitrwale FOR EACH ROW EXECUTE PROCEDURE oniudsrodkitrwale();


--
--

CREATE TRIGGER oniudswiadectwat BEFORE INSERT OR DELETE OR UPDATE ON tg_swiadectwa FOR EACH ROW EXECUTE PROCEDURE oniudswiadectwa();


--
--

CREATE TRIGGER oniudswiadruchyt BEFORE INSERT OR DELETE OR UPDATE ON tg_swiadruchy FOR EACH ROW EXECUTE PROCEDURE oniudswiadruchy();


--
--

CREATE TRIGGER oniudtechnoelemat AFTER INSERT OR DELETE OR UPDATE ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE oniudtechnoelema();


--
--

CREATE TRIGGER oniudtechnoelemkalk AFTER INSERT OR DELETE OR UPDATE ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE oniudtechnoelemkalk();


--
--

CREATE TRIGGER oniudtechnologiet AFTER INSERT OR DELETE OR UPDATE ON tr_technologie FOR EACH ROW EXECUTE PROCEDURE oniudtechnologie();


--
--

CREATE TRIGGER oniudtechnoprevnextat AFTER INSERT OR DELETE OR UPDATE ON tr_technoprevnext FOR EACH ROW EXECUTE PROCEDURE oniudtechnoprevnexta();


--
--

CREATE TRIGGER oniudtechnoprevnextt BEFORE INSERT OR DELETE OR UPDATE ON tr_technoprevnext FOR EACH ROW EXECUTE PROCEDURE oniudtechnoprevnext();


--
--

CREATE TRIGGER oniudtechnorrozchodut BEFORE INSERT OR DELETE OR UPDATE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE oniudtechnorrozchodu();


--
--

CREATE TRIGGER oniudtechnostpracyt BEFORE INSERT OR DELETE OR UPDATE ON tr_technostpracy FOR EACH ROW EXECUTE PROCEDURE oniudtechnostpracy();


--
--

CREATE TRIGGER oniudtkt BEFORE INSERT OR DELETE OR UPDATE ON tg_tkelem FOR EACH ROW EXECUTE PROCEDURE oniudtk();


--
--

CREATE TRIGGER oniudtmptowaryt BEFORE INSERT OR DELETE OR UPDATE ON tl_tmptowary FOR EACH ROW EXECUTE PROCEDURE oniudtmptowary();


--
--

CREATE TRIGGER oniudtrig BEFORE INSERT OR DELETE OR UPDATE ON tg_transakcje FOR EACH ROW EXECUTE PROCEDURE oniudtrans();


--
--

CREATE TRIGGER oniuduniversalfiles BEFORE INSERT OR DELETE OR UPDATE ON tb_universalfiles FOR EACH ROW EXECUTE PROCEDURE oniuduniversalfiles();


--
--

CREATE TRIGGER oniudversions BEFORE INSERT OR DELETE OR UPDATE ON tc_version FOR EACH ROW EXECUTE PROCEDURE oniudversions();


--
--

CREATE TRIGGER oniudwariantelemt BEFORE INSERT OR DELETE OR UPDATE ON tr_wariantelem FOR EACH ROW EXECUTE PROCEDURE oniudwariantelem();


--
--

CREATE TRIGGER oniudwynagrodzeniadokt BEFORE INSERT OR DELETE OR UPDATE ON tg_wynagrodzeniadok FOR EACH ROW EXECUTE PROCEDURE oniudwynagrodzeniadok();


--
--

CREATE TRIGGER oniudwynikiraportowt BEFORE INSERT OR DELETE OR UPDATE ON tf_wynikiraportow FOR EACH ROW EXECUTE PROCEDURE oniudwynikiraportow();


--
--

CREATE TRIGGER oniudwypalt BEFORE INSERT OR DELETE OR UPDATE ON tp_wypal FOR EACH ROW EXECUTE PROCEDURE oniudwypal();


--
--

CREATE TRIGGER oniudzapisyelem BEFORE INSERT OR DELETE OR UPDATE ON kh_zapisyelem FOR EACH ROW EXECUTE PROCEDURE onuelzapisu();


--
--

CREATE TRIGGER oniudzapisykpir BEFORE INSERT OR DELETE OR UPDATE ON kh_zapisykpir FOR EACH ROW EXECUTE PROCEDURE oniudzapisykpir();


--
--

CREATE TRIGGER oniudzdarzenia AFTER INSERT OR DELETE OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE oniudzdarzenia();


--
--

CREATE TRIGGER oniudzdarzenia_sprawy AFTER INSERT OR DELETE OR UPDATE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE oniudzdarzenia_sprawy();


--
--

CREATE TRIGGER oniudzlecenie BEFORE INSERT OR DELETE OR UPDATE ON tg_zlecenia FOR EACH ROW EXECUTE PROCEDURE oniudzlecenie();


--
--

CREATE TRIGGER oniudzmianyt BEFORE INSERT OR DELETE OR UPDATE ON tr_zmiany FOR EACH ROW EXECUTE PROCEDURE oniudzmiany();


--
--

CREATE TRIGGER oniuplatnosc BEFORE INSERT OR DELETE OR UPDATE ON kh_platnosci FOR EACH ROW EXECUTE PROCEDURE onuplatnosc();


--
--

CREATE TRIGGER oniurealizacjaplanuprod BEFORE INSERT OR DELETE OR UPDATE ON tg_realizacjaplanuprod FOR EACH ROW EXECUTE PROCEDURE oniurealizacjaplanuprod();


--
--

CREATE TRIGGER oniustatusyhistoria BEFORE INSERT ON tg_statusyhistoria FOR EACH ROW EXECUTE PROCEDURE oniustatusyhistoria();


--
--

CREATE TRIGGER oniuudzielonerabaty BEFORE INSERT OR DELETE OR UPDATE ON tg_udzielonerabaty FOR EACH ROW EXECUTE PROCEDURE oniuudzielonerabaty();


--
--

CREATE TRIGGER oniuwzorceelfiltrt BEFORE INSERT OR DELETE OR UPDATE ON kh_wzorceelfiltr FOR EACH ROW EXECUTE PROCEDURE oniuwzorceelfiltr();


--
--

CREATE TRIGGER onprzynaleznoscit AFTER INSERT OR DELETE OR UPDATE ON tm_przynaleznosci FOR EACH ROW EXECUTE PROCEDURE onprzynaleznosci();


--
--

CREATE TRIGGER onudpracownicyzdarzenia AFTER DELETE OR UPDATE ON tb_pracownicyzdarzenia FOR EACH ROW EXECUTE PROCEDURE onudpracownicyzdarzenia();


--
--

CREATE TRIGGER onukontaktyt BEFORE UPDATE ON tb_kontakt FOR EACH ROW EXECUTE PROCEDURE onukontakty();


--
--

CREATE TRIGGER onuobiektyt AFTER UPDATE ON tg_obiekty FOR EACH ROW EXECUTE PROCEDURE onuobiekty();


--
--

CREATE TRIGGER onupdatetowt BEFORE INSERT OR DELETE OR UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE oniudtowary();


--
--

CREATE TRIGGER onustanowiskapracyt AFTER UPDATE ON tp_stanowiskapracy FOR EACH ROW EXECUTE PROCEDURE onustanowiskapracy();


--
--

CREATE TRIGGER onutechnoelemt BEFORE UPDATE ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE onutechnoelem();


--
--

CREATE TRIGGER onutowaryakcjimt AFTER INSERT OR UPDATE ON tg_towaryakcjim FOR EACH ROW EXECUTE PROCEDURE onautowaryakcjim();


--
--

CREATE TRIGGER onuzapisy BEFORE INSERT OR UPDATE ON kh_zapisyhead FOR EACH ROW EXECUTE PROCEDURE onunzapisu();


--
--

CREATE TRIGGER p_mrpp_onddyspmag AFTER DELETE ON tr_dyspozycjamag FOR EACH ROW WHEN ((old.mrpp_idpalety IS NOT NULL)) EXECUTE PROCEDURE gm.mrpp_ondyspozycjamag();


--
--

CREATE TRIGGER p_mrpp_ondruch AFTER DELETE ON tg_ruchy FOR EACH ROW WHEN ((old.mrpp_idpalety IS NOT NULL)) EXECUTE PROCEDURE gm.mrpp_onaiudruch();


--
--

CREATE TRIGGER p_mrpp_onidyspmag AFTER INSERT ON tr_dyspozycjamag FOR EACH ROW WHEN ((new.mrpp_idpalety IS NOT NULL)) EXECUTE PROCEDURE gm.mrpp_ondyspozycjamag();


--
--

CREATE TRIGGER p_mrpp_oniruch AFTER INSERT ON tg_ruchy FOR EACH ROW WHEN ((new.mrpp_idpalety IS NOT NULL)) EXECUTE PROCEDURE gm.mrpp_onaiudruch();


--
--

CREATE TRIGGER p_mrpp_onudyspmag AFTER UPDATE ON tr_dyspozycjamag FOR EACH ROW WHEN ((new.mrpp_idpalety IS DISTINCT FROM old.mrpp_idpalety)) EXECUTE PROCEDURE gm.mrpp_ondyspozycjamag();


--
--

CREATE TRIGGER p_mrpp_onuruch AFTER UPDATE ON tg_ruchy FOR EACH ROW WHEN (((new.mrpp_idpalety IS DISTINCT FROM old.mrpp_idpalety) OR ((new.mrpp_idpalety IS NOT NULL) AND (ispzet(new.rc_flaga) <> ispzet(old.rc_flaga))) OR ((new.mrpp_idpalety IS NOT NULL) AND (((new.rc_iloscpoz * old.rc_iloscpoz) = (0)::numeric) AND ((new.rc_iloscpoz + old.rc_iloscpoz) <> (0)::numeric))))) EXECUTE PROCEDURE gm.mrpp_onaiudruch();


--
--

CREATE TRIGGER p_on_a_iud_kkwczasy AFTER INSERT OR DELETE OR UPDATE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE on_a_iud_kkwczasy();


--
--

CREATE TRIGGER p_on_a_iud_narzedzieruch AFTER INSERT OR DELETE OR UPDATE ON tr_narzedzie_ruch FOR EACH ROW EXECUTE PROCEDURE p_on_a_iud_narzedzieruch();


--
--

CREATE TRIGGER p_on_a_iud_nodwyk_narzedzia AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwyk FOR EACH ROW EXECUTE PROCEDURE p_on_a_iud_nodwyk_narzedzia();


--
--

CREATE TRIGGER p_on_a_iud_trruchy_narzedzia AFTER INSERT OR DELETE OR UPDATE ON tr_ruchy FOR EACH ROW EXECUTE PROCEDURE p_on_a_iud_trruchy_narzedzia();


--
--

CREATE TRIGGER p_on_b_iud_narzedzieruch BEFORE INSERT OR DELETE OR UPDATE ON tr_narzedzie_ruch FOR EACH ROW EXECUTE PROCEDURE p_on_b_iud_narzedzieruch();


--
--

CREATE TRIGGER p_onaiudruchymmt AFTER INSERT OR DELETE OR UPDATE ON tg_ruchy FOR EACH ROW EXECUTE PROCEDURE gm.onaiudruchymm();


--
--

CREATE TRIGGER p_onbukkwnod BEFORE UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE onbukkwnod();


--
--

CREATE TRIGGER r_on_a_iud_kkwnodrozmiarowka AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE on_a_iud_kkwnodrozmiarowka();


--
--

CREATE TRIGGER r_on_a_iud_nodwykrozmiarowka AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnodwyk FOR EACH ROW EXECUTE PROCEDURE on_a_iud_nodwykrozmiarowka();


--
--

CREATE TRIGGER s_on_a_iud_kkwnod_warianty AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE s_on_a_iud_kkwnod_warianty();


--
--

CREATE TRIGGER t_on_a_iud_kkwnodczasy AFTER INSERT OR DELETE OR UPDATE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE on_a_iud_kkwnodczasy();


--
--

CREATE TRIGGER tb_binarydata_update BEFORE UPDATE ON tb_binarydata FOR EACH ROW EXECUTE PROCEDURE onubinarydata();


--
--

CREATE TRIGGER tb_tag_tr_delete BEFORE DELETE ON tb_tag FOR EACH ROW EXECUTE PROCEDURE tb_tag_delete();


--
--

CREATE TRIGGER tb_tag_tr_insert BEFORE INSERT ON tb_tag FOR EACH ROW EXECUTE PROCEDURE tb_tag_insert();


--
--

CREATE TRIGGER tb_zdarzeniaptlist_aid AFTER INSERT OR DELETE ON tb_zdarzeniaptlist FOR EACH STATEMENT EXECUTE PROCEDURE tb_zdarzeniaptlist_lp_upd();


--
--

CREATE TRIGGER w_planzleceniatecontrol AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE gm.planzleceniatecontrol();


--
--

CREATE TRIGGER x_execsyncrpzam AFTER INSERT OR UPDATE ON tg_transelem FOR EACH ROW WHEN ((((new.tel_newflaga & (1 << 17)) <> 0) OR ((new.tel_new2flaga & (1 << 23)) <> 0))) EXECUTE PROCEDURE gm.onexecsyncrpzam();


--
--

CREATE TRIGGER x_gm_cenachangedafter_xref AFTER INSERT OR DELETE OR UPDATE ON tg_ceny FOR EACH ROW EXECUTE PROCEDURE gm.onaiudtgceny();


--
--

CREATE TRIGGER x_gm_onzamkniecieotwarciedokumentu AFTER UPDATE ON tg_transakcje FOR EACH ROW WHEN (((new.tr_zamknieta & 1) <> (old.tr_zamknieta & 1))) EXECUTE PROCEDURE gm.onzamkniecietowarciedokumentu();


--
--

CREATE TRIGGER x_gm_onzmianacenyzakuputowart AFTER UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE gm.onzmianacenyzakuputowar();


--
--

CREATE TRIGGER x_gm_towarchanged_syncidxes AFTER UPDATE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE gm.onaiudsyncchildidx();


--
--

CREATE TRIGGER x_kh_kodchanged AFTER UPDATE ON tb_klient FOR EACH ROW WHEN ((old.k_kod IS DISTINCT FROM new.k_kod)) EXECUTE PROCEDURE onuklientkh();


--
--

CREATE TRIGGER x_onbtransakcjedatazamk BEFORE UPDATE ON tg_transakcje FOR EACH ROW EXECUTE PROCEDURE onutransakcjedatazamk();


--
--

CREATE TRIGGER x_oniudtecontrol_t AFTER INSERT OR DELETE OR UPDATE ON tg_tecontrol FOR EACH ROW EXECUTE PROCEDURE gm.oniudtecontrol();


--
--

CREATE TRIGGER x_onplanzleceniarezerwacjecontrol AFTER INSERT OR DELETE OR UPDATE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE gm.onpzrezerwacjecontrol();


--
--

CREATE TRIGGER y_ptowar_onadtranselem AFTER DELETE ON tg_transelem FOR EACH ROW WHEN (teispseudotowar(old.tel_new2flaga)) EXECUTE PROCEDURE gm.ptowar_onaiudtranselem();


--
--

CREATE TRIGGER y_ptowar_onaitranselem AFTER INSERT ON tg_transelem FOR EACH ROW WHEN (teispseudotowar(new.tel_new2flaga)) EXECUTE PROCEDURE gm.ptowar_onaiudtranselem();


--
--

CREATE TRIGGER y_ptowar_onautranselem AFTER UPDATE ON tg_transelem FOR EACH ROW WHEN ((teispseudotowar(new.tel_new2flaga) OR teispseudotowar(old.tel_new2flaga))) EXECUTE PROCEDURE gm.ptowar_onaiudtranselem();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tb_klient FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tb_klient();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tg_transakcje FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tg_transakcje();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tg_towary();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tb_pracownicy FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tb_pracownicy();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON ts_banki FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_ts_banki();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tg_inwdupusty FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tg_inwdupusty();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tc_ustawieniapdf FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tc_ustawieniapdf();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tg_skladnikizestawu FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tg_skladnikizestawu();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tg_jednostkialt FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tg_jednostkialt();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tb_telefony FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tb_telefony();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tb_bankirel FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tb_bankirel();


--
--

CREATE TRIGGER z_datachanged_onid AFTER INSERT OR DELETE ON tb_ludzieklienta FOR EACH ROW EXECUTE PROCEDURE recchanges_iud_tb_ludzieklienta();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tb_pracownicy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tb_pracownicy();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON ts_banki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_ts_banki();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tg_inwdupusty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tg_inwdupusty();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tc_ustawieniapdf FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tc_ustawieniapdf();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tg_skladnikizestawu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tg_skladnikizestawu();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tb_telefony FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tb_telefony();


--
--

CREATE TRIGGER z_datachanged_onu AFTER UPDATE ON tb_bankirel FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE recchanges_iud_tb_bankirel();


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_klient FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('1', 'k_idklienta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_obiekty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('2', 'ob_idobiektu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_waluty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('3', 'wl_idwaluty');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_zapisyelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('4', 'zp_idelzapisu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_zapisyhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('5', 'zk_idzapisu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_konta FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('6', 'kt_idkonta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_dziennik FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('7', 'dz_iddziennika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_transakcje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('8', 'tr_idtrans');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_magazyny FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('9', 'tmg_idmagazynu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_towary FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_pracownicy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('11', 'p_idpracownika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_grupytow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('12', 'tgr_idgrupy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_podgrupytow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('13', 'tpg_idpodgrupy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_regiony FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('14', 'rj_idregionu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tc_config FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('15', 'cf_tabela');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_towmag FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('16', 'ttm_idtowmag');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_transelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('17', 'tel_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_platnosci FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('19', 'pl_idplatnosc');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_banki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('21', 'bk_idbanku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_jednostki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('22', 'tjn_idjedn');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_zrodloinf FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('23', 'zi_idzrodla');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_powiaty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('24', 'pw_idpowiatu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rodzajklienta FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('25', 'rk_idrodzajklienta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_vaty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('27', 'ttv_idvatu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_efekt FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('31', 'ef_idefektu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_zlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('32', 'zl_idzlecenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_ludzieklienta FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('35', 'lk_idczklienta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_dzialy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('36', 'dz_iddzialu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_profile FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('37', 'pf_idprofilu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rodzajakcji FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('38', 'ra_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_typspotkania FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('40', 'tp_idtypspotkania');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_wplywdecyzje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('44', 'wd_idwplywu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_zwrotgrzeczn FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('45', 'zg_idzwrotu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_branze FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('46', 'br_idbranzy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_stanowisko FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('47', 'st_idstanowiska');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_wagiklienta FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('48', 'wk_idwagi');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_inwdupusty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('50', 'iu_idinwdupusty');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_pliki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('51', 'tpl_idpliku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_przejazdy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('53', 'pr_idprzejazdu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_prace FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('54', 'pr_idpracy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_statuszlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('55', 'szl_idstatusu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_planzlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('56', 'pz_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_klientzlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('58', 'kz_idklienta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tu_uprawnienia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('59', 'u_iduprawnienia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_imprezy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('60', 'ti_idimprezy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_klbranza FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('61', 'kb_idklbranza');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_produkcja FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('63', 'tsk_idskladnika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_seriepracownikow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('65', 'sp_idserie');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_firma FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('66', 'fm_index');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_tabele FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('67', 'tb_idtabeli');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_slownik FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('68', 'sl_idslownika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_eltabeli FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('69', 'et_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_elslownika FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('70', 'es_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rozne FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('71', 'rn_idrozne');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_nazwarejestru FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('72', 'nr_idnazwy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_rejestrelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('73', 'rve_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_rejestrhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('74', 'rh_idrejestru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_lata FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('75', 'ro_idroku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_hotelezlecen FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('76', 'ht_idhotelu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorce FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('77', 'wz_idwzorca');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_grupysrtrw FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('78', 'gst_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorceelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('79', 'we_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON st_srodkitrwale FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('80', 'str_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON st_amortyzacja FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('81', 'am_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON st_kontastwlatach FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('82', 'str_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_wiadomoscdnia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('83', 'wd_idwiadomosci');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_schematexpplat FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('84', 'ep_idschematu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_raporty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('85', 'rp_idraportu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_raportelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('86', 're_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_raportlisc FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('87', 'rl_idliscia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_odsetki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('88', 'os_idstawki');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tc_ediconfig FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('89', 'edi_idkonta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kalkulacjeval FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('91', 'kv_idwartosci');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kalkulacje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('92', 'kk_idkalk');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tc_ustawieniapdf FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('94', 'pdf_idustawienia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_operacjagoskpir FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('95', 'og_idoperacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_zapisykpir FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('96', 'kp_idzapisu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorcekpir FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('97', 'wzk_idwzorca');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorceelemkpir FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('98', 'wk_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_konwersjakpir FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('99', 'kk_idkonwersji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_tkelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('100', 'tk_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_kontavatowekh FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('101', 'kv_idkonta');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_raportplan FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('102', 'pl_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_voucher FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('103', 'vc_idvoucher');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON st_zdarzeniast FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('106', 'zd_idzdarzenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON st_planst FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('107', 'pl_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_wlascicielefirmy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('108', 'wf_idwlasciciela');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_ecod FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('109', 'ecod_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_ignorowaneeany FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('110', 'ie_ideanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_kkwhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('112', 'kwh_idheadu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_kkwelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('113', 'kwe_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_polprodukty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('114', 'pp_idpolproduktu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_etapkkw FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('115', 'ek_idetapu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_etappolproduktu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('116', 'ep_idetapu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_konwersje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('117', 'cv_idkonwersji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorceelfiltr FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('118', 'wf_idfiltru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_kkwplan FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('119', 'kwp_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_kkwrecrozchodu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('120', 'rr_idskladnika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_zamiennikitow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('122', 'zt_idzamiennika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_stanytowmagazyn FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('123', 'stm_idstanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_mozliwestanowiska FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('126', 'ms_idmozliwosci');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_wydzialy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('127', 'w_idwydzialu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_planonkkw FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('128', 'kwl_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_elementobiektu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('129', 'eo_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_spedycje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('130', 'sp_idspedytora');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rabatykwotowe FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('131', 'rk_idrabatu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tp_wypal FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('132', 'wp_idwypalu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_skladnikizestawu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('133', 'sz_idskladnika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_zmiennedoskryptow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('134', 'zds_idzmiennej');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_fkalkulacji FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('135', 'f_idformuly');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_realizacjapzam FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('136', 'rm_idrealizacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_zmianacenypz FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('137', 'cpz_idzmiany');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_jednostkialt FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('138', 'ja_idjednostki');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_statustransportu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('139', 'sl_idstatusu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_transport FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('140', 'lt_idtransportu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tf_raport FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('141', 'fr_idraportu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tf_raportklocki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('142', 'fk_idklocka');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kliencilogistyki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('143', 'kl_idklientalog');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_bilety FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('144', 'bl_idbiletu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_osrodkipk FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('145', 'opk_idosrodka');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_technologie FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('146', 'th_idtechnologii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_technoelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('147', 'the_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_operacjetech FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('148', 'top_idoperacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_technoprevnext FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('149', 'thpn_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_rrozchodu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('150', 'trr_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_technostpracy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('151', 'tsp_idstanowiska');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('152', 'kwh_idheadu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnod FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('153', 'kwe_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnodprevnext FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('154', 'knpn_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnodwyk FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('155', 'knw_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnodwykdet FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('156', 'kwd_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_nodrec FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('157', 'knr_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_ruchy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('158', 'kwc_idruchu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_statusy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('159', 'st_idstatusu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_statusyhistoria FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('160', 'sh_idstathis');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_formaplat FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('161', 'pl_formaplat');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnodplan FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('162', 'knp_idplanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_ciagtech FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('163', 'ct_idciagu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_listprzewozowy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('164', 'lt_idtransportu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rodzajabonamentu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('165', 'ra_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_abonamenty FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('166', 'ab_idabonamentu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_abonamelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('167', 'ae_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_grupycen FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('168', 'tgc_idgrupy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_ceny FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('169', 'tcn_idceny');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_packhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('170', 'pk_idpaczki');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_packelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('171', 'pe_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_hotelestruktura FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('172', 'hs_idstruktury');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_hoteleelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('173', 'he_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_technogrupy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('174', 'thg_idgrupy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tf_klocekparams FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('175', 'fp_idparamu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tf_wynikiraportow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('176', 'fw_idwyniku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_dostawy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('177', 'dw_iddostawy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_dostawaelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('178', 'de_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_pcn_old FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('179', 'pcn_numer');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_tabelakursow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('180', 'tw_idtabeli');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kursywalut FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('181', 'kw_idkursu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kursdok FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('182', 'kd_idkursu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tc_etykiety FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('183', 'zpl_idetykiety');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_binarydata FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('184', 'bd_iddata');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_harmonogram FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('185', 'hm_idharmonogramu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_przyczynaprzestojow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('186', 'pp_idprzyczyny');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_telefony FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('188', 'ph_idtelefonu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_grupywww FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('189', 'tgw_idgrupy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_progispedycji FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('190', 'ps_idprogu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_warianthead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('191', 'vmp_idwariantu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_wariantelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('192', 've_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_vatykraje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('194', 'vk_idvatkraj');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_vatytowarow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('195', 'tv_idvatu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_logkltrans FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('196', 'lkt_idpowiazania');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_drzewa FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('198', 'trr_iddrzewa');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_trees FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('199', 'te_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_treemembers FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('200', 'tt_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_wynagrodzeniadok FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('202', 'wnd_idwynagrodzenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_wynagrodzenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('203', 'wg_idwynagrodzenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kartypremiowe FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('204', 'kr_idkarty');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_typdostawcyalt FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('205', 'tda_idtypu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('206', 'zd_idzdarzenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdpowiazania FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('207', 'zp_idpowiazania');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_typzdarzenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('208', 'tsz_idtypu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_kliencizdarzenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('209', 'kzd_idklientazd');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_pracownicyzdarzenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('210', 'pzd_idpracownika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_zmiany FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('211', 'zm_idzmiany');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kubelki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('212', 'kb_idkubelka');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_pracownicykubelka FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('213', 'pk_idprac');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_swiadectwa FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('214', 'sw_idswiadectwa');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_bankirel FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('215', 'br_idrelacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_masspayment FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('217', 'mp_idmp');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_praceall FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('218', 'pra_idpracy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kr_rozrachunki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('219', 'rr_idrozrachunku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kr_rozliczenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('220', 'rl_idrozliczenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_schowektowarow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('222', 'st_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_dniustawowowolne FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('223', 'duw_iddnia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_ustawieniadomprac FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('224', 'pu_idustawienia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_slownikwykonania FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('226', 'tsw_idslownika');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rodzajeobiektow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('227', 'rb_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rodzajtransakcji FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('228', 'trt_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_przyczynaawarii FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('229', 'pa_idawarii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_miejscamagazynowe FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('230', 'mm_idmiejsca');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_avizodostawy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('231', 'ad_idaviza');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_cyklicznosc FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('232', 'ck_idcyklu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_cyklwyjatki FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('234', 'cw_idwyjatku');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_kartotekadelegacji FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('235', 'kd_idkartoteki');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rozliczdelegacja FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('236', 'rd_idrozliczenia');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_vatzal FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('237', 'vz_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_strukturakonstrukcyjna FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('238', 'sk_idstruktury');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_stanyother FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('239', 'so_idstanu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kpohead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('241', 'kpo_idheadu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_kpoelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('242', 'kpe_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_kodyodpadu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('243', 'ko_idkodu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorceelempks FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('245', 'wep_idelementu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_wmsmm FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('246', 'wmm_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_wmsmmruch FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('247', 'wmr_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_paczkiprzewozowe FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('248', 'pp_idpaczki');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_towaryakcjim FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('249', 'ta_idtowaru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tm_mail FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('253', 'tma_idmail');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_etapprojektu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('254', 'pt_idetapu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_relacjaprojektu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('255', 'll_idrelacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_tplprojektu FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('256', 'plt_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_strukturakonstrukcyjnarel FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('257', 'skr_idrelacji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_bledy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('258', 'bl_idbledu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_rodzajebledow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('259', 'rbl_idbledu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_mrppalety FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('261', 'mrpp_idpalety');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_raportgui FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('264', 'rgui_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_rguival FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('265', 'rguiv_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_rguilists FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('266', 'rguil_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_sposobprzechowania FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('268', 'sp_idprzechow');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_przechowkl FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('269', 'pk_idprzechowkl');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_wsktkelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('270', 'wt_idwsk');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_pracownicyzlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('271', 'pzl_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zlecenia_skojarzone FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('272', 'zls_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_ftphost FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('273', 'fth_idhost');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_ftpuser FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('274', 'ftu_iduser');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_tag FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('275', 'tag_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_keyscontrollers FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('276', 'kct_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_chatuser FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('278', 'ctu_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_chatgroup FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('279', 'ctg_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_chatgroupmembers FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('280', 'ctm_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_chatfriends FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('281', 'ctf_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzeniapt FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('282', 'zdp_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzeniaptlist FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('283', 'zdl_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wymiaryslownik FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('284', 'wms_idwymiaru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wymiaryelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('285', 'wme_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wymiaryonkonto FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('286', 'wmk_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wymiarysumvalues FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('287', 'wmm_idsumy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wymiaryvalues FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('288', 'wmv_idvalue');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_role FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('289', 'rol_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_rolepdz FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('290', 'rpd_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_signparams FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('291', 'sprms_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_universalfiles FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('292', 'ufl_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzeniaco FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('294', 'zdo_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_wzorcewymiarow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('298', 'wzw_idwzorca');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzeniainfo FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('299', 'zdi_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_comments FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('300', 'com_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_powiazanieklcz FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('302', 'pkl_idpowiazania');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_kontatyp FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('303', 'ktt_idtypu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_czescizamienne FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('305', 'cz_idczesci');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_googleaccounts FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('306', 'gga_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_googlesynchronize FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('307', 'ggs_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzeniaetapzlecenia FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('308', 'zez_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tu_impplat FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('309', 'ipp_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tu_impplatelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('310', 'ipe_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_kalendarzhead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('311', 'kalh_idkalendarzahead');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_kalendarzelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('312', 'kale_idkalendarzaelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_flowchart FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('313', 'fct_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_flowchart_elements FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('314', 'fce_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_flowchart_connections FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('315', 'fcc_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_zdarzenia_flags FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('317', 'zdf_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_partie FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('318', 'prt_idpartii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_teex FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('320', 'tex_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_ppelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('321', 'ppe_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_partiehelper FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('338', 'prh_idpartii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_zledlugi FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('339', 'kzl_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_zledlugidet FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('340', 'kzld_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_loteria FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('357', 'lr_idloterii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_towaryloterii FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('358', 'ltw_idtowaru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_losyanaliza FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('359', 'lan_idanalizy');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_losy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('360', 'los_idlosu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_losyelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('361', 'lem_idelem');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_towaryakcjimdet FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('364', 'tad_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_pcns FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('179', 'pcn_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_mrpkalkulacje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('363', 'th_idtechnologii');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON kh_deferredkh FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('373', 'dkh_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_euronipy FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('375', 'eun_ideuronipu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_kkwnodwykdetkooperacja FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('376', 'kwk_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_statusyzachowanie FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('377', 'stz_idzachowania');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_listprzewozowyzbior FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('383', 'lpz_idzbioru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_scripts FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('384', 'scr_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_inwelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('389', 'ine_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_inwdetails FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('390', 'ind_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_znacznikprt FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('393', 'zprt_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_typspzakup FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('401', 'szt_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rozmrodzaje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('402', 'rmr_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rozmrodzajeelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('403', 'rme_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rozmsppak FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('406', 'rmp_idsposobu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_rozmsppakelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('407', 'rmk_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_pphead FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('415', 'pph_idheadu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_ppheadelem FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('416', 'phe_idheadelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tg_zamilosci FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('418', 'zmi_idelemu');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_dyspozycjamag FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('422', 'dmag_iddyspozycji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_plugins FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('425', 'plu_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tr_pomiary_definicje FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('432', 'pd_iddefinicji');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON tb_biometricdata FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('438', 'bmd_id');


--
--

CREATE TRIGGER z_datachanged_univ_k AFTER UPDATE ON tb_powiazanieklcz FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-1', 'k_idklienta');


--
--

CREATE TRIGGER z_datachanged_univ_lk AFTER UPDATE ON tb_powiazanieklcz FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-35', 'lk_idczklienta');


--
--

CREATE TRIGGER z_datachanged_univ_pr AFTER UPDATE ON ts_seriepracownikow FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-11', 'p_idpracownika');


--
--

CREATE TRIGGER z_datachanged_univ_r AFTER UPDATE ON tg_rozmrodzajeelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-402', 'rmr_idrodzaju');


--
--

CREATE TRIGGER z_datachanged_univ_sp AFTER UPDATE ON tg_rozmsppakelems FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-406', 'rmp_idsposobu');


--
--

CREATE TRIGGER z_datachanged_univ_tw AFTER UPDATE ON tg_stanytowmagazyn FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_datachanged_univ_tw AFTER UPDATE ON tg_ceny FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_klient FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('1', 'k_idklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_obiekty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('2', 'ob_idobiektu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_waluty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('3', 'wl_idwaluty');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_zapisyelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('4', 'zp_idelzapisu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_zapisyhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('5', 'zk_idzapisu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_konta FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('6', 'kt_idkonta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_dziennik FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('7', 'dz_iddziennika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_transakcje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('8', 'tr_idtrans');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_magazyny FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('9', 'tmg_idmagazynu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_towary FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_pracownicy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('11', 'p_idpracownika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_grupytow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('12', 'tgr_idgrupy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_podgrupytow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('13', 'tpg_idpodgrupy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_regiony FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('14', 'rj_idregionu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tc_config FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('15', 'cf_tabela');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_towmag FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('16', 'ttm_idtowmag');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_transelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('17', 'tel_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_platnosci FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('19', 'pl_idplatnosc');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_banki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('21', 'bk_idbanku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_jednostki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('22', 'tjn_idjedn');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_zrodloinf FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('23', 'zi_idzrodla');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_powiaty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('24', 'pw_idpowiatu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rodzajklienta FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('25', 'rk_idrodzajklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_vaty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('27', 'ttv_idvatu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_efekt FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('31', 'ef_idefektu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_zlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('32', 'zl_idzlecenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_ludzieklienta FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('35', 'lk_idczklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_dzialy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('36', 'dz_iddzialu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_profile FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('37', 'pf_idprofilu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rodzajakcji FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('38', 'ra_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_typspotkania FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('40', 'tp_idtypspotkania');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_wplywdecyzje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('44', 'wd_idwplywu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_zwrotgrzeczn FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('45', 'zg_idzwrotu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_branze FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('46', 'br_idbranzy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_stanowisko FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('47', 'st_idstanowiska');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_wagiklienta FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('48', 'wk_idwagi');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_inwdupusty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('50', 'iu_idinwdupusty');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_pliki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('51', 'tpl_idpliku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_przejazdy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('53', 'pr_idprzejazdu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_prace FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('54', 'pr_idpracy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_statuszlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('55', 'szl_idstatusu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_planzlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('56', 'pz_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_klientzlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('58', 'kz_idklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tu_uprawnienia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('59', 'u_iduprawnienia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_imprezy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('60', 'ti_idimprezy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_klbranza FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('61', 'kb_idklbranza');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_produkcja FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('63', 'tsk_idskladnika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_seriepracownikow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('65', 'sp_idserie');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_firma FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('66', 'fm_index');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_tabele FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('67', 'tb_idtabeli');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_slownik FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('68', 'sl_idslownika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_eltabeli FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('69', 'et_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_elslownika FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('70', 'es_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rozne FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('71', 'rn_idrozne');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_nazwarejestru FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('72', 'nr_idnazwy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_rejestrelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('73', 'rve_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_rejestrhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('74', 'rh_idrejestru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_lata FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('75', 'ro_idroku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_hotelezlecen FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('76', 'ht_idhotelu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorce FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('77', 'wz_idwzorca');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_grupysrtrw FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('78', 'gst_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorceelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('79', 'we_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON st_srodkitrwale FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('80', 'str_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON st_amortyzacja FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('81', 'am_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON st_kontastwlatach FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('82', 'str_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_wiadomoscdnia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('83', 'wd_idwiadomosci');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_schematexpplat FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('84', 'ep_idschematu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_raporty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('85', 'rp_idraportu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_raportelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('86', 're_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_raportlisc FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('87', 'rl_idliscia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_odsetki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('88', 'os_idstawki');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tc_ediconfig FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('89', 'edi_idkonta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kalkulacjeval FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('91', 'kv_idwartosci');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kalkulacje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('92', 'kk_idkalk');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tc_ustawieniapdf FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('94', 'pdf_idustawienia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_operacjagoskpir FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('95', 'og_idoperacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_zapisykpir FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('96', 'kp_idzapisu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorcekpir FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('97', 'wzk_idwzorca');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorceelemkpir FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('98', 'wk_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_konwersjakpir FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('99', 'kk_idkonwersji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_tkelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('100', 'tk_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_kontavatowekh FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('101', 'kv_idkonta');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_raportplan FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('102', 'pl_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_voucher FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('103', 'vc_idvoucher');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON st_zdarzeniast FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('106', 'zd_idzdarzenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON st_planst FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('107', 'pl_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_wlascicielefirmy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('108', 'wf_idwlasciciela');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_ecod FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('109', 'ecod_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_ignorowaneeany FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('110', 'ie_ideanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_kkwhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('112', 'kwh_idheadu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_kkwelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('113', 'kwe_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_polprodukty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('114', 'pp_idpolproduktu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_etapkkw FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('115', 'ek_idetapu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_etappolproduktu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('116', 'ep_idetapu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_konwersje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('117', 'cv_idkonwersji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorceelfiltr FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('118', 'wf_idfiltru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_kkwplan FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('119', 'kwp_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_kkwrecrozchodu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('120', 'rr_idskladnika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_zamiennikitow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('122', 'zt_idzamiennika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_stanytowmagazyn FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('123', 'stm_idstanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_mozliwestanowiska FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('126', 'ms_idmozliwosci');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_wydzialy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('127', 'w_idwydzialu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_planonkkw FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('128', 'kwl_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_elementobiektu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('129', 'eo_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_spedycje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('130', 'sp_idspedytora');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rabatykwotowe FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('131', 'rk_idrabatu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tp_wypal FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('132', 'wp_idwypalu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_skladnikizestawu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('133', 'sz_idskladnika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_zmiennedoskryptow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('134', 'zds_idzmiennej');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_fkalkulacji FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('135', 'f_idformuly');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_realizacjapzam FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('136', 'rm_idrealizacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_zmianacenypz FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('137', 'cpz_idzmiany');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_jednostkialt FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('138', 'ja_idjednostki');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_statustransportu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('139', 'sl_idstatusu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_transport FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('140', 'lt_idtransportu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tf_raport FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('141', 'fr_idraportu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tf_raportklocki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('142', 'fk_idklocka');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kliencilogistyki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('143', 'kl_idklientalog');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_bilety FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('144', 'bl_idbiletu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_osrodkipk FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('145', 'opk_idosrodka');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_technologie FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('146', 'th_idtechnologii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_technoelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('147', 'the_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_operacjetech FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('148', 'top_idoperacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_technoprevnext FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('149', 'thpn_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_rrozchodu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('150', 'trr_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_technostpracy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('151', 'tsp_idstanowiska');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('152', 'kwh_idheadu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnod FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('153', 'kwe_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnodprevnext FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('154', 'knpn_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnodwyk FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('155', 'knw_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnodwykdet FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('156', 'kwd_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_nodrec FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('157', 'knr_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_ruchy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('158', 'kwc_idruchu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_statusy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('159', 'st_idstatusu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_statusyhistoria FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('160', 'sh_idstathis');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_formaplat FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('161', 'pl_formaplat');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnodplan FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('162', 'knp_idplanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_ciagtech FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('163', 'ct_idciagu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_listprzewozowy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('164', 'lt_idtransportu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rodzajabonamentu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('165', 'ra_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_abonamenty FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('166', 'ab_idabonamentu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_abonamelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('167', 'ae_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_grupycen FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('168', 'tgc_idgrupy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_ceny FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('169', 'tcn_idceny');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_packhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('170', 'pk_idpaczki');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_packelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('171', 'pe_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_hotelestruktura FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('172', 'hs_idstruktury');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_hoteleelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('173', 'he_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_technogrupy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('174', 'thg_idgrupy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tf_klocekparams FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('175', 'fp_idparamu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tf_wynikiraportow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('176', 'fw_idwyniku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_dostawy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('177', 'dw_iddostawy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_dostawaelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('178', 'de_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_pcn_old FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('179', 'pcn_numer');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_tabelakursow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('180', 'tw_idtabeli');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kursywalut FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('181', 'kw_idkursu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kursdok FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('182', 'kd_idkursu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tc_etykiety FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('183', 'zpl_idetykiety');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_binarydata FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('184', 'bd_iddata');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_harmonogram FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('185', 'hm_idharmonogramu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_przyczynaprzestojow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('186', 'pp_idprzyczyny');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_telefony FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('188', 'ph_idtelefonu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_grupywww FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('189', 'tgw_idgrupy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_progispedycji FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('190', 'ps_idprogu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_warianthead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('191', 'vmp_idwariantu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_wariantelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('192', 've_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_vatykraje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('194', 'vk_idvatkraj');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_vatytowarow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('195', 'tv_idvatu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_logkltrans FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('196', 'lkt_idpowiazania');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_drzewa FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('198', 'trr_iddrzewa');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_trees FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('199', 'te_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_treemembers FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('200', 'tt_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_wynagrodzeniadok FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('202', 'wnd_idwynagrodzenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_wynagrodzenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('203', 'wg_idwynagrodzenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kartypremiowe FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('204', 'kr_idkarty');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_typdostawcyalt FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('205', 'tda_idtypu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('206', 'zd_idzdarzenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdpowiazania FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('207', 'zp_idpowiazania');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_typzdarzenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('208', 'tsz_idtypu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_kliencizdarzenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('209', 'kzd_idklientazd');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_pracownicyzdarzenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('210', 'pzd_idpracownika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_zmiany FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('211', 'zm_idzmiany');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kubelki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('212', 'kb_idkubelka');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_pracownicykubelka FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('213', 'pk_idprac');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_swiadectwa FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('214', 'sw_idswiadectwa');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_bankirel FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('215', 'br_idrelacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_masspayment FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('217', 'mp_idmp');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_praceall FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('218', 'pra_idpracy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kr_rozrachunki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('219', 'rr_idrozrachunku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kr_rozliczenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('220', 'rl_idrozliczenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_schowektowarow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('222', 'st_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_dniustawowowolne FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('223', 'duw_iddnia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_ustawieniadomprac FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('224', 'pu_idustawienia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_slownikwykonania FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('226', 'tsw_idslownika');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rodzajeobiektow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('227', 'rb_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rodzajtransakcji FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('228', 'trt_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_przyczynaawarii FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('229', 'pa_idawarii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_miejscamagazynowe FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('230', 'mm_idmiejsca');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_avizodostawy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('231', 'ad_idaviza');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_cyklicznosc FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('232', 'ck_idcyklu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_cyklwyjatki FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('234', 'cw_idwyjatku');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_kartotekadelegacji FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('235', 'kd_idkartoteki');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rozliczdelegacja FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('236', 'rd_idrozliczenia');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_vatzal FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('237', 'vz_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_strukturakonstrukcyjna FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('238', 'sk_idstruktury');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_stanyother FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('239', 'so_idstanu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kpohead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('241', 'kpo_idheadu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_kpoelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('242', 'kpe_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_kodyodpadu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('243', 'ko_idkodu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorceelempks FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('245', 'wep_idelementu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_wmsmm FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('246', 'wmm_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_wmsmmruch FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('247', 'wmr_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_paczkiprzewozowe FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('248', 'pp_idpaczki');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_towaryakcjim FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('249', 'ta_idtowaru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tm_mail FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('253', 'tma_idmail');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_etapprojektu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('254', 'pt_idetapu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_relacjaprojektu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('255', 'll_idrelacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_tplprojektu FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('256', 'plt_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_strukturakonstrukcyjnarel FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('257', 'skr_idrelacji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_bledy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('258', 'bl_idbledu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_rodzajebledow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('259', 'rbl_idbledu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_mrppalety FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('261', 'mrpp_idpalety');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_raportgui FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('264', 'rgui_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_rguival FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('265', 'rguiv_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_rguilists FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('266', 'rguil_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_sposobprzechowania FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('268', 'sp_idprzechow');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_przechowkl FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('269', 'pk_idprzechowkl');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_wsktkelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('270', 'wt_idwsk');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_pracownicyzlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('271', 'pzl_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zlecenia_skojarzone FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('272', 'zls_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_ftphost FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('273', 'fth_idhost');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_ftpuser FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('274', 'ftu_iduser');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_tag FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('275', 'tag_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_keyscontrollers FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('276', 'kct_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_chatuser FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('278', 'ctu_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_chatgroup FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('279', 'ctg_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_chatgroupmembers FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('280', 'ctm_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_chatfriends FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('281', 'ctf_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzeniapt FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('282', 'zdp_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzeniaptlist FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('283', 'zdl_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wymiaryslownik FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('284', 'wms_idwymiaru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wymiaryelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('285', 'wme_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wymiaryonkonto FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('286', 'wmk_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wymiarysumvalues FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('287', 'wmm_idsumy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wymiaryvalues FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('288', 'wmv_idvalue');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_role FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('289', 'rol_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_rolepdz FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('290', 'rpd_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_signparams FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('291', 'sprms_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_universalfiles FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('292', 'ufl_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzeniaco FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('294', 'zdo_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_wzorcewymiarow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('298', 'wzw_idwzorca');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzeniainfo FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('299', 'zdi_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_comments FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('300', 'com_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_powiazanieklcz FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('302', 'pkl_idpowiazania');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_kontatyp FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('303', 'ktt_idtypu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_czescizamienne FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('305', 'cz_idczesci');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_googleaccounts FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('306', 'gga_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_googlesynchronize FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('307', 'ggs_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzeniaetapzlecenia FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('308', 'zez_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tu_impplat FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('309', 'ipp_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tu_impplatelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('310', 'ipe_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_kalendarzhead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('311', 'kalh_idkalendarzahead');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_kalendarzelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('312', 'kale_idkalendarzaelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_flowchart FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('313', 'fct_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_flowchart_elements FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('314', 'fce_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_flowchart_connections FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('315', 'fcc_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_zdarzenia_flags FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('317', 'zdf_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_partie FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('318', 'prt_idpartii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_teex FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('320', 'tex_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_ppelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('321', 'ppe_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_partiehelper FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('338', 'prh_idpartii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_zledlugi FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('339', 'kzl_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_zledlugidet FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('340', 'kzld_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_loteria FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('357', 'lr_idloterii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_towaryloterii FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('358', 'ltw_idtowaru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_losyanaliza FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('359', 'lan_idanalizy');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_losy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('360', 'los_idlosu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_losyelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('361', 'lem_idelem');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_towaryakcjimdet FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('364', 'tad_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_pcns FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('179', 'pcn_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_mrpkalkulacje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('363', 'th_idtechnologii');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON kh_deferredkh FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('373', 'dkh_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_euronipy FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('375', 'eun_ideuronipu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_kkwnodwykdetkooperacja FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('376', 'kwk_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_statusyzachowanie FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('377', 'stz_idzachowania');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_listprzewozowyzbior FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('383', 'lpz_idzbioru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_scripts FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('384', 'scr_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_inwelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('389', 'ine_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_inwdetails FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('390', 'ind_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_znacznikprt FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('393', 'zprt_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_typspzakup FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('401', 'szt_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rozmrodzaje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('402', 'rmr_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rozmrodzajeelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('403', 'rme_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rozmsppak FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('406', 'rmp_idsposobu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_rozmsppakelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('407', 'rmk_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_pphead FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('415', 'pph_idheadu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_ppheadelem FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('416', 'phe_idheadelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tg_zamilosci FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('418', 'zmi_idelemu');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_dyspozycjamag FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('422', 'dmag_iddyspozycji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_plugins FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('425', 'plu_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tr_pomiary_definicje FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('432', 'pd_iddefinicji');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON tb_biometricdata FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('438', 'bmd_id');


--
--

CREATE TRIGGER z_datadeleted_insdel_k AFTER INSERT OR DELETE ON tb_powiazanieklcz FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-1', 'k_idklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel_lk AFTER INSERT OR DELETE ON tb_powiazanieklcz FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-35', 'lk_idczklienta');


--
--

CREATE TRIGGER z_datadeleted_insdel_pr AFTER INSERT OR DELETE ON ts_seriepracownikow FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-11', 'p_idpracownika');


--
--

CREATE TRIGGER z_datadeleted_insdel_r AFTER INSERT OR DELETE ON tg_rozmrodzajeelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-402', 'rmr_idrodzaju');


--
--

CREATE TRIGGER z_datadeleted_insdel_sp AFTER INSERT OR DELETE ON tg_rozmsppakelems FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-406', 'rmp_idsposobu');


--
--

CREATE TRIGGER z_datadeleted_insdel_tw AFTER INSERT OR DELETE ON tg_stanytowmagazyn FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_datadeleted_insdel_tw AFTER INSERT OR DELETE ON tg_ceny FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-10', 'ttw_idtowaru');


--
--

CREATE TRIGGER z_dbg_mrppaletymagazyn AFTER INSERT OR UPDATE ON tr_mrppalety FOR EACH ROW EXECUTE PROCEDURE gm.dbg_mrppaletymagazyn();


--
--

CREATE TRIGGER z_gms_onaiuruchy AFTER INSERT OR DELETE OR UPDATE ON tg_ruchy FOR EACH ROW EXECUTE PROCEDURE gms.onaiuruchyt();


--
--

CREATE TRIGGER z_onaiuddeferredkh AFTER INSERT OR DELETE OR UPDATE ON kh_deferredkh FOR EACH ROW EXECUTE PROCEDURE onaiuddeferredkh();


--
--

CREATE TRIGGER z_onaiudstrukturamrpkalkulacja AFTER INSERT OR DELETE OR UPDATE ON tr_strukturakonstrukcyjna FOR EACH ROW EXECUTE PROCEDURE onaiudstrukturamrpkalkulacja();


--
--

CREATE TRIGGER z_onaiudtechnologiamrpkalkulacja AFTER INSERT OR DELETE OR UPDATE ON tr_technologie FOR EACH ROW EXECUTE PROCEDURE onaiudtechnologiamrpkalkulacja();


--
--

CREATE TRIGGER z_onbiudtelefon BEFORE INSERT OR DELETE OR UPDATE ON tb_telefony FOR EACH ROW EXECUTE PROCEDURE onbiudtelefon();


--
--

CREATE TRIGGER z_recchange_id AFTER INSERT OR DELETE ON kr_rozrachunki FOR EACH ROW EXECUTE PROCEDURE onchangerozrachunekiud();


--
--

CREATE TRIGGER z_recchange_u AFTER UPDATE ON kr_rozrachunki FOR EACH ROW WHEN ((new.* IS DISTINCT FROM old.*)) EXECUTE PROCEDURE onchangerozrachunekiud();
