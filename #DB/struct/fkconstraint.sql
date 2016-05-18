ALTER TABLE ONLY tb_multival
    ADD CONSTRAINT "$1" FOREIGN KEY (mv_idvalue) REFERENCES ts_multivalues(mv_idvalue) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_voucher
    ADD CONSTRAINT "$1" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_fkalkulacji
    ADD CONSTRAINT "$1" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_zdarzeniast
    ADD CONSTRAINT "$1" FOREIGN KEY (str_id) REFERENCES st_srodkitrwale(str_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_planst
    ADD CONSTRAINT "$1" FOREIGN KEY (str_id) REFERENCES st_srodkitrwale(str_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ecod
    ADD CONSTRAINT "$1" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_hmsplat
    ADD CONSTRAINT "$1" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_archiwum
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kalkulacjeval
    ADD CONSTRAINT "$1" FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_kontastwlatach
    ADD CONSTRAINT "$1" FOREIGN KEY (kwl_kontogl) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_konwersje
    ADD CONSTRAINT "$1" FOREIGN KEY (cv_src) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT "$1" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$1" FOREIGN KEY (tp_idtypspotkania) REFERENCES ts_typspotkania(tp_idtypspotkania) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_eltabeli
    ADD CONSTRAINT "$1" FOREIGN KEY (tb_idtabeli) REFERENCES tg_tabele(tb_idtabeli) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportelem
    ADD CONSTRAINT "$1" FOREIGN KEY (re_ref) REFERENCES kh_raportelem(re_idelementu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_rejestrhead
    ADD CONSTRAINT "$1" FOREIGN KEY (nr_idnazwy) REFERENCES ts_nazwarejestru(nr_idnazwy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportplanelem
    ADD CONSTRAINT "$1" FOREIGN KEY (pl_idplanu) REFERENCES kh_raportplan(pl_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kompensatyhand
    ADD CONSTRAINT "$1" FOREIGN KEY (kh_idfaktury) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT "$1" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_hotelezlecen
    ADD CONSTRAINT "$1" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT "$1" FOREIGN KEY (pl_kompensata) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towmag
    ADD CONSTRAINT "$1" FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT "$1" FOREIGN KEY (dz_iddziennika) REFERENCES kh_dziennik(dz_iddziennika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_tabelavalues
    ADD CONSTRAINT "$1" FOREIGN KEY (et_idelementuy) REFERENCES tg_eltabeli(et_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorceelem
    ADD CONSTRAINT "$1" FOREIGN KEY (wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisskoj
    ADD CONSTRAINT "$1" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT "$1" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT "$1" FOREIGN KEY (kt_ref) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_konwersjakpir
    ADD CONSTRAINT "$1" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT "$1" FOREIGN KEY (re_idelementu) REFERENCES kh_raportelem(re_idelementu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY st_amortyzacja
    ADD CONSTRAINT "$1" FOREIGN KEY (ro_idrok) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_elslownika
    ADD CONSTRAINT "$1" FOREIGN KEY (sl_idslownika) REFERENCES tg_slownik(sl_idslownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicy
    ADD CONSTRAINT "$1" FOREIGN KEY (st_idstanowiska) REFERENCES ts_stanowisko(st_idstanowiska) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyelem
    ADD CONSTRAINT "$1" FOREIGN KEY (zk_idzapisu) REFERENCES kh_zapisyhead(zk_idzapisu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportplan
    ADD CONSTRAINT "$1" FOREIGN KEY (rp_idraportu) REFERENCES kh_raporty(rp_idraportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_todo
    ADD CONSTRAINT "$1" FOREIGN KEY (m_idkontaktu) REFERENCES tb_kontakt(m_idkontaktu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_tkelem
    ADD CONSTRAINT "$1" FOREIGN KEY (tjn_idjedn) REFERENCES tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_proces
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_schematexpplat
    ADD CONSTRAINT "$1" FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisykpir
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kalkulacje
    ADD CONSTRAINT "$1" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorceelemkpir
    ADD CONSTRAINT "$1" FOREIGN KEY (wzk_idwzorca) REFERENCES kh_wzorcekpir(wzk_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT "$1" FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT "$1" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tc_ediconfig
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_obroty
    ADD CONSTRAINT "$1" FOREIGN KEY (ob_ref) REFERENCES kh_obroty(ob_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_ludzieklienta
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_branze
    ADD CONSTRAINT "$1" FOREIGN KEY (pf_idprofilu) REFERENCES ts_profile(pf_idprofilu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_grupytow
    ADD CONSTRAINT "$1" FOREIGN KEY (br_idbranzy) REFERENCES ts_branze(br_idbranzy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_rejestrelem
    ADD CONSTRAINT "$1" FOREIGN KEY (rh_idrejestru) REFERENCES kh_rejestrhead(rh_idrejestru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_srodkitrwale
    ADD CONSTRAINT "$1" FOREIGN KEY (gst_id) REFERENCES ts_grupysrtrw(gst_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tu_uprawnienia
    ADD CONSTRAINT "$1" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_polprodukty
    ADD CONSTRAINT "$1" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwhead
    ADD CONSTRAINT "$1" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT "$1" FOREIGN KEY (kwh_idheadu) REFERENCES tp_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_etappolproduktu
    ADD CONSTRAINT "$1" FOREIGN KEY (ek_idetapu) REFERENCES ts_etapkkw(ek_idetapu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wzorceelfiltr
    ADD CONSTRAINT "$1" FOREIGN KEY (we_idelementu) REFERENCES kh_wzorceelem(we_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwplan
    ADD CONSTRAINT "$1" FOREIGN KEY (pp_idpolproduktu) REFERENCES tp_polprodukty(pp_idpolproduktu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwrecrozchodu
    ADD CONSTRAINT "$1" FOREIGN KEY (ep_idetapu) REFERENCES tp_etappolproduktu(ep_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zamiennikitow
    ADD CONSTRAINT "$1" FOREIGN KEY (zt_idtowarusrc) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_stanytowmagazyn
    ADD CONSTRAINT "$1" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_stanyother
    ADD CONSTRAINT "$1" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_statystykazapytan
    ADD CONSTRAINT "$1" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_podczepieniadoetapow
    ADD CONSTRAINT "$1" FOREIGN KEY (sz_idetapu) REFERENCES tg_etapyzlecen(sz_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT "$1" FOREIGN KEY (p_idpracownikafor) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_voucher
    ADD CONSTRAINT "$2" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_zdarzeniast
    ADD CONSTRAINT "$2" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_planst
    ADD CONSTRAINT "$2" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$2" FOREIGN KEY (rc_ruch) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$2" FOREIGN KEY (m_pwykonujacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT "$2" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_kontastwlatach
    ADD CONSTRAINT "$2" FOREIGN KEY (kwl_kontoum) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_archiwum
    ADD CONSTRAINT "$2" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_hotelezlecen
    ADD CONSTRAINT "$2" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_tabelavalues
    ADD CONSTRAINT "$2" FOREIGN KEY (et_idelementux) REFERENCES tg_eltabeli(et_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyelem
    ADD CONSTRAINT "$2" FOREIGN KEY (kt_idkontawn) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_kompensatyhand
    ADD CONSTRAINT "$2" FOREIGN KEY (kh_idkorekty) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT "$2" FOREIGN KEY (p_ksiegujacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT "$2" FOREIGN KEY (lk_czdomyslny) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_konwersjakpir
    ADD CONSTRAINT "$2" FOREIGN KEY (kp_idzapisu) REFERENCES kh_zapisykpir(kp_idzapisu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicy
    ADD CONSTRAINT "$2" FOREIGN KEY (dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_tkelem
    ADD CONSTRAINT "$2" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT "$2" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportelem
    ADD CONSTRAINT "$2" FOREIGN KEY (rp_idraportu) REFERENCES kh_raporty(rp_idraportu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_raportplanelem
    ADD CONSTRAINT "$2" FOREIGN KEY (re_idelementu) REFERENCES kh_raportelem(re_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_amortyzacja
    ADD CONSTRAINT "$2" FOREIGN KEY (st_id) REFERENCES st_srodkitrwale(str_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT "$2" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_todo
    ADD CONSTRAINT "$2" FOREIGN KEY (td_komu) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT "$2" FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT "$2" FOREIGN KEY (ob_ref) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorceelem
    ADD CONSTRAINT "$2" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT "$2" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_konwersje
    ADD CONSTRAINT "$2" FOREIGN KEY (cv_dest) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_rejestrhead
    ADD CONSTRAINT "$2" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT "$2" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT "$2" FOREIGN KEY (ro_idroku) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_polprodukty
    ADD CONSTRAINT "$2" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT "$2" FOREIGN KEY (kwe_prevelem) REFERENCES tp_kkwelem(kwe_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_etappolproduktu
    ADD CONSTRAINT "$2" FOREIGN KEY (pp_idpolproduktu) REFERENCES tp_polprodukty(pp_idpolproduktu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wzorceelfiltr
    ADD CONSTRAINT "$2" FOREIGN KEY (wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwplan
    ADD CONSTRAINT "$2" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwrecrozchodu
    ADD CONSTRAINT "$2" FOREIGN KEY (rr_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_zamiennikitow
    ADD CONSTRAINT "$2" FOREIGN KEY (zt_idtowarudesc) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_stanytowmagazyn
    ADD CONSTRAINT "$2" FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_stanyother
    ADD CONSTRAINT "$2" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_statystykazapytan
    ADD CONSTRAINT "$2" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_podczepieniadoetapow
    ADD CONSTRAINT "$2" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT "$2" FOREIGN KEY (td_idtodo) REFERENCES tb_todo(td_idtodo) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_mozliwestanowiska
    ADD CONSTRAINT "$2" FOREIGN KEY (ep_idetapu) REFERENCES tp_etappolproduktu(ep_idetapu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_voucher
    ADD CONSTRAINT "$3" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$3" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$3" FOREIGN KEY (a_idakcji) REFERENCES tb_akcja(a_idakcji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT "$3" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_tkelem
    ADD CONSTRAINT "$3" FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_tabelavalues
    ADD CONSTRAINT "$3" FOREIGN KEY (tb_idtabeli) REFERENCES tg_tabele(tb_idtabeli) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY st_kontastwlatach
    ADD CONSTRAINT "$3" FOREIGN KEY (kwl_kontoampod) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT "$3" FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_archiwum
    ADD CONSTRAINT "$3" FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT "$3" FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_todo
    ADD CONSTRAINT "$3" FOREIGN KEY (td_zlecajacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT "$3" FOREIGN KEY (rp_idraportu) REFERENCES kh_raporty(rp_idraportu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zapisyelem
    ADD CONSTRAINT "$3" FOREIGN KEY (kt_idkontama) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT "$3" FOREIGN KEY (pp_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT "$3" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wzorceelfiltr
    ADD CONSTRAINT "$3" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwrecrozchodu
    ADD CONSTRAINT "$3" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT "$3" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT "$3" FOREIGN KEY (ms_idmozliwosci) REFERENCES tp_mozliwestanowiska(ms_idmozliwosci) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$4" FOREIGN KEY (rc_rezerwacja) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$4" FOREIGN KEY (m_pwprowadzajacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT "$4" FOREIGN KEY (ro_idroku) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_tkelem
    ADD CONSTRAINT "$4" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY st_kontastwlatach
    ADD CONSTRAINT "$4" FOREIGN KEY (ro_idrok) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT "$4" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT "$4" FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_archiwum
    ADD CONSTRAINT "$4" FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$5" FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$5" FOREIGN KEY (ef_idefektu) REFERENCES ts_efekt(ef_idefektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT "$5" FOREIGN KEY (ep_idetapu) REFERENCES tp_etappolproduktu(ep_idetapu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$6" FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$6" FOREIGN KEY (rk_idrodzajkontaktu) REFERENCES ts_rodzajkontaktu(rk_idrodzajkontaktu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT "$6" FOREIGN KEY (ek_idetapu) REFERENCES ts_etapkkw(ek_idetapu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$7" FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$7" FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT "$8" FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kontakt
    ADD CONSTRAINT "$8" FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisskoj
    ADD CONSTRAINT am FOREIGN KEY (am_id) REFERENCES st_amortyzacja(am_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT etappolpr FOREIGN KEY (ep_idetapu) REFERENCES tp_etappolproduktu(ep_idetapu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT hmsplat FOREIGN KEY (hs_idelementu) REFERENCES tb_hmsplat(hs_idelementu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT idplatnosc2 FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_powiazanieklcz
    ADD CONSTRAINT k1 FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_czescizamienne
    ADD CONSTRAINT k1 FOREIGN KEY (ttw_idtowarusrc) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_documentmasterelem
    ADD CONSTRAINT k1 FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_powiazanieklcz
    ADD CONSTRAINT k2 FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT k_platnik_const FOREIGN KEY (k_idplatnik) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_kalkulacjeval
    ADD CONSTRAINT kalkulacjeconst FOREIGN KEY (kk_idkalk) REFERENCES tg_kalkulacje(kk_idkalk) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_kh_dz_iddziennika_fkey FOREIGN KEY (dkh_kh_dz_iddziennika) REFERENCES kh_dziennik(dz_iddziennika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_kh_wz_idwzorca_fkey FOREIGN KEY (dkh_kh_wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_kpir_wzk_idwzorca_fkey FOREIGN KEY (dkh_kpir_wzk_idwzorca) REFERENCES kh_wzorcekpir(wzk_idwzorca) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_rv_kursvat_idwaluty_fkey FOREIGN KEY (dkh_rv_kursvat_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_rv_nr_idnazwy2_fkey FOREIGN KEY (dkh_rv_nr_idnazwy2) REFERENCES ts_nazwarejestru(nr_idnazwy) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_dkh_rv_nr_idnazwy_fkey FOREIGN KEY (dkh_rv_nr_idnazwy) REFERENCES ts_nazwarejestru(nr_idnazwy) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_kp_idzapisu_out_fkey FOREIGN KEY (kp_idzapisu_out) REFERENCES kh_zapisykpir(kp_idzapisu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_pl_idplatnosc_fkey FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_rh_idrejestru_out_fkey FOREIGN KEY (rh_idrejestru_out) REFERENCES kh_rejestrhead(rh_idrejestru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_ro_idroku_fkey FOREIGN KEY (ro_idroku) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_deferredkh
    ADD CONSTRAINT kh_deferredkh_zk_idzapisu_out_fkey FOREIGN KEY (zk_idzapisu_out) REFERENCES kh_zapisyhead(zk_idzapisu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_ktn_idkonta_fkey FOREIGN KEY (ktn_idkonta) REFERENCES kh_kontanorm(ktn_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_ktt_idtypu_fkey FOREIGN KEY (ktt_idtypu) REFERENCES kh_kontatyp(ktt_idtypu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_konta
    ADD CONSTRAINT kh_konta_ktt_idtypuinh_fkey FOREIGN KEY (ktt_idtypuinh) REFERENCES kh_kontatyp(ktt_idtypu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_kontanorm
    ADD CONSTRAINT kh_kontanorm_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_lata
    ADD CONSTRAINT kh_lata_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platelem
    ADD CONSTRAINT kh_platelem_pl_idplatnosc2 FOREIGN KEY (pl_idplatnosc2) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_pl_idplatnosc_fkey FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_po_ref_fkey FOREIGN KEY (po_ref) REFERENCES kh_platfifo(po_idfifo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_po_refrr_fkey FOREIGN KEY (po_refrr) REFERENCES kh_platfifo(po_idfifo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_rl_idrozliczenia_fkey FOREIGN KEY (rl_idrozliczenia) REFERENCES kr_rozliczenia(rl_idrozliczenia) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_rr_idrozrachunku_fkey FOREIGN KEY (rr_idrozrachunku) REFERENCES kr_rozrachunki(rr_idrozrachunku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platfifo
    ADD CONSTRAINT kh_platfifo_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_br_idrelacji_fkey FOREIGN KEY (br_idrelacji) REFERENCES tb_bankirel(br_idrelacji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_pl_idplatnoscskoj_const FOREIGN KEY (pl_idplatnoscskoj) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_tr_idtrans FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_platnosci
    ADD CONSTRAINT kh_platnosci_zd_idzdarzenia FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_predekretacjainfo
    ADD CONSTRAINT kh_predekretacjainfo_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_predekretacjainfo
    ADD CONSTRAINT kh_predekretacjainfo_wz_idwzorca_fkey FOREIGN KEY (wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_predekretacjainfo
    ADD CONSTRAINT kh_predekretacjainfo_zk_idzapisu_fkey FOREIGN KEY (zk_idzapisu) REFERENCES kh_zapisyhead(zk_idzapisu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT kh_raportlisc_fk_idklocka_fkey FOREIGN KEY (fk_idklocka) REFERENCES tf_raportklocki(fk_idklocka) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_rejestrhead
    ADD CONSTRAINT kh_rejestrhead_rh_idwalutykursu_fkey FOREIGN KEY (rh_idwalutykursu) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wymiaryelems
    ADD CONSTRAINT kh_wymiaryelems_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_ktn_idkonta_fkey FOREIGN KEY (ktn_idkonta) REFERENCES kh_kontanorm(ktn_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_ro_idroku_fkey FOREIGN KEY (ro_idroku) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_wme_idelemu_fkey FOREIGN KEY (wme_idelemu) REFERENCES kh_wymiaryelems(wme_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryobroty
    ADD CONSTRAINT kh_wymiaryobroty_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryonkonto
    ADD CONSTRAINT kh_wymiaryonkonto_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryonkonto
    ADD CONSTRAINT kh_wymiaryonkonto_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryslownik
    ADD CONSTRAINT kh_wymiaryslownik_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiarysumvalues
    ADD CONSTRAINT kh_wymiarysumvalues_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiarysumvalues
    ADD CONSTRAINT kh_wymiarysumvalues_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wymiarysumvalues
    ADD CONSTRAINT kh_wymiarysumvalues_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiarysumvalues
    ADD CONSTRAINT kh_wymiarysumvalues_zp_idelzapisu_fkey FOREIGN KEY (zp_idelzapisu) REFERENCES kh_zapisyelem(zp_idelzapisu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_wme_idelemu_fkey FOREIGN KEY (wme_idelemu) REFERENCES kh_wymiaryelems(wme_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_wmm_idsumy_fkey FOREIGN KEY (wmm_idsumy) REFERENCES kh_wymiarysumvalues(wmm_idsumy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wymiaryvalues
    ADD CONSTRAINT kh_wymiaryvalues_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wzorce
    ADD CONSTRAINT kh_wzorce_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_wzorceelem
    ADD CONSTRAINT kh_wzorceelem_ref FOREIGN KEY (we_idelementuref) REFERENCES kh_wzorceelem(we_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorceelempks
    ADD CONSTRAINT kh_wzorceelempks_wep_idto_fkey FOREIGN KEY (wep_idto) REFERENCES kh_wzorceelempks(wep_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorceelempks
    ADD CONSTRAINT kh_wzorceelempks_wz_idwzorca_fkey FOREIGN KEY (wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorcewymiarow
    ADD CONSTRAINT kh_wzorcewymiarow_kwl_id_fkey FOREIGN KEY (kwl_id) REFERENCES st_kontastwlatach(kwl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorcewymiarow
    ADD CONSTRAINT kh_wzorcewymiarow_we_idelementu_fkey FOREIGN KEY (we_idelementu) REFERENCES kh_wzorceelem(we_idelementu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorcewymiarow
    ADD CONSTRAINT kh_wzorcewymiarow_wms_idwymiaru_fkey FOREIGN KEY (wms_idwymiaru) REFERENCES kh_wymiaryslownik(wms_idwymiaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_wzorcewymiarow
    ADD CONSTRAINT kh_wzorcewymiarow_wz_idwzorca_fkey FOREIGN KEY (wz_idwzorca) REFERENCES kh_wzorce(wz_idwzorca) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kh_zapisskoj
    ADD CONSTRAINT kh_zapisskoj_platelem FOREIGN KEY (pp_idplatelem) REFERENCES kh_platelem(pp_idplatelem) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zapisyelem
    ADD CONSTRAINT kh_zapisyelem_kt_idkontawkh_fkey FOREIGN KEY (kt_idkontawkh) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT kh_zapisyhead_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zapisyhead
    ADD CONSTRAINT kh_zapisyhead_tr_idtrans_wkh_fkey FOREIGN KEY (tr_idtrans_wkh) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zledlugi
    ADD CONSTRAINT kh_zledlugi_rc_idruchuwz_fkey FOREIGN KEY (rc_idruchuwz) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_zledlugi
    ADD CONSTRAINT kh_zledlugi_tr_idtransfz_fkey FOREIGN KEY (tr_idtransfz) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_zledlugi
    ADD CONSTRAINT kh_zledlugi_tr_idtranspz_fkey FOREIGN KEY (tr_idtranspz) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kh_zledlugidet
    ADD CONSTRAINT kh_zledlugidet_kzl_id_fkey FOREIGN KEY (kzl_id) REFERENCES kh_zledlugi(kzl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT kkw_elem_etap FOREIGN KEY (ek_idetapu) REFERENCES ts_etapkkw(ek_idetapu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwhead
    ADD CONSTRAINT kkw_head_pracownik FOREIGN KEY (p_utworzyl) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwhead
    ADD CONSTRAINT kkwplan_const FOREIGN KEY (kwp_idplanu) REFERENCES tp_kkwplan(kwp_idplanu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_convrr
    ADD CONSTRAINT kr_convrr_cvr_lid_fkey FOREIGN KEY (cvr_lid) REFERENCES kr_conv(cv_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_convrr
    ADD CONSTRAINT kr_convrr_cvr_rid_fkey FOREIGN KEY (cvr_rid) REFERENCES kr_conv(cv_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_kompensaty
    ADD CONSTRAINT kr_kompensaty_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_km_idkompensaty_fkey FOREIGN KEY (km_idkompensaty) REFERENCES kr_kompensaty(km_idkompensaty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_rk_fkey FOREIGN KEY (rl_idrozliczenia_rk) REFERENCES kr_rozliczenia(rl_idrozliczenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_rl_idrozliczenia_netto_fkey FOREIGN KEY (rl_idrozliczenia_netto) REFERENCES kr_rozliczenia(rl_idrozliczenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_rr_idrozrachunkul_fkey FOREIGN KEY (rr_idrozrachunkul) REFERENCES kr_rozrachunki(rr_idrozrachunku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozliczenia
    ADD CONSTRAINT kr_rozliczenia_rr_idrozrachunkur_fkey FOREIGN KEY (rr_idrozrachunkur) REFERENCES kr_rozrachunki(rr_idrozrachunku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_pl_idplatnosc_fkey FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_rr_idwaluty_fkey FOREIGN KEY (rr_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_sd_idsalda_fkey FOREIGN KEY (sd_idsalda) REFERENCES kr_salda(sd_idsalda) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_zp_idelzapisu_fkey FOREIGN KEY (zp_idelzapisu) REFERENCES kh_zapisyelem(zp_idelzapisu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kr_rozrachunki
    ADD CONSTRAINT kr_rozrachunki_zp_idelzapisurk_fkey FOREIGN KEY (zp_idelzapisurk) REFERENCES kh_zapisyelem(zp_idelzapisu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY kr_salda
    ADD CONSTRAINT kr_salda_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_salda
    ADD CONSTRAINT kr_salda_kt_idkonta_fkey FOREIGN KEY (kt_idkonta) REFERENCES kh_konta(kt_idkonta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY kr_salda
    ADD CONSTRAINT kr_salda_ro_idroku_fkey FOREIGN KEY (ro_idroku) REFERENCES kh_lata(ro_idroku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_raportlisc
    ADD CONSTRAINT odnosnikc FOREIGN KEY (re_valuefrom) REFERENCES kh_raportelem(re_idelementu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY kh_zapisskoj
    ADD CONSTRAINT pl FOREIGN KEY (pl_idplatnosc) REFERENCES kh_platnosci(pl_idplatnosc) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT plankkwc FOREIGN KEY (kwp_idplanu) REFERENCES tp_kkwplan(kwp_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kalkulacjeval
    ADD CONSTRAINT planzlecc FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT planzlecenia FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_pliki
    ADD CONSTRAINT plikic FOREIGN KEY (bd_iddata) REFERENCES tb_binarydata(bd_iddata) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tp_kkwhead
    ADD CONSTRAINT polprodukty_const FOREIGN KEY (pp_idpolproduktu) REFERENCES tp_polprodukty(pp_idpolproduktu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_kkwelem
    ADD CONSTRAINT polprodukty_const FOREIGN KEY (pp_idpolproduktu) REFERENCES tp_polprodukty(pp_idpolproduktu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT ppetapy FOREIGN KEY (sz_idetapu) REFERENCES tg_etapyzlecen(sz_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT pphotele FOREIGN KEY (ht_idhotelu) REFERENCES tg_hotelezlecen(ht_idhotelu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pp
    ADD CONSTRAINT ppprace FOREIGN KEY (pr_idpracy) REFERENCES tg_prace(pr_idpracy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_prace
    ADD CONSTRAINT pz_idplanu_ref FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT realizacjapzam FOREIGN KEY (tr_idtranssrc) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT skojlogc FOREIGN KEY (tel_skojlog) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY st_amortyzacja
    ADD CONSTRAINT st_amortyzacja_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY st_srodkitrwale
    ADD CONSTRAINT st_srodkitrwale_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY st_srodkitrwale
    ADD CONSTRAINT st_srodkitrwale_oddzialu_fkey FOREIGN KEY (fm_idoddzialu) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY st_zdarzeniast
    ADD CONSTRAINT st_zdarzeniast_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_kalkulacjeval
    ADD CONSTRAINT swiadectwocc FOREIGN KEY (sw_idswiadectwa) REFERENCES tg_swiadectwa(sw_idswiadectwa) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_pliki
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES tb_tag(tag_id);


--
--

ALTER TABLE ONLY tb_api_actiongroup_access
    ADD CONSTRAINT tb_api_actiongroup_access_aga_apg_id_id_fkey FOREIGN KEY (aga_apg_id) REFERENCES tb_api_actiongroup(apg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_api_profile_access_action
    ADD CONSTRAINT tb_api_profile_access_action_apa_apc_id_fkey FOREIGN KEY (apa_apc_id) REFERENCES tb_api_profile(apc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_api_profile_access_actiongroup
    ADD CONSTRAINT tb_api_profile_access_actiongroup_apga_aga_id_fkey FOREIGN KEY (apga_aga_id) REFERENCES tb_api_actiongroup(apg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_api_profile_access_actiongroup
    ADD CONSTRAINT tb_api_profile_access_actiongroup_apga_apc_id_fkey FOREIGN KEY (apga_apc_id) REFERENCES tb_api_profile(apc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_api_profile
    ADD CONSTRAINT tb_api_profile_apc_k_idklienta_fkey FOREIGN KEY (apc_k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_api_profile
    ADD CONSTRAINT tb_api_profile_apc_p_idpracownika_fkey FOREIGN KEY (apc_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_appcustomwindows
    ADD CONSTRAINT tb_appcustomwindows_acw_ownerid_fkey FOREIGN KEY (acw_ownerid) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_appcustomwindows
    ADD CONSTRAINT tb_appcustomwindows_acw_sourceid_fkey FOREIGN KEY (acw_sourceid) REFERENCES tb_appcustomwindows(acw_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_assemblies
    ADD CONSTRAINT tb_assemblies_asm_asc_id_fkey FOREIGN KEY (asm_asc_id) REFERENCES tb_assemblies_content(asc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_bankirel
    ADD CONSTRAINT tb_bankirel_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_biometricdata
    ADD CONSTRAINT tb_biometricdata_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chat_history
    ADD CONSTRAINT tb_chat_history_chh_chc_id_fkey FOREIGN KEY (chh_chc_id) REFERENCES tb_chat_conversation(chc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chat_history
    ADD CONSTRAINT tb_chat_history_chh_p_idpracownika_fkey FOREIGN KEY (chh_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chat_members
    ADD CONSTRAINT tb_chat_members_chm_chc_id_fkey FOREIGN KEY (chm_chc_id) REFERENCES tb_chat_conversation(chc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chat_members
    ADD CONSTRAINT tb_chat_members_chm_p_idpracownika_fkey FOREIGN KEY (chm_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chatfriends
    ADD CONSTRAINT tb_chatfriends_ctu_id_fkey FOREIGN KEY (ctu_id) REFERENCES tb_chatuser(ctu_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chatgroupmembers
    ADD CONSTRAINT tb_chatgroupmembers_ctg_id_fkey FOREIGN KEY (ctg_id) REFERENCES tb_chatgroup(ctg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chatgroupmembers
    ADD CONSTRAINT tb_chatgroupmembers_ctu_id_fkey FOREIGN KEY (ctu_id) REFERENCES tb_chatuser(ctu_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_chatuser
    ADD CONSTRAINT tb_chatuser_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_cyklicznosc
    ADD CONSTRAINT tb_cyklicznosc_zd_idzdarzenia_fkey FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_cyklwyjatki
    ADD CONSTRAINT tb_cyklwyjatki_ck_idcyklu_fkey FOREIGN KEY (ck_idcyklu) REFERENCES tb_cyklicznosc(ck_idcyklu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_cyklwyjatki
    ADD CONSTRAINT tb_cyklwyjatki_cw_newidzdarzenia_fkey FOREIGN KEY (cw_newidzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_etapprojektu
    ADD CONSTRAINT tb_etapprojektu_pt_to_fkey FOREIGN KEY (pt_to) REFERENCES tb_etapprojektu(pt_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_etapprojektu
    ADD CONSTRAINT tb_etapprojektu_szl_idstatusu_fkey FOREIGN KEY (szl_idstatusu) REFERENCES ts_statuszlecenia(szl_idstatusu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_filtrelem
    ADD CONSTRAINT tb_filtrelem_fh_idfiltru_fkey FOREIGN KEY (fh_idfiltru) REFERENCES tb_filtrhead(fh_idfiltru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_filtrelem
    ADD CONSTRAINT tb_filtrelem_mv_idvalue_fkey FOREIGN KEY (mv_idvalue) REFERENCES ts_multivalues(mv_idvalue) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_listprzewozowyzbior
    ADD CONSTRAINT tb_firma_fm_idcentrali FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_flowchart_connections
    ADD CONSTRAINT tb_flowchart_connections_fce_id_from_fkey FOREIGN KEY (fce_id_from) REFERENCES tb_flowchart_elements(fce_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_flowchart_connections
    ADD CONSTRAINT tb_flowchart_connections_fce_id_to_fkey FOREIGN KEY (fce_id_to) REFERENCES tb_flowchart_elements(fce_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_flowchart_connections
    ADD CONSTRAINT tb_flowchart_connections_fct_id_fkey FOREIGN KEY (fct_id) REFERENCES tb_flowchart(fct_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_flowchart_elements
    ADD CONSTRAINT tb_flowchart_elements_fct_id_fkey FOREIGN KEY (fct_id) REFERENCES tb_flowchart(fct_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ftpuser
    ADD CONSTRAINT tb_ftpuser_fth_idhost_fkey FOREIGN KEY (fth_idhost) REFERENCES tb_ftphost(fth_idhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ftpuser
    ADD CONSTRAINT tb_ftpuser_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_funkcjepracownikow
    ADD CONSTRAINT tb_funkcjepracownikow_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_googleaccounts
    ADD CONSTRAINT tb_googleaccounts_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_googlesynchronize
    ADD CONSTRAINT tb_googlesynchronize_gga_id_fkey FOREIGN KEY (gga_id) REFERENCES tb_googleaccounts(gga_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_googlesynchronize_remove
    ADD CONSTRAINT tb_googlesynchronize_remove_gga_id_fkey FOREIGN KEY (gga_id) REFERENCES tb_googleaccounts(gga_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_googlesynchronize
    ADD CONSTRAINT tb_googlesynchronize_zd_idzdarzenia_fkey FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kalendarzelem
    ADD CONSTRAINT tb_kalendarzelem_kalh_idkalendarzahead_fkey FOREIGN KEY (kalh_idkalendarzahead) REFERENCES tb_kalendarzhead(kalh_idkalendarzahead) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kalendarzelem
    ADD CONSTRAINT tb_kalendarzelem_zm_idzmiany_fkey FOREIGN KEY (zm_idzmiany) REFERENCES tr_zmiany(zm_idzmiany) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_kalendarzhead
    ADD CONSTRAINT tb_kalendarzhead_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kliencizdarzenia
    ADD CONSTRAINT tb_kliencizdarzenia_k_idklienta FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_kliencizdarzenia
    ADD CONSTRAINT tb_kliencizdarzenia_zd_idzdarzenia FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_pwep_idpunktu_fkey FOREIGN KEY (pwep_idpunktu) REFERENCES ts_punktywydaniaeprzesylek(pwep_idpunktu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_ros_idrodzaju FOREIGN KEY (ros_idrodzaju) REFERENCES ts_rodzajeodsetek(ros_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_sch_idschematu_fkey FOREIGN KEY (sch_idschematu) REFERENCES ts_schematy_wymiany(sch_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_st_idstatusu_fkey FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_klient
    ADD CONSTRAINT tb_klient_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_ludzieklienta
    ADD CONSTRAINT tb_ludzieklienta_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_dz_iddzialu_fkey FOREIGN KEY (mac_dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_dz_iddzialu_synch_fkey FOREIGN KEY (mac_dz_iddzialu_synch) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_p_idpracownika_fkey FOREIGN KEY (mac_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_p_idpracownika_synch_fkey FOREIGN KEY (mac_p_idpracownika_synch) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_rol_id_fkey FOREIGN KEY (mac_rol_id) REFERENCES tb_role(rol_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_rol_id_synch_fkey FOREIGN KEY (mac_rol_id_synch) REFERENCES tb_role(rol_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_tsz_idtypu_fkey FOREIGN KEY (mac_tsz_idtypu) REFERENCES ts_typzdarzenia(tsz_idtypu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_zdi_id_spr_fkey FOREIGN KEY (mac_zdi_id_spr) REFERENCES tb_zdarzeniainfo(zdi_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_account
    ADD CONSTRAINT tb_mail_account_mac_zdp_id_fkey FOREIGN KEY (mac_zdp_id) REFERENCES tb_zdarzeniapt(zdp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_data_addresses
    ADD CONSTRAINT tb_mail_data_addresses_mal_mail_id_fkey FOREIGN KEY (mal_mail_id) REFERENCES tb_mail_data(mail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_data_attachments_data
    ADD CONSTRAINT tb_mail_data_attachments_data_mad_mat_id_fkey FOREIGN KEY (mad_mat_id) REFERENCES tb_mail_data_attachments(mat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_data_attachments
    ADD CONSTRAINT tb_mail_data_attachments_mat_mail_id_fkey FOREIGN KEY (mat_mail_id) REFERENCES tb_mail_data(mail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_mail_data
    ADD CONSTRAINT tb_mail_data_mail_mac_id_fkey FOREIGN KEY (mail_mac_id) REFERENCES tb_mail_account(mac_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_mail_processed
    ADD CONSTRAINT tb_mail_processed_mpr_mac_id_fkey FOREIGN KEY (mpr_mac_id) REFERENCES tb_mail_account(mac_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_mail_processed
    ADD CONSTRAINT tb_mail_processed_mpr_mail_id_fkey FOREIGN KEY (mpr_mail_id) REFERENCES tb_mail_data(mail_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_mail_templates
    ADD CONSTRAINT tb_mail_templates_mtpl_mail_id_fkey FOREIGN KEY (mtpl_mail_id) REFERENCES tb_mail_data(mail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_masspayment
    ADD CONSTRAINT tb_masspayment_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_packages_arrangement
    ADD CONSTRAINT tb_packages_arrangement_paa_lt_id_fkey FOREIGN KEY (paa_lt_id) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_packages_arrangement
    ADD CONSTRAINT tb_packages_arrangement_paa_pac_id_fkey FOREIGN KEY (paa_pac_id) REFERENCES tb_packages_containers(pac_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_packages_arrangement
    ADD CONSTRAINT tb_packages_arrangement_paa_ps_id_fkey FOREIGN KEY (paa_ps_id) REFERENCES tg_paczkaspedycyjna(ps_idpaczki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_packages_containers
    ADD CONSTRAINT tb_packages_containers_pac_lt_id_fkey FOREIGN KEY (pac_lt_id) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_plugins
    ADD CONSTRAINT tb_plugins_plu_asm_id_fkey FOREIGN KEY (plu_asm_id) REFERENCES tb_assemblies(asm_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_plugins_references
    ADD CONSTRAINT tb_plugins_references_pas_asm_id_fkey FOREIGN KEY (pas_asm_id) REFERENCES tb_assemblies(asm_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_plugins_references
    ADD CONSTRAINT tb_plugins_references_pas_plu_id_fkey FOREIGN KEY (pas_plu_id) REFERENCES tb_plugins(plu_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia_flags
    ADD CONSTRAINT tb_pracownicy_fk FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) MATCH FULL;


--
--

ALTER TABLE ONLY tb_pracownicyzdarzenia
    ADD CONSTRAINT tb_pracownicy_p_idpracownika FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_brygadaelem
    ADD CONSTRAINT tb_pracownicy_p_idpracownika FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicy
    ADD CONSTRAINT tb_pracownicy_p_przekazaniekomu_fkey FOREIGN KEY (p_przekazaniekomu) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_pracownicyzdarzenia
    ADD CONSTRAINT tb_pracownicy_zd_idzdarzenia FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicyzlecenia
    ADD CONSTRAINT tb_pracownicyzlecenia_dz_iddzialu_fkey FOREIGN KEY (dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicyzlecenia
    ADD CONSTRAINT tb_pracownicyzlecenia_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_pracownicyzlecenia
    ADD CONSTRAINT tb_pracownicyzlecenia_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_progispedycji
    ADD CONSTRAINT tb_progispedycji_sp_idspedytora_fkey FOREIGN KEY (sp_idspedytora) REFERENCES ts_spedycje(sp_idspedytora) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_progispedycji
    ADD CONSTRAINT tb_progispedycji_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_przechowkl
    ADD CONSTRAINT tb_przechowkl_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_przechowkl
    ADD CONSTRAINT tb_przechowkl_sp_idprzechow_fkey FOREIGN KEY (sp_idprzechow) REFERENCES ts_sposobprzechowania(sp_idprzechow) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_raportgui
    ADD CONSTRAINT tb_raportgui_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_raportgui
    ADD CONSTRAINT tb_raportgui_p_idpracownikafor_fkey FOREIGN KEY (p_idpracownikafor) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rcp_agregacja
    ADD CONSTRAINT tb_rcp_agregacja_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_rcp_wydarzenia
    ADD CONSTRAINT tb_rcp_wydarzenia_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_ll_idrelacji_dst_fkey FOREIGN KEY (ll_idrelacji_dst) REFERENCES tb_relacjaprojektu(ll_idrelacji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_ll_idrelacji_src_fkey FOREIGN KEY (ll_idrelacji_src) REFERENCES tb_relacjaprojektu(ll_idrelacji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_plt_id_fkey FOREIGN KEY (plt_id) REFERENCES tb_tplprojektu(plt_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_pt_idetapu_dst_fkey FOREIGN KEY (pt_idetapu_dst) REFERENCES tb_etapprojektu(pt_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_pt_idetapu_src_fkey FOREIGN KEY (pt_idetapu_src) REFERENCES tb_etapprojektu(pt_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_pt_idetapu_to_fkey FOREIGN KEY (pt_idetapu_to) REFERENCES tb_etapprojektu(pt_idetapu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_zd_idzdarzenia_dst_fkey FOREIGN KEY (zd_idzdarzenia_dst) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_relacjaprojektu
    ADD CONSTRAINT tb_relacjaprojektu_zd_idzdarzenia_src_fkey FOREIGN KEY (zd_idzdarzenia_src) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rguilists
    ADD CONSTRAINT tb_rguilists_rgui_id_fkey FOREIGN KEY (rgui_id) REFERENCES tb_raportgui(rgui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rguival
    ADD CONSTRAINT tb_rguival_rgui_id_fkey FOREIGN KEY (rgui_id) REFERENCES tb_raportgui(rgui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rolepdz
    ADD CONSTRAINT tb_rolepdz_dz_iddzialu_fkey FOREIGN KEY (dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rolepdz
    ADD CONSTRAINT tb_rolepdz_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_rolepdz
    ADD CONSTRAINT tb_rolepdz_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES tb_role(rol_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_schowektowarow
    ADD CONSTRAINT tb_schowektowarow_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_scriptfiles
    ADD CONSTRAINT tb_scriptfiles_scr_id_fkey FOREIGN KEY (scr_id) REFERENCES tb_scripts(scr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_settings
    ADD CONSTRAINT tb_settings_stt_sts_id_fkey FOREIGN KEY (stt_sts_id) REFERENCES tb_settings_storages(sts_id);


--
--

ALTER TABLE ONLY tb_signparams
    ADD CONSTRAINT tb_signparams_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_tag
    ADD CONSTRAINT tb_tag_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_telemarketing_telefony
    ADD CONSTRAINT tb_telemarketing_telefony_tlpr_kl_idklienta_fkey FOREIGN KEY (tlpr_kl_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_telemarketing_telefony
    ADD CONSTRAINT tb_telemarketing_telefony_tlpr_lk_idczklienta_fkey FOREIGN KEY (tlpr_lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_telemarketing_telefony
    ADD CONSTRAINT tb_telemarketing_telefony_tlpr_pra_idpracy_fkey FOREIGN KEY (tlpr_pra_idpracy) REFERENCES tg_praceall(pra_idpracy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_telemarketing_telefony
    ADD CONSTRAINT tb_telemarketing_telefony_tlpr_st_idstatusu_fkey FOREIGN KEY (tlpr_st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_plt_k_idklienta_fkey FOREIGN KEY (plt_k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_plt_p_idpracownika_fkey FOREIGN KEY (plt_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_plt_zd_typ_fkey FOREIGN KEY (plt_zd_typ) REFERENCES ts_typzdarzenia(tsz_idtypu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_plt_zdp_id_fkey FOREIGN KEY (plt_zdp_id) REFERENCES tb_zdarzeniapt(zdp_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_tplprojektu
    ADD CONSTRAINT tb_tplprojektu_ts_szablonzdarzenia FOREIGN KEY (plt_szd_idszablonu) REFERENCES ts_szablonzdarzenia(szd_idszablonu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_universalfiles
    ADD CONSTRAINT tb_universalfiles_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tb_tag(tag_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ustawieniadomprac
    ADD CONSTRAINT tb_ustawieniadomprac_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_ustawieniadomprac
    ADD CONSTRAINT tb_ustawieniadomprac_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_rl_idrozliczenia_fkey FOREIGN KEY (rl_idrozliczenia) REFERENCES kr_rozliczenia(rl_idrozliczenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_rr_idrozrachunku_fkey FOREIGN KEY (rr_idrozrachunku) REFERENCES kr_rozrachunki(rr_idrozrachunku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_rr_idrozrachunkuvat_fkey FOREIGN KEY (rr_idrozrachunkuvat) REFERENCES kr_rozrachunki(rr_idrozrachunku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_vatzal
    ADD CONSTRAINT tb_vatzal_vz_refid_fkey FOREIGN KEY (vz_refid) REFERENCES tb_vatzal(vz_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_caller_client_fkey FOREIGN KEY (vph_caller_client) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_caller_clientperson_fkey FOREIGN KEY (vph_caller_clientperson) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_caller_employee_fkey FOREIGN KEY (vph_caller_employee) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_event_fkey FOREIGN KEY (vph_event) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_status_fkey FOREIGN KEY (vph_status) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_transfer_client_fkey FOREIGN KEY (vph_transfer_client) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_transfer_clientperson_fkey FOREIGN KEY (vph_transfer_clientperson) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_transfer_employee_fkey FOREIGN KEY (vph_transfer_employee) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_user_employee_fkey FOREIGN KEY (vph_user_employee) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_vphone_history
    ADD CONSTRAINT tb_vphone_history_vph_work_fkey FOREIGN KEY (vph_work) REFERENCES tg_praceall(pra_idpracy) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_lk_idczkienta_fkey FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_p_wpisujacy_fkey FOREIGN KEY (p_wpisujacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_plt_id_fkey FOREIGN KEY (plt_id) REFERENCES tb_tplprojektu(plt_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia_priority
    ADD CONSTRAINT tb_zdarzenia_priority_zpr_zd_idzdarzenia_fkey FOREIGN KEY (zpr_zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zd_aktualnieu_fkey FOREIGN KEY (zd_aktualnieu) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zd_idparent_fkey FOREIGN KEY (zd_idparent) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zd_idrewizja_fkey FOREIGN KEY (zd_idrewizja) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zd_lt_idtransportu_fkey FOREIGN KEY (zd_lt_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zd_mail_id_fkey FOREIGN KEY (zd_mail_id) REFERENCES tb_mail_data(mail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia
    ADD CONSTRAINT tb_zdarzenia_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tb_zdarzeniaco
    ADD CONSTRAINT tb_zdarzeniaco_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzeniaco
    ADD CONSTRAINT tb_zdarzeniaco_zd_id_fkey FOREIGN KEY (zd_id) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzeniaetapzlecenia
    ADD CONSTRAINT tb_zdarzeniaetapzlecenia_szl_idstatusu_eps_fkey FOREIGN KEY (szl_idstatusu_eps) REFERENCES ts_statuszlecenia(szl_idstatusu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzeniaetapzlecenia
    ADD CONSTRAINT tb_zdarzeniaetapzlecenia_szl_idstatusu_ezl_fkey FOREIGN KEY (szl_idstatusu_ezl) REFERENCES ts_statuszlecenia(szl_idstatusu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzeniaptlist
    ADD CONSTRAINT tb_zdarzeniaptlist_zdp_id_fkey FOREIGN KEY (zdp_id) REFERENCES tb_zdarzeniapt(zdp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdpowiazania
    ADD CONSTRAINT tb_zdpowiazania_zd_idzdarzenia FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zlecenia_skojarzone
    ADD CONSTRAINT tb_zlecenia_skojarzone_zl_idzlecenia_a_fkey FOREIGN KEY (zl_idzlecenia_a) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zlecenia_skojarzone
    ADD CONSTRAINT tb_zlecenia_skojarzone_zl_idzlecenia_b_fkey FOREIGN KEY (zl_idzlecenia_b) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_defaultpdf
    ADD CONSTRAINT tc_defaultpdf_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_defaultpdf
    ADD CONSTRAINT tc_defaultpdf_pdf_idustawienia_fkey FOREIGN KEY (pdf_idustawienia) REFERENCES tc_ustawieniapdf(pdf_idustawienia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_defaultprints
    ADD CONSTRAINT tc_defaultprints_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_powiazaniastatusowlp
    ADD CONSTRAINT tc_powiazaniastatusowlp_sp_idspedytora_fkey FOREIGN KEY (sp_idspedytora) REFERENCES ts_spedycje(sp_idspedytora) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_powiazaniastatusowlp
    ADD CONSTRAINT tc_powiazaniastatusowlp_st_idstatusu_fkey FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_variantmap
    ADD CONSTRAINT tc_variantmap_pdf_idustawienia_fkey FOREIGN KEY (pdf_idustawienia) REFERENCES tc_ustawieniapdf(pdf_idustawienia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tc_variantmap
    ADD CONSTRAINT tc_variantmap_zpl_idetykiety_fkey FOREIGN KEY (zpl_idetykiety) REFERENCES tc_etykiety(zpl_idetykiety) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tf_klocekparams
    ADD CONSTRAINT tf_klocekparams_fk_idklocka_fkey FOREIGN KEY (fk_idklocka) REFERENCES tf_raportklocki(fk_idklocka) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tf_klocekparams
    ADD CONSTRAINT tf_klocekparams_fk_idklocka_in_fkey FOREIGN KEY (fk_idklocka_in) REFERENCES tf_raportklocki(fk_idklocka) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tf_klocekparams
    ADD CONSTRAINT tf_klocekparams_fr_idraportu_fkey FOREIGN KEY (fr_idraportu) REFERENCES tf_raport(fr_idraportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tf_klocekparams
    ADD CONSTRAINT tf_klocekparams_fr_idraportu_in_fkey FOREIGN KEY (fr_idraportu_in) REFERENCES tf_raport(fr_idraportu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tf_raportklocki
    ADD CONSTRAINT tf_raportklocki_fk_parent_fkey FOREIGN KEY (fk_parent) REFERENCES tf_raportklocki(fk_idklocka) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tf_raportklocki
    ADD CONSTRAINT tf_raportklocki_fr_idraportu_fkey FOREIGN KEY (fr_idraportu) REFERENCES tf_raport(fr_idraportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamelem
    ADD CONSTRAINT tg_abonamelem_ab_idabonamentu_fkey FOREIGN KEY (ab_idabonamentu) REFERENCES tg_abonamenty(ab_idabonamentu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamelem
    ADD CONSTRAINT tg_abonamelem_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamenty
    ADD CONSTRAINT tg_abonamenty_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_abonamenty
    ADD CONSTRAINT tg_abonamenty_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamenty
    ADD CONSTRAINT tg_abonamenty_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_abonamenty
    ADD CONSTRAINT tg_abonamenty_ra_idrodzaju_fkey FOREIGN KEY (ra_idrodzaju) REFERENCES ts_rodzajabonamentu(ra_idrodzaju) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_avizodostawy
    ADD CONSTRAINT tg_avizodostawy_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_avizodostawy
    ADD CONSTRAINT tg_avizodostawy_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_knr_idelemusrc_fkey FOREIGN KEY (knr_idelemusrc) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadusrc) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_pz_idplanusrc_fkey FOREIGN KEY (pz_idplanusrc) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_rc_idruchusrc_fkey FOREIGN KEY (rc_idruchusrc) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_tel_idelemsrc_fkey FOREIGN KEY (tel_idelemsrc) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_backorder
    ADD CONSTRAINT tg_backorder_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_bl_idpilota_fkey FOREIGN KEY (bl_idpilota) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_bl_pracrozagenta_fkey FOREIGN KEY (bl_pracrozagenta) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_bl_pracrozpilota_fkey FOREIGN KEY (bl_pracrozpilota) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_bl_pracwydajacy_fkey FOREIGN KEY (bl_pracwydajacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_tel_idelem FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_bilety
    ADD CONSTRAINT tg_bilety_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ceny
    ADD CONSTRAINT tg_ceny_p_idpracownika FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ceny
    ADD CONSTRAINT tg_ceny_tgc_idgrupy_fkey FOREIGN KEY (tgc_idgrupy) REFERENCES ts_grupycen(tgc_idgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ceny
    ADD CONSTRAINT tg_ceny_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_charklientdlatow
    ADD CONSTRAINT tg_charklientdlatow_ja_idjednostki FOREIGN KEY (ckdt_ja_idjednostki) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_charklientdlatow
    ADD CONSTRAINT tg_charklientdlatow_k_idklienta FOREIGN KEY (ckdt_k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_charklientdlatow
    ADD CONSTRAINT tg_charklientdlatow_ttw_idtowaru FOREIGN KEY (ckdt_ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawaelem
    ADD CONSTRAINT tg_dostawaelem_dw_iddostawy_fkey FOREIGN KEY (dw_iddostawy) REFERENCES tg_dostawy(dw_iddostawy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawaelem
    ADD CONSTRAINT tg_dostawaelem_pk_idpaczki_fkey FOREIGN KEY (pk_idpaczki) REFERENCES tg_packhead(pk_idpaczki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawaelem
    ADD CONSTRAINT tg_dostawaelem_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawarozdzial
    ADD CONSTRAINT tg_dostawarozdzial_tel_idelem_fz_fkey FOREIGN KEY (tel_idelem_fz) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawarozdzial
    ADD CONSTRAINT tg_dostawarozdzial_tel_idelem_pzam_fkey FOREIGN KEY (tel_idelem_pzam) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_dostawy
    ADD CONSTRAINT tg_dostawy_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_eo_idelementuprev FOREIGN KEY (eo_idelementuprev) REFERENCES tg_elementobiektu(eo_idelementu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_eo_idskladnikaobiekt FOREIGN KEY (eo_idskladnikaobiekt) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_ero_idelementu FOREIGN KEY (ero_idelementu) REFERENCES ts_elementyrodzajuobiektu(ero_idelementu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_rb_idrodzaju FOREIGN KEY (rb_idrodzaju) REFERENCES ts_rodzajeobiektow(rb_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_elementobiektu
    ADD CONSTRAINT tg_elementobiektu_zl_idzlecenia FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_grupytow
    ADD CONSTRAINT tg_grupytow_tgr_parent_fkey FOREIGN KEY (tgr_parent) REFERENCES tg_grupytow(tgr_idgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_grupywww
    ADD CONSTRAINT tg_grupywww_tgw_parent_fkey FOREIGN KEY (tgw_parent) REFERENCES tg_grupywww(tgw_idgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_hoteleelem
    ADD CONSTRAINT tg_hoteleelem_hs_idstruktury_fkey FOREIGN KEY (hs_idstruktury) REFERENCES ts_hotelestruktura(hs_idstruktury) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_hoteleelem
    ADD CONSTRAINT tg_hoteleelem_ht_idhotelu_fkey FOREIGN KEY (ht_idhotelu) REFERENCES tg_hotelezlecen(ht_idhotelu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetailclicks
    ADD CONSTRAINT tg_inwdetailclicks_ind_id_fkey FOREIGN KEY (ind_id) REFERENCES tg_inwdetails(ind_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetailclicks
    ADD CONSTRAINT tg_inwdetailclicks_ine_id_fkey FOREIGN KEY (ine_id) REFERENCES tg_inwelems(ine_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetailclicks
    ADD CONSTRAINT tg_inwdetailclicks_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_ine_id_fkey FOREIGN KEY (ine_id) REFERENCES tg_inwelems(ine_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_inwdetails
    ADD CONSTRAINT tg_inwdetails_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_iu_idjednostki FOREIGN KEY (iu_idjednostki) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_iu_idopakowania FOREIGN KEY (iu_idopakowania) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_p_idtworcy_fkey FOREIGN KEY (p_idtworcy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_pl_formaplat_fkey FOREIGN KEY (pl_formaplat) REFERENCES ts_formaplat(pl_formaplat) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwdupusty
    ADD CONSTRAINT tg_inwdupusty_szt_id_fkey FOREIGN KEY (szt_id) REFERENCES ts_typspzakup(szt_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwelems
    ADD CONSTRAINT tg_inwelems_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_inwelems
    ADD CONSTRAINT tg_inwelems_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_jednostkialt
    ADD CONSTRAINT tg_jednostkialt_tjn_idjednostkialt_fkey FOREIGN KEY (tjn_idjednostkialt) REFERENCES tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_jednostkialt
    ADD CONSTRAINT tg_jednostkialt_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_kartypremiowe
    ADD CONSTRAINT tg_kartypremiowe_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_kliencilogistyki
    ADD CONSTRAINT tg_kliencilogistyki_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kliencilogistyki
    ADD CONSTRAINT tg_kliencilogistyki_lt_idtransportu_fkey FOREIGN KEY (lt_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kompletyzlecenia
    ADD CONSTRAINT tg_kompletyzlecenia_tg_zlecenia FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpoelem
    ADD CONSTRAINT tg_kpoelem_kpo_idheadu_fkey FOREIGN KEY (kpo_idheadu) REFERENCES tg_kpohead(kpo_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpoelem
    ADD CONSTRAINT tg_kpoelem_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_fm_index_fkey FOREIGN KEY (fm_index) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_ko_idkodu_fkey FOREIGN KEY (ko_idkodu) REFERENCES ts_kodyodpadu(ko_idkodu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_kpo_idklienta1_fkey FOREIGN KEY (kpo_idklienta1) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_kpo_idklienta2_fkey FOREIGN KEY (kpo_idklienta2) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_kpo_idklienta3_fkey FOREIGN KEY (kpo_idklienta3) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_kpo_idklienta4_fkey FOREIGN KEY (kpo_idklienta4) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kpohead
    ADD CONSTRAINT tg_kpohead_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_kursdok
    ADD CONSTRAINT tg_kursdok_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kursdok
    ADD CONSTRAINT tg_kursdok_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_kursywalut
    ADD CONSTRAINT tg_kursywalut_tw_idtabeli_fkey FOREIGN KEY (tw_idtabeli) REFERENCES ts_tabelakursow(tw_idtabeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_kursywalut
    ADD CONSTRAINT tg_kursywalut_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_listprzewozowy
    ADD CONSTRAINT tg_listprzewozowy_lk_idczklienta_fkey FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_listprzewozowy
    ADD CONSTRAINT tg_listprzewozowy_lp_formaplatnosci_fkey FOREIGN KEY (lp_formaplatnosci) REFERENCES ts_formaplat(pl_formaplat) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_listprzewozowy
    ADD CONSTRAINT tg_listprzewozowy_lt_idtransportu_fkey FOREIGN KEY (lt_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_listprzewozowyzbior
    ADD CONSTRAINT tg_listprzewozowyzbior_fm_index_fkey FOREIGN KEY (fm_index) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_listprzewozowy
    ADD CONSTRAINT tg_listprzewozowyzbior_lpz_idzbioru FOREIGN KEY (lpz_idzbioru) REFERENCES tg_listprzewozowyzbior(lpz_idzbioru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_log
    ADD CONSTRAINT tg_log_lgex_id_fkey FOREIGN KEY (lgex_id) REFERENCES tg_logex(lgex_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_loghis
    ADD CONSTRAINT tg_loghis_lgh_idpracownika_fkey FOREIGN KEY (lgh_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_logkltrans
    ADD CONSTRAINT tg_logkltrans_kl_idklienta_fkey FOREIGN KEY (kl_idklientalog) REFERENCES tg_kliencilogistyki(kl_idklientalog) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_logkltrans
    ADD CONSTRAINT tg_logkltrans_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losy
    ADD CONSTRAINT tg_losy_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_losy
    ADD CONSTRAINT tg_losy_lr_idloterii_fkey FOREIGN KEY (lr_idloterii) REFERENCES tg_loteria(lr_idloterii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losyanaliza
    ADD CONSTRAINT tg_losyanaliza_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_losyanaliza
    ADD CONSTRAINT tg_losyanaliza_lr_idloterii_fkey FOREIGN KEY (lr_idloterii) REFERENCES tg_loteria(lr_idloterii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losyanaliza
    ADD CONSTRAINT tg_losyanaliza_ltw_idtowaru_fkey FOREIGN KEY (ltw_idtowaru) REFERENCES tg_towaryloterii(ltw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losyanaliza
    ADD CONSTRAINT tg_losyanaliza_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losyelem
    ADD CONSTRAINT tg_losyelem_lan_idanalizy_fkey FOREIGN KEY (lan_idanalizy) REFERENCES tg_losyanaliza(lan_idanalizy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_losyelem
    ADD CONSTRAINT tg_losyelem_los_idlosu_fkey FOREIGN KEY (los_idlosu) REFERENCES tg_losy(los_idlosu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_losyelem
    ADD CONSTRAINT tg_losyelem_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_loteria
    ADD CONSTRAINT tg_loteria_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_magazyny_fm_index FOREIGN KEY (fm_index) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_ob_foridobiektu_fkey FOREIGN KEY (ob_foridobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_p_foridpracownika_fkey FOREIGN KEY (p_foridpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_scr_bigsimulation_fkey FOREIGN KEY (scr_bigsimulation) REFERENCES tb_scripts(scr_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_tmg_idmagazynufortk_fkey FOREIGN KEY (tmg_idmagazynufortk) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_magazyny
    ADD CONSTRAINT tg_magazyny_zl_foridzlecenia_fkey FOREIGN KEY (zl_foridzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_naprawyzlecenia
    ADD CONSTRAINT tg_naprawyzlecenia_tg_zlecenia FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_brygadaelem
    ADD CONSTRAINT tg_obiekty_ob_idobiektu FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT tg_obiekty_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_obiekty
    ADD CONSTRAINT tg_obiekty_st_idstatusu_fkey FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_odsetki
    ADD CONSTRAINT tg_odsetki_ros_idrodzaju FOREIGN KEY (ros_idrodzaju) REFERENCES ts_rodzajeodsetek(ros_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_pk_idpaczki_fkey FOREIGN KEY (pk_idpaczki) REFERENCES tg_packhead(pk_idpaczki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_tel_idelem_fv FOREIGN KEY (tel_idelem_fv) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_tel_idelem_pzam FOREIGN KEY (tel_idelem_pzam) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_tel_idelem_zam_fkey FOREIGN KEY (tel_idelem_zam) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_packelem
    ADD CONSTRAINT tg_packelem_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_pk_idref FOREIGN KEY (pk_idref) REFERENCES tg_packhead(pk_idpaczki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_st_idstatusu FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_packhead
    ADD CONSTRAINT tg_packhead_tr_idtrans_fv FOREIGN KEY (tr_idtrans_fv) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_packinfo
    ADD CONSTRAINT tg_packinfo_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_paczkaspedycyjna
    ADD CONSTRAINT tg_paczkaspedycyjna_lt_idtransportu_fkey FOREIGN KEY (lt_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_paczkaspedycyjna
    ADD CONSTRAINT tg_paczkaspedycyjna_tps_idtypu_fkey FOREIGN KEY (tps_idtypu) REFERENCES ts_typpaczkispedycyjnej(tps_idtypu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_paczkiprzewozowe
    ADD CONSTRAINT tg_paczkiprzewozowe_lt_idtransportu_fkey FOREIGN KEY (lt_idtransportu) REFERENCES tg_listprzewozowy(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_partie_narzedzia
    ADD CONSTRAINT tg_partie_narzedzia_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_prt_idparent_rozm_fkey FOREIGN KEY (prt_idparent_rozm) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_prt_idref_fkey FOREIGN KEY (prt_idref) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_prt_jm1_fkey FOREIGN KEY (prt_jm1) REFERENCES tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_prt_jm2_fkey FOREIGN KEY (prt_jm2) REFERENCES tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_partie
    ADD CONSTRAINT tg_partie_zprt_id_fkey FOREIGN KEY (zprt_id) REFERENCES ts_znacznikprt(zprt_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partiehelper
    ADD CONSTRAINT tg_partiehelper_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partiehelper
    ADD CONSTRAINT tg_partiehelper_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_ptm_idparent_fkey FOREIGN KEY (ptm_idparent) REFERENCES tg_partietm(ptm_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_partietm
    ADD CONSTRAINT tg_partietm_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_idsrcelem FOREIGN KEY (tel_idsrcelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_planzlecenia_pz_idplanusrc FOREIGN KEY (pz_idplanusrc) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_pz_idref FOREIGN KEY (pz_idref) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_pz_idrewizja FOREIGN KEY (pz_idrewizja) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_pz_idroot FOREIGN KEY (pz_idroot) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_rmp_idsposobu FOREIGN KEY (pz_rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_sk_idstruktury_fkey FOREIGN KEY (sk_idstruktury) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_planzlecenia
    ADD CONSTRAINT tg_planzlecenia_zl_idzlecenia FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_podgrupytow
    ADD CONSTRAINT tg_podgrupytow_tpg_parent_fkey FOREIGN KEY (tpg_parent) REFERENCES tg_podgrupytow(tpg_idpodgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_powiazaniepaczek
    ADD CONSTRAINT tg_powiazaniepaczek_pk_idpaczki_fkey FOREIGN KEY (pk_idpaczki) REFERENCES tg_packhead(pk_idpaczki) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_powiazanieplanu
    ADD CONSTRAINT tg_powiazanieplanu_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_phe_ref_minus_fkey FOREIGN KEY (phe_ref_minus) REFERENCES tg_ppheadelem(phe_idheadelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_phe_ref_plus_fkey FOREIGN KEY (phe_ref_plus) REFERENCES tg_ppheadelem(phe_idheadelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_prt_idpartii_minus_fkey FOREIGN KEY (prt_idpartii_minus) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_prt_idpartii_plus_fkey FOREIGN KEY (prt_idpartii_plus) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_tel_idelem_minus_fkey FOREIGN KEY (tel_idelem_minus) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_tel_idelem_plus_fkey FOREIGN KEY (tel_idelem_plus) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppelem
    ADD CONSTRAINT tg_ppelem_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_pphead
    ADD CONSTRAINT tg_pphead_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_pphead
    ADD CONSTRAINT tg_pphead_ttw_idtowarundx_fkey FOREIGN KEY (ttw_idtowarundx) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_phe_ref_fkey FOREIGN KEY (phe_ref) REFERENCES tg_ppheadelem(phe_idheadelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_pph_idheadu_fkey FOREIGN KEY (pph_idheadu) REFERENCES tg_pphead(pph_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_prt_idpartiiplus_fkey FOREIGN KEY (prt_idpartiiplus) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_prt_idpartiiplus_nosppak_fkey FOREIGN KEY (prt_idpartiiplus_nosppak) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_prt_idpartiiplusnosspak_fromref_fkey FOREIGN KEY (prt_idpartiiplusnosspak_fromref) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_tel_idelemsrcskoj_fkey FOREIGN KEY (tel_idelemsrcskoj) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ppheadelem
    ADD CONSTRAINT tg_ppheadelem_ttw_idtowarundx_fkey FOREIGN KEY (ttw_idtowarundx) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_praceall
    ADD CONSTRAINT tg_praceall_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_praceall
    ADD CONSTRAINT tg_praceall_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_praceall
    ADD CONSTRAINT tg_praceall_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_praceall
    ADD CONSTRAINT tg_praceall_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_produkcja
    ADD CONSTRAINT tg_produkcja_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_produkcja
    ADD CONSTRAINT tg_produkcja_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_przejazdy
    ADD CONSTRAINT tg_przejazdy_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_punktykarty
    ADD CONSTRAINT tg_punktykarty_kr_idkarty_fkey FOREIGN KEY (kr_idkarty) REFERENCES tg_kartypremiowe(kr_idkarty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_punktykarty
    ADD CONSTRAINT tg_punktykarty_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjaplanuprod
    ADD CONSTRAINT tg_realizacjaplanuprod_nz_idnaprawy FOREIGN KEY (nz_idnaprawy) REFERENCES tg_naprawyzlecenia(nz_idnaprawy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjaplanuprod
    ADD CONSTRAINT tg_realizacjaplanuprod_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjaplanuprod
    ADD CONSTRAINT tg_realizacjaplanuprod_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_pe_idelemuzam FOREIGN KEY (pe_idelemuzam) REFERENCES tg_packelem(pe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_rm_idtominus_fkey FOREIGN KEY (rm_idtominus) REFERENCES tg_realizacjapzam(rm_idrealizacji) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_tel_idelemsrc_fkey FOREIGN KEY (tel_idelemsrc) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_tel_idpzam_fkey FOREIGN KEY (tel_idpzam) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_realizacjapzam
    ADD CONSTRAINT tg_realizacjapzam_tex_idpzam_fkey FOREIGN KEY (tex_idpzam) REFERENCES tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_delegacja FOREIGN KEY (lt_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_dokument FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_kartoteka FOREIGN KEY (kd_idkartoteki) REFERENCES ts_kartotekadelegacji(kd_idkartoteki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_klient FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_rozliczdelegacja
    ADD CONSTRAINT tg_rozliczdelegacja_waluta FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_rozmrodzajeelems
    ADD CONSTRAINT tg_rozmrodzajeelems_rmr_idrodzaju_fkey FOREIGN KEY (rmr_idrodzaju) REFERENCES tg_rozmrodzaje(rmr_idrodzaju) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozmsppak
    ADD CONSTRAINT tg_rozmsppak_rmp_idsposobu_ref_fkey FOREIGN KEY (rmp_idsposobu_ref) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_rozmsppak
    ADD CONSTRAINT tg_rozmsppak_rmr_idrodzaju_fkey FOREIGN KEY (rmr_idrodzaju) REFERENCES tg_rozmrodzaje(rmr_idrodzaju) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozmsppak
    ADD CONSTRAINT tg_rozmsppak_ttw_idtowaru_ndx_fkey FOREIGN KEY (ttw_idtowaru_ndx) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozmsppakelems
    ADD CONSTRAINT tg_rozmsppakelems_rme_idelemu_fkey FOREIGN KEY (rme_idelemu) REFERENCES tg_rozmrodzajeelems(rme_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozmsppakelems
    ADD CONSTRAINT tg_rozmsppakelems_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_rozmsppakelems
    ADD CONSTRAINT tg_rozmsppakelems_rmr_idrodzaju_fkey FOREIGN KEY (rmr_idrodzaju) REFERENCES tg_rozmrodzaje(rmr_idrodzaju) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_rozmsppakelems
    ADD CONSTRAINT tg_rozmsppakelems_ttw_idtowaru_pdx_fkey FOREIGN KEY (ttw_idtowaru_pdx) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_mrpp_idpalety_fkey FOREIGN KEY (mrpp_idpalety) REFERENCES tr_mrppalety(mrpp_idpalety) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_prt_idpartiiwz_fkey FOREIGN KEY (prt_idpartiiwz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_rc_ruchpz_fkey FOREIGN KEY (rc_ruchpz) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_ruchy_tex_idelem_fkey FOREIGN KEY (tex_idelem) REFERENCES tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_skladnikizestawu
    ADD CONSTRAINT tg_skladnikizestawu_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_skladnikizestawu
    ADD CONSTRAINT tg_skladnikizestawu_ttw_idtowarusrc_fkey FOREIGN KEY (ttw_idtowarusrc) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_stanyother
    ADD CONSTRAINT tg_stanyother_so_idwaluty_fkey FOREIGN KEY (so_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_stanytowmagazyn
    ADD CONSTRAINT tg_stanytowmagazyn_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_statusyhistoria
    ADD CONSTRAINT tg_statusyhistoria_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_statusyhistoria
    ADD CONSTRAINT tg_statusyhistoria_st_idstatusu_fkey FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_swiadectwa
    ADD CONSTRAINT tg_swiadectwa_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_swiadruchy
    ADD CONSTRAINT tg_swiadruchy_sw_idswiadectwa_fkey FOREIGN KEY (sw_idswiadectwa) REFERENCES tg_swiadectwa(sw_idswiadectwa) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_swiadruchy
    ADD CONSTRAINT tg_swiadruchy_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tg_technoelem_ct_idciagu_fkey FOREIGN KEY (ct_idciagu) REFERENCES tr_ciagtech(ct_idciagu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tg_technoelem_ct_idciagu_fkey FOREIGN KEY (ct_idciagu) REFERENCES tr_ciagtech(ct_idciagu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_tecontrol
    ADD CONSTRAINT tg_tecontrol_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_teex
    ADD CONSTRAINT tg_teex_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_teex
    ADD CONSTRAINT tg_teex_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_teex
    ADD CONSTRAINT tg_teex_tex_skojarzony_fkey FOREIGN KEY (tex_skojarzony) REFERENCES tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_teex
    ADD CONSTRAINT tg_teex_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_fm_idonlycentrali_fkey FOREIGN KEY (fm_idonlycentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_k_idonlyklienta_fkey FOREIGN KEY (k_idonlyklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_rk_idrodzajklientaonly_fkey FOREIGN KEY (rk_idrodzajklientaonly) REFERENCES ts_rodzajklienta(rk_idrodzajklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_rmr_idrodzaju_fkey FOREIGN KEY (rmr_idrodzaju) REFERENCES tg_rozmrodzaje(rmr_idrodzaju) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tg_jednostkialt_i FOREIGN KEY (ttw_ja_idjedninwentaryzacji) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tg_jednostkialt_s FOREIGN KEY (ttw_ja_idjednsprzedazy) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tg_jednostkialt_z FOREIGN KEY (ttw_ja_idjednzakupu) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tgr_idgrupy_fkey FOREIGN KEY (tgr_idgrupy) REFERENCES tg_grupytow(tgr_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tgw_idgrupy FOREIGN KEY (tgw_idgrupy) REFERENCES tg_grupywww(tgw_idgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_tmg_magazynprod_fkey FOREIGN KEY (tmg_magazynprod) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_ttw_idopakowania FOREIGN KEY (ttw_idopakowania) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_ttw_idopakowania2 FOREIGN KEY (ttw_idopakowania2) REFERENCES tg_jednostkialt(ja_idjednostki) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towaryzlecotwartego
    ADD CONSTRAINT tg_towary_ttw_idtowaru FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towary
    ADD CONSTRAINT tg_towary_ttw_idxref_fkey FOREIGN KEY (ttw_idxref) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towaryakcjim
    ADD CONSTRAINT tg_towaryakcjim_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towaryakcjim
    ADD CONSTRAINT tg_towaryakcjim_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towaryakcjimdet
    ADD CONSTRAINT tg_towaryakcjimdet_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towaryakcjimdet
    ADD CONSTRAINT tg_towaryakcjimdet_ta_idtowaru_fkey FOREIGN KEY (ta_idtowaru) REFERENCES tg_towaryakcjim(ta_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towaryloterii
    ADD CONSTRAINT tg_towaryloterii_lr_idloterii_fkey FOREIGN KEY (lr_idloterii) REFERENCES tg_loteria(lr_idloterii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_towaryloterii
    ADD CONSTRAINT tg_towaryloterii_tgr_idgrupy_fkey FOREIGN KEY (tgr_idgrupy) REFERENCES tg_grupytow(tgr_idgrupy) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towaryloterii
    ADD CONSTRAINT tg_towaryloterii_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towmag
    ADD CONSTRAINT tg_towmag_ttm_idxref_fkey FOREIGN KEY (ttm_idxref) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_towmag
    ADD CONSTRAINT tg_towmag_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_bk_idbankupln_fkey FOREIGN KEY (bk_idbankupln) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_bk_idbankuwal_fkey FOREIGN KEY (bk_idbankuwal) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_br_idrelacji_fkey FOREIGN KEY (br_idrelacji) REFERENCES tb_bankirel(br_idrelacji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_k_agentsp_fkey FOREIGN KEY (k_agentsp) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_mm_idmiejscactx_fkey FOREIGN KEY (mm_idmiejscactx) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_p_zamykajacy_fkey FOREIGN KEY (p_zamykajacy) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_przechowanie FOREIGN KEY (sp_idprzechow) REFERENCES ts_sposobprzechowania(sp_idprzechow) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_pwep_idpunktu_fkey FOREIGN KEY (pwep_idpunktu) REFERENCES ts_punktywydaniaeprzesylek(pwep_idpunktu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_spedycje FOREIGN KEY (sp_idspedytora) REFERENCES ts_spedycje(sp_idspedytora) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_szt_id_fkey FOREIGN KEY (szt_id) REFERENCES ts_typspzakup(szt_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tg_transakcje_tr_skojzam_fkey FOREIGN KEY (tr_skojzam) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_idakcji_c FOREIGN KEY (a_idakcji) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_opk_const FOREIGN KEY (opk_idosrodka) REFERENCES ts_osrodkipk(opk_idosrodka) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_rmp_idsposobu_fkey FOREIGN KEY (rmp_idsposobu) REFERENCES tg_rozmsppak(rmp_idsposobu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_ruchy
    ADD CONSTRAINT tg_transelem_tel_idelem FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tg_transelem_tel_idelemsrc FOREIGN KEY (tel_idelemsrc) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_tel_skojzamtex_fkey FOREIGN KEY (tel_skojzamtex) REFERENCES tg_teex(tex_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_tel_walutads_fkey FOREIGN KEY (tel_walutads) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_tel_walutato_fkey FOREIGN KEY (tel_walutato) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transelem
    ADD CONSTRAINT tg_transelem_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_fm_index_fkey FOREIGN KEY (fm_index) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_lt_kosztnagwal_fkey FOREIGN KEY (lt_kosztnagwal) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_lt_miejscedostawy_fkey FOREIGN KEY (lt_miejscedostawy) REFERENCES tg_kliencilogistyki(kl_idklientalog) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_lt_miejscezaladunku_fkey FOREIGN KEY (lt_miejscezaladunku) REFERENCES tg_kliencilogistyki(kl_idklientalog) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_lt_obprzyczepa_fkey FOREIGN KEY (lt_obprzyczepa) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_lt_zlecajacy_fkey FOREIGN KEY (lt_zlecajacy) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_transport
    ADD CONSTRAINT tg_transport_wt_idwymagania_fkey FOREIGN KEY (wt_idwymagania) REFERENCES ts_wymaganiataboru(wt_idwymagania) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_treemembers
    ADD CONSTRAINT tg_treemembers_te_idelemu_f_fkey FOREIGN KEY (te_idelemu_f) REFERENCES tg_trees(te_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_treemembers
    ADD CONSTRAINT tg_treemembers_te_idelemu_s_fkey FOREIGN KEY (te_idelemu_s) REFERENCES tg_trees(te_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_treemembers
    ADD CONSTRAINT tg_treemembers_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_trees
    ADD CONSTRAINT tg_trees_te_parent_fkey FOREIGN KEY (te_parent) REFERENCES tg_trees(te_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_trees
    ADD CONSTRAINT tg_trees_trr_iddrzewa_fkey FOREIGN KEY (trr_iddrzewa) REFERENCES ts_drzewa(trr_iddrzewa) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_udzielonerabaty
    ADD CONSTRAINT tg_udzielonerabaty_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_vatykraje
    ADD CONSTRAINT tg_vatykraje_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_vatykraje
    ADD CONSTRAINT tg_vatykraje_ttv_idvatu_fkey FOREIGN KEY (ttv_idvatu) REFERENCES tg_vaty(ttv_idvatu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_vatytowarow
    ADD CONSTRAINT tg_vatytowarow_pw_idpowiatu_fkey FOREIGN KEY (pw_idpowiatu) REFERENCES ts_powiaty(pw_idpowiatu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_vatytowarow
    ADD CONSTRAINT tg_vatytowarow_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_vatytowarow
    ADD CONSTRAINT tg_vatytowarow_vk_idvatkraj_fkey FOREIGN KEY (vk_idvatkraj) REFERENCES tg_vatykraje(vk_idvatkraj) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wmsmm
    ADD CONSTRAINT tg_wmsmm_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wmsmm
    ADD CONSTRAINT tg_wmsmm_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmm
    ADD CONSTRAINT tg_wmsmm_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wmsmmruch
    ADD CONSTRAINT tg_wmsmmruch_wmm_idelem_fkey FOREIGN KEY (wmm_idelem) REFERENCES tg_wmsmm(wmm_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wolnenumery
    ADD CONSTRAINT tg_wolnenumery_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wskrez
    ADD CONSTRAINT tg_wskrez_rc_idruchupz_fkey FOREIGN KEY (rc_idruchupz) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_wskrez
    ADD CONSTRAINT tg_wskrez_tel_idelem_inw_fkey FOREIGN KEY (tel_idelem_inw) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_wsktkelem
    ADD CONSTRAINT tg_wsktkelem_rc_idruchu_fkey FOREIGN KEY (rc_idruchu) REFERENCES tg_ruchy(rc_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wsktkelem
    ADD CONSTRAINT tg_wsktkelem_tk_idelem_fkey FOREIGN KEY (tk_idelem) REFERENCES tg_tkelem(tk_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wynagrodzenia
    ADD CONSTRAINT tg_wynagrodzenia_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wynagrodzenia
    ADD CONSTRAINT tg_wynagrodzenia_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_wynagrodzeniadok
    ADD CONSTRAINT tg_wynagrodzeniadok_wg_idwynagrodzenia_fkey FOREIGN KEY (wg_idwynagrodzenia) REFERENCES tg_wynagrodzenia(wg_idwynagrodzenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_tel_skojzestaw_fkey FOREIGN KEY (tel_skojzestaw) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_tmg_idmagazynu FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zamilosci
    ADD CONSTRAINT tg_zamilosci_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_dz_iddzialu_fkey FOREIGN KEY (dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_lk_idczklienta_fkey FOREIGN KEY (lk_idczklienta) REFERENCES tb_ludzieklienta(lk_idczklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_st_idstatusu_fkey FOREIGN KEY (st_idstatusu) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_zl_idref FOREIGN KEY (zl_idref) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zlecenia
    ADD CONSTRAINT tg_zlecenia_zl_idtransportu FOREIGN KEY (zl_idtransportu) REFERENCES tg_transport(lt_idtransportu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tg_towaryzlecotwartego
    ADD CONSTRAINT tg_zlecenia_zl_idzlecenia FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianacenypz
    ADD CONSTRAINT tg_zmianacenypz_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianacenypz
    ADD CONSTRAINT tg_zmianacenypz_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianycenzakupu
    ADD CONSTRAINT tg_zmianycenzakupu_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianycenzakupu
    ADD CONSTRAINT tg_zmianycenzakupu_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianycenzakupu
    ADD CONSTRAINT tg_zmianycenzakupu_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tg_zmianycenzakupu
    ADD CONSTRAINT tg_zmianycenzakupu_zcz_waluta_fkey FOREIGN KEY (zcz_waluta) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_polprodukty
    ADD CONSTRAINT tjn_constraint FOREIGN KEY (tjn_idjedn) REFERENCES tg_jednostki(tjn_idjedn) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tl_tmptowary
    ADD CONSTRAINT tl_tmptowary_tel_idelem_fkey FOREIGN KEY (tel_idelem) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tl_tmptowary
    ADD CONSTRAINT tl_tmptowary_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tl_tmptowarydel
    ADD CONSTRAINT tl_tmptowarydel_tr_idtrans_fkey FOREIGN KEY (tr_idtrans) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_customcolvariables
    ADD CONSTRAINT tm_customcolvariables_cc_colid_fkey FOREIGN KEY (cc_colid) REFERENCES tm_customcols(cc_colid) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_dropshtowarmap
    ADD CONSTRAINT tm_dropshtowarmap_fm_idcentralisrc_fkey FOREIGN KEY (fm_idcentralisrc) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_dropshtowarmap
    ADD CONSTRAINT tm_dropshtowarmap_k_idklientadst_fkey FOREIGN KEY (k_idklientadst) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_dropshtowarmap
    ADD CONSTRAINT tm_dropshtowarmap_ttw_idtowarudst_fkey FOREIGN KEY (ttw_idtowarudst) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tm_dropshtowarmap
    ADD CONSTRAINT tm_dropshtowarmap_ttw_idtowarusrc_fkey FOREIGN KEY (ttw_idtowarusrc) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tp_kkwrecrozchodu
    ADD CONSTRAINT tmg_idmagazynu_const FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_mozliwestanowiska
    ADD CONSTRAINT tp_mozliwestanowiska_obiekt FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_planonkkw
    ADD CONSTRAINT tp_planonkkw_obiekt FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tp_ruchy_epdst FOREIGN KEY (kwr_etapdst) REFERENCES tp_kkwelem(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tp_ruchy_epsrc FOREIGN KEY (kwr_etapsrc) REFERENCES tp_kkwelem(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tp_ruchy_kwhdest FOREIGN KEY (kwh_idheadudst) REFERENCES tp_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_ruchy
    ADD CONSTRAINT tp_ruchy_tedst FOREIGN KEY (tel_idelemdst) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_wypal
    ADD CONSTRAINT tp_wypal_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tp_kkwelem(kwe_idelemu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tp_wypal
    ADD CONSTRAINT tp_wypal_kwp_idplanu_fkey FOREIGN KEY (kwp_idplanu) REFERENCES tp_kkwplan(kwp_idplanu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tp_wypal
    ADD CONSTRAINT tp_wypal_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tp_wypal
    ADD CONSTRAINT tp_wypal_pp_idpolproduktu_fkey FOREIGN KEY (pp_idpolproduktu) REFERENCES tp_polprodukty(pp_idpolproduktu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_dmag_idparent_fkey FOREIGN KEY (dmag_idparent) REFERENCES tr_dyspozycjamag(dmag_iddyspozycji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_knr_idelemu_fkey FOREIGN KEY (knr_idelemu) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_knw_idelemu_koop_fkey FOREIGN KEY (knw_idelemu_koop) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_mrpp_idpalety_fkey FOREIGN KEY (mrpp_idpalety) REFERENCES tr_mrppalety(mrpp_idpalety) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_prt_idpartiipz_fkey FOREIGN KEY (prt_idpartiipz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_prt_idpartiiwz_fkey FOREIGN KEY (prt_idpartiiwz) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_dyspozycjamag
    ADD CONSTRAINT tr_dyspozycjamag_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_harmonogram
    ADD CONSTRAINT tr_harmonogram_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_harmonogram
    ADD CONSTRAINT tr_harmonogram_obiekt FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_harmonogram
    ADD CONSTRAINT tr_harmonogram_w_idwydzialu_fkey FOREIGN KEY (w_idwydzialu) REFERENCES tp_wydzialy(w_idwydzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_kwh_standomyslne_fkey FOREIGN KEY (kwh_standomyslne) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_p_utworzyl_fkey FOREIGN KEY (p_utworzyl) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_th_idkalkulacji FOREIGN KEY (th_idkalkulacji) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_tmg_idmagazynu FOREIGN KEY (tmg_idmagazynu_def) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_ttw_idxref_fkey FOREIGN KEY (ttw_idxref) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwhead
    ADD CONSTRAINT tr_kkwhead_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwheadrozm
    ADD CONSTRAINT tr_kkwheadrozm_kkwhead_fkey FOREIGN KEY (kwhr_kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwheadrozm
    ADD CONSTRAINT tr_kkwheadrozm_pz_idplanu FOREIGN KEY (kwhr_pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_spinaczoperacji
    ADD CONSTRAINT tr_kkwnod_kwe_idelemudef FOREIGN KEY (kwe_idelemudef) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_kwe_idkooperanta FOREIGN KEY (kwe_idkooperanta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_top_idoperacji_fkey FOREIGN KEY (top_idoperacji) REFERENCES tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnod
    ADD CONSTRAINT tr_kkwnod_tr_spinaczoperacji FOREIGN KEY (spo_idspinacza) REFERENCES tr_spinaczoperacji(spo_idspinacza) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnodplan
    ADD CONSTRAINT tr_kkwnodplan_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodplan
    ADD CONSTRAINT tr_kkwnodplan_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodplan
    ADD CONSTRAINT tr_kkwnodplan_obiekt FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnodprevnext
    ADD CONSTRAINT tr_kkwnodprevnext_kwe_idnext_fkey FOREIGN KEY (kwe_idnext) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodprevnext
    ADD CONSTRAINT tr_kkwnodprevnext_kwe_idprev_fkey FOREIGN KEY (kwe_idprev) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodprevnext
    ADD CONSTRAINT tr_kkwnodprevnext_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodprevnext
    ADD CONSTRAINT tr_kkwnodprevnext_thpn_idelem_fkey FOREIGN KEY (thpn_idelem) REFERENCES tr_technoprevnext(thpn_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_klient_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_knw_kwhr_idelemu FOREIGN KEY (knw_kwhr_idelemu) REFERENCES tr_kkwheadrozm(kwhr_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_mrpp_idpalety_fkey FOREIGN KEY (mrpp_idpalety_podpieta) REFERENCES tr_mrppalety(mrpp_idpalety) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_kkwnodwyk
    ADD CONSTRAINT tr_kkwnodwyk_obiekt_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnodwykdet
    ADD CONSTRAINT tr_kkwnodwykdet_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwykdet
    ADD CONSTRAINT tr_kkwnodwykdet_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwykdet
    ADD CONSTRAINT tr_kkwnodwykdet_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwykdet
    ADD CONSTRAINT tr_kkwnodwykdet_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kkwnodwykdetkooperacja
    ADD CONSTRAINT tr_kkwnodwykdetkooperacja_nodwyk_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_kkwnodwykdetkooperacja
    ADD CONSTRAINT tr_kkwnodwykdetkooperacja_pracownik_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kubelki
    ADD CONSTRAINT tr_kubelki_obiekt_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kubelki
    ADD CONSTRAINT tr_kubelki_zm_idzmiany_fkey FOREIGN KEY (zm_idzmiany) REFERENCES tr_zmiany(zm_idzmiany) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kubelkisymulacyjne
    ADD CONSTRAINT tr_kubelkisymulacyjne_rb_idrodzaju_fkey FOREIGN KEY (rb_idrodzaju) REFERENCES ts_rodzajeobiektow(rb_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_kubelkisymulacyjne
    ADD CONSTRAINT tr_kubelkisymulacyjne_rk_idrozmiaru_fkey FOREIGN KEY (rk_idrozmiaru) REFERENCES ts_rozmiarykubelkow(rk_idrozmiaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_kuchy_knw_idelemusrc_fkey FOREIGN KEY (knw_idelemusrc) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_matrycaumiejetnosci
    ADD CONSTRAINT tr_matrycaumiejetnosci_mau_p_idpracownika_fkey FOREIGN KEY (mau_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_matrycaumiejetnosci
    ADD CONSTRAINT tr_matrycaumiejetnosci_mau_top_idoperacji_fkey FOREIGN KEY (mau_top_idoperacji) REFERENCES tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_k_idklienta_fkey FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_mm_idmiejsca_fkey FOREIGN KEY (mm_idmiejsca) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_mrppalety
    ADD CONSTRAINT tr_mrppalety_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_knr_idelemu_fkey FOREIGN KEY (knr_idelemu) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_prt_idpartii_fkey FOREIGN KEY (prt_idpartii) REFERENCES tg_partie(prt_idpartii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_tel_idelem_odlozenie_fkey FOREIGN KEY (tel_idelem_odlozenie) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_tel_idelem_pobranie_fkey FOREIGN KEY (tel_idelem_pobranie) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_narzedzie_ruch
    ADD CONSTRAINT tr_narzedzie_ruch_zl_idzlecenia_fkey FOREIGN KEY (zl_idzlecenia) REFERENCES tg_zlecenia(zl_idzlecenia) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_narzedzie_wyk
    ADD CONSTRAINT tr_narzedzie_wyk_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_narzedzie_wyk
    ADD CONSTRAINT tr_narzedzie_wyk_nrr_idruchu_fkey FOREIGN KEY (nrr_idruchu) REFERENCES tr_narzedzie_ruch(nrr_idruchu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrecrozmiarowka
    ADD CONSTRAINT tr_nodrec_knr_idelemu FOREIGN KEY (knr_idelemu) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_knr_idparent FOREIGN KEY (knr_idparent) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_trr_idelemu_fkey FOREIGN KEY (trr_idelemu) REFERENCES tr_rrozchodu(trr_idelemu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_ttm_idtowmag_fkey FOREIGN KEY (ttm_idtowmag) REFERENCES tg_towmag(ttm_idtowmag) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_nodrec
    ADD CONSTRAINT tr_nodrec_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_operacjetech
    ADD CONSTRAINT tr_operacjetech_idklienta FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_operacjetech
    ADD CONSTRAINT tr_operacjetech_idobiektu FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_przyczynaprzestojow
    ADD CONSTRAINT tr_operacjetech_top_idoperacji FOREIGN KEY (top_idoperacji) REFERENCES tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_operacjetech
    ADD CONSTRAINT tr_operacjetech_uslugazw FOREIGN KEY (ttw_uslugazw) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_es_idelem_def_fkey FOREIGN KEY (es_idelem_def) REFERENCES tg_elslownika(es_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_sl_idslownika_fkey FOREIGN KEY (sl_idslownika) REFERENCES tg_slownik(sl_idslownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_ttw_idnarzedzia1_fkey FOREIGN KEY (ttw_idnarzedzia1) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_definicje
    ADD CONSTRAINT tr_pomiary_definicje_ttw_idnarzedzia2_fkey FOREIGN KEY (ttw_idnarzedzia2) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_powiazania
    ADD CONSTRAINT tr_pomiary_powiazania_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_powiazania
    ADD CONSTRAINT tr_pomiary_powiazania_pd_iddefinicji_fkey FOREIGN KEY (pd_iddefinicji) REFERENCES tr_pomiary_definicje(pd_iddefinicji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_powiazania
    ADD CONSTRAINT tr_pomiary_powiazania_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_powiazania
    ADD CONSTRAINT tr_pomiary_powiazania_top_idoperacji_fkey FOREIGN KEY (top_idoperacji) REFERENCES tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_es_idelem_po_kj_fkey FOREIGN KEY (es_idelem_po_kj) REFERENCES tg_elslownika(es_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_es_idelem_przed_kj_fkey FOREIGN KEY (es_idelem_przed_kj) REFERENCES tg_elslownika(es_idelem) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_knw_idelemu_fkey FOREIGN KEY (knw_idelemu) REFERENCES tr_kkwnodwyk(knw_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_kwh_idheadu_fkey FOREIGN KEY (kwh_idheadu) REFERENCES tr_kkwhead(kwh_idheadu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_p_idpracownika_kj_fkey FOREIGN KEY (p_idpracownika_kj) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_pd_iddefinicji_fkey FOREIGN KEY (pd_iddefinicji) REFERENCES tr_pomiary_definicje(pd_iddefinicji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_sl_idslownika_fkey FOREIGN KEY (sl_idslownika) REFERENCES tg_slownik(sl_idslownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_ttw_idnarzedzia1_fkey FOREIGN KEY (ttw_idnarzedzia1) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_pomiary_wykonanie
    ADD CONSTRAINT tr_pomiary_wykonanie_ttw_idnarzedzia2_fkey FOREIGN KEY (ttw_idnarzedzia2) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_powiazanieplanprzychod
    ADD CONSTRAINT tr_powiazanieplanprzychod_knr_idelemu_fkey FOREIGN KEY (knr_idelemu) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_powiazanieplanprzychod
    ADD CONSTRAINT tr_powiazanieplanprzychod_pz_idplanu_fkey FOREIGN KEY (pz_idplanu) REFERENCES tg_planzlecenia(pz_idplanu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pracochlonnosc
    ADD CONSTRAINT tr_pracochlonnosc_rb_idrodzaju_fkey FOREIGN KEY (rb_idrodzaju) REFERENCES ts_rodzajeobiektow(rb_idrodzaju) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_pracochlonnosc
    ADD CONSTRAINT tr_pracochlonnosc_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pracownicykubelka
    ADD CONSTRAINT tr_pracownicykubelka_kb_idkubelka_fkey FOREIGN KEY (kb_idkubelka) REFERENCES tr_kubelki(kb_idkubelka) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_pracownicykubelka
    ADD CONSTRAINT tr_pracownicykubelka_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_ob_idobiektu_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_trr_idparent FOREIGN KEY (trr_idparent) REFERENCES tr_rrozchodu(trr_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_rrozchodu
    ADD CONSTRAINT tr_rrozchodu_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_dmag_iddyspozycji FOREIGN KEY (dmag_iddyspozycji) REFERENCES tr_dyspozycjamag(dmag_iddyspozycji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_knr_idelemudst_fkey FOREIGN KEY (knr_idelemudst) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_knr_idelemusrc_fkey FOREIGN KEY (knr_idelemusrc) REFERENCES tr_nodrec(knr_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_kwe_idelemudst_fkey FOREIGN KEY (kwe_idelemudst) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_kwe_idelemusrc_fkey FOREIGN KEY (kwe_idelemusrc) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_p_idpracownika_fkey FOREIGN KEY (p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_tel_idelemdst_fkey FOREIGN KEY (tel_idelemdst) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tr_ruchy
    ADD CONSTRAINT tr_ruchy_tel_idelemsrc_fkey FOREIGN KEY (tel_idelemsrc) REFERENCES tg_transelem(tel_idelem) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY tg_transakcje
    ADD CONSTRAINT tr_skojlogc FOREIGN KEY (tr_skojlog) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_spinaczoperacji
    ADD CONSTRAINT tr_spinaczoperacji_tg_obiekty FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_spinaczoperacji
    ADD CONSTRAINT tr_spinaczoperacji_tr_technologie FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_p_idpracownikazat_fkey FOREIGN KEY (p_idpracownikazat) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_mrpkalkulacje
    ADD CONSTRAINT tr_strukturakonstrukcyjna_sk_idstrukkalksrc FOREIGN KEY (kalk_sk_idstruktury) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_sk_idstrukkalksrc FOREIGN KEY (sk_idstrukkalksrc) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_sk_idzrodla_fkey FOREIGN KEY (sk_idzrodla) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_ttw_idmaterialu_fkey FOREIGN KEY (ttw_idmaterialu) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjna
    ADD CONSTRAINT tr_strukturakonstrukcyjna_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjnarel
    ADD CONSTRAINT tr_strukturakonstrukcyjnarel_sk_idstrukturyc_fkey FOREIGN KEY (sk_idstrukturyc) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_strukturakonstrukcyjnarel
    ADD CONSTRAINT tr_strukturakonstrukcyjnarel_sk_idstrukturyp_fkey FOREIGN KEY (sk_idstrukturyp) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tr_technoelem_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tr_technoelem_top_idoperacji_fkey FOREIGN KEY (top_idoperacji) REFERENCES tr_operacjetech(top_idoperacji) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tr_technoelem_tr_spinaczoperacji FOREIGN KEY (spo_idspinacza) REFERENCES tr_spinaczoperacji(spo_idspinacza) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_technoelem
    ADD CONSTRAINT tr_technoelem_uslugazw FOREIGN KEY (ttw_uslugazw) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_technoelemwsp
    ADD CONSTRAINT tr_technoelemwsp_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoelemwsp
    ADD CONSTRAINT tr_technoelemwsp_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technologie
    ADD CONSTRAINT tr_technologie_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_mrpkalkulacje
    ADD CONSTRAINT tr_technologie_kalk_th_idtechnologii FOREIGN KEY (kalk_th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_technologie
    ADD CONSTRAINT tr_technologie_sk_idstruktury FOREIGN KEY (sk_idstruktury) REFERENCES tr_strukturakonstrukcyjna(sk_idstruktury) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tr_mrpkalkulacje
    ADD CONSTRAINT tr_technologie_th_idtechnologii FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technologie
    ADD CONSTRAINT tr_technologie_ttw_idtowaru_fkey FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_technoprevnext
    ADD CONSTRAINT tr_technoprevnext_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoprevnext
    ADD CONSTRAINT tr_technoprevnext_the_idnext_fkey FOREIGN KEY (the_idnext) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technoprevnext
    ADD CONSTRAINT tr_technoprevnext_the_idprev_fkey FOREIGN KEY (the_idprev) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technostpracy
    ADD CONSTRAINT tr_technostpracy_klient FOREIGN KEY (k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technostpracy
    ADD CONSTRAINT tr_technostpracy_obiekt_fkey FOREIGN KEY (ob_idobiektu) REFERENCES tg_obiekty(ob_idobiektu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technostpracy
    ADD CONSTRAINT tr_technostpracy_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_technostpracy
    ADD CONSTRAINT tr_technostpracy_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_wariantelem
    ADD CONSTRAINT tr_wariantelem_kwe_idelemu_fkey FOREIGN KEY (kwe_idelemu) REFERENCES tr_kkwnod(kwe_idelemu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_wariantelem
    ADD CONSTRAINT tr_wariantelem_the_idelem_fkey FOREIGN KEY (the_idelem) REFERENCES tr_technoelem(the_idelem) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_wariantelem
    ADD CONSTRAINT tr_wariantelem_vmp_idwariantu_fkey FOREIGN KEY (vmp_idwariantu) REFERENCES tr_warianthead(vmp_idwariantu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tr_warianthead
    ADD CONSTRAINT tr_warianthead_th_idtechnologii_fkey FOREIGN KEY (th_idtechnologii) REFERENCES tr_technologie(th_idtechnologii) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_banki
    ADD CONSTRAINT ts_banki_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_banki
    ADD CONSTRAINT ts_banki_k_idklienta_for FOREIGN KEY (k_idklientafor) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
--

ALTER TABLE ONLY ts_banki
    ADD CONSTRAINT ts_banki_ref FOREIGN KEY (bk_idbanku_ref) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_elementyrodzajuobiektu
    ADD CONSTRAINT ts_elementyrodzajuobiektu_ts_rodzajeobiektow FOREIGN KEY (rb_idrodzaju) REFERENCES ts_rodzajeobiektow(rb_idrodzaju) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_kartotekadelegacji
    ADD CONSTRAINT ts_kartotekadelegacji_towar FOREIGN KEY (ttw_idtowaru) REFERENCES tg_towary(ttw_idtowaru) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_kartotekadelegacji
    ADD CONSTRAINT ts_kartotekadelegacji_waluta FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_fm_idcentrali_fkey FOREIGN KEY (fm_idcentrali) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_k_ctxidklienta_fkey FOREIGN KEY (k_ctxidklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_mm_magazyn_fkey FOREIGN KEY (mm_magazyn) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_mm_parent_fkey FOREIGN KEY (mm_parent) REFERENCES ts_miejscamagazynowe(mm_idmiejsca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_tr_idtransfor_fkey FOREIGN KEY (tr_idtransfor) REFERENCES tg_transakcje(tr_idtrans) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_miejscamagazynowe
    ADD CONSTRAINT ts_miejscamagazynowe_zprt_id_fkey FOREIGN KEY (zprt_id) REFERENCES ts_znacznikprt(zprt_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_osrodkipk
    ADD CONSTRAINT ts_osrodkipk_opk_parent_fkey FOREIGN KEY (opk_parent) REFERENCES ts_osrodkipk(opk_idosrodka) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY tr_przyczynaprzestojow
    ADD CONSTRAINT ts_rodzajeobiektow_trb_idrodzaju FOREIGN KEY (rb_idrodzaju) REFERENCES ts_rodzajeobiektow(rb_idrodzaju) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_rodzajklienta
    ADD CONSTRAINT ts_rodzajklienta_rk_parent_fkey FOREIGN KEY (rk_parent) REFERENCES ts_rodzajklienta(rk_idrodzajklienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_dz_iddzialu_fkey FOREIGN KEY (dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_fm_index FOREIGN KEY (fm_index) REFERENCES tb_firma(fm_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_mac_id_fkey FOREIGN KEY (mac_id) REFERENCES tb_mail_account(mac_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tgc_idgrupy_fkey FOREIGN KEY (tgc_idgrupy) REFERENCES ts_grupycen(tgc_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tgc_idgrupy_maxrabat_fkey FOREIGN KEY (tgc_idgrupy_maxrabat) REFERENCES ts_grupycen(tgc_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_thg_idgrupy_fkey FOREIGN KEY (thg_idgrupy) REFERENCES tr_technogrupy(thg_idgrupy) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tmg_idmagazynu_fkey FOREIGN KEY (tmg_idmagazynu) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tmg_idmagazynupod_fkey FOREIGN KEY (tmg_idmagazynupod) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tmg_idmagazynutech_fkey FOREIGN KEY (tmg_idmagazynutech) REFERENCES tg_magazyny(tmg_idmagazynu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_tsz_idtypu_fkey FOREIGN KEY (tsz_idtypu) REFERENCES ts_typzdarzenia(tsz_idtypu) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_seriepracownikow
    ADD CONSTRAINT ts_seriepracownikow_wl_idwaluty_fkey FOREIGN KEY (wl_idwaluty) REFERENCES tg_waluty(wl_idwaluty) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY ts_spedycje
    ADD CONSTRAINT ts_spedycje_kl_multivals FOREIGN KEY (sp_mvidklienta) REFERENCES mv.ts_multivals(mvs_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_statusyzachowanie
    ADD CONSTRAINT ts_statusyzachowanie_ts_statusy FOREIGN KEY (st_idstatusu_old) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_statusyzachowanie
    ADD CONSTRAINT ts_statusyzachowanie_ts_statusy_new FOREIGN KEY (st_idstatusu_new) REFERENCES ts_statusy(st_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_statuszlecenia
    ADD CONSTRAINT ts_statuszlecenia_szl_zd_szl_idstatusu_fkey FOREIGN KEY (szl_zd_szl_idstatusu) REFERENCES ts_statuszlecenia(szl_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_statuszlecenia
    ADD CONSTRAINT ts_statuszlecenia_ts_szablonzdarzenia FOREIGN KEY (szl_szd_idszablonu) REFERENCES ts_szablonzdarzenia(szd_idszablonu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_klient FOREIGN KEY (szd_k_idklienta) REFERENCES tb_klient(k_idklienta) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_mail_templates FOREIGN KEY (szd_mtpl_id) REFERENCES tb_mail_templates(mtpl_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_pracownicy FOREIGN KEY (szd_p_idpracownika) REFERENCES tb_pracownicy(p_idpracownika) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_role FOREIGN KEY (szd_rol_id) REFERENCES tb_role(rol_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_zdarzeniainfo FOREIGN KEY (szd_zdi_id) REFERENCES tb_zdarzeniainfo(zdi_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_zdarzeniainfo_sprawa FOREIGN KEY (szd_zdi_idsprawy) REFERENCES tb_zdarzeniainfo(zdi_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_tb_zdarzeniapt FOREIGN KEY (szd_zdp_id) REFERENCES tb_zdarzeniapt(zdp_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_ts_dzialy FOREIGN KEY (szd_dz_iddzialu) REFERENCES ts_dzialy(dz_iddzialu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_ts_statuszlecenia FOREIGN KEY (szd_szl_idstatusu) REFERENCES ts_statuszlecenia(szl_idstatusu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY ts_szablonzdarzenia
    ADD CONSTRAINT ts_szablonzdarzenia_ts_typzdarzenia FOREIGN KEY (szd_tsz_idtypu) REFERENCES ts_typzdarzenia(tsz_idtypu) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tu_impplat
    ADD CONSTRAINT tu_impplat_bk_idbanku_fkey FOREIGN KEY (bk_idbanku) REFERENCES ts_banki(bk_idbanku) ON UPDATE CASCADE ON DELETE SET NULL;


--
--

ALTER TABLE ONLY tu_impplatelem
    ADD CONSTRAINT tu_impplatelem_ipp_id_fkey FOREIGN KEY (ipp_id) REFERENCES tu_impplat(ipp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
--

ALTER TABLE ONLY tb_zdarzenia_flags
    ADD CONSTRAINT zd_idzdarzenia_fk FOREIGN KEY (zd_idzdarzenia) REFERENCES tb_zdarzenia(zd_idzdarzenia) ON UPDATE CASCADE ON DELETE CASCADE;
