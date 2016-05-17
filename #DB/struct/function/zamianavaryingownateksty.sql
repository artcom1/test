CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 versja INT;
BEGIN
 versja=(select substring(version(),12,1)::int);

 IF (versja=7) THEN
  RETURN 7;
 END IF;
 
 ---klient
 ALTER TABLE tb_klient ALTER k_nrlokalu type text;
 ALTER TABLE tb_klient ALTER k_kodpocztowy type text;
 ALTER TABLE tb_klient ALTER k_miejscowosc type text;
 ALTER TABLE tb_klient ALTER k_nip type text;
 ALTER TABLE tb_klient ALTER k_telefon1 type text;
 ALTER TABLE tb_klient ALTER k_telefon2 type text;
 ALTER TABLE tb_klient ALTER k_fax type text;
 ALTER TABLE tb_klient ALTER k_bank type text;
 ALTER TABLE tb_klient ALTER k_nrkonta type text;
 ALTER TABLE tb_klient ALTER k_kod type text;
 ALTER TABLE tb_klient ALTER k_nasznumer type text;
 ALTER TABLE tb_klient ALTER k_osobaodbierajaca type text;
 ALTER TABLE tb_klient ALTER k_regon type text;
 ALTER TABLE tb_klient ALTER k_iln type text;
 ALTER TABLE tb_klient ALTER k_dostawa type text;
 ALTER TABLE tb_klient ALTER k_haslo type text;
 ALTER TABLE tb_klient ALTER k_nrdomu type text;

 ---pracownicy
 ALTER TABLE tb_pracownicy ALTER p_nazwisko type text;
 ALTER TABLE tb_pracownicy ALTER p_imie type text;
 ALTER TABLE tb_pracownicy ALTER p_login type text;
 ALTER TABLE tb_pracownicy ALTER p_kodpocztowy type text;
 ALTER TABLE tb_pracownicy ALTER p_miejscowosc type text;
 ALTER TABLE tb_pracownicy ALTER p_telefonkom type text;
 ALTER TABLE tb_pracownicy ALTER p_telefondom type text;

 ---towary
 ALTER TABLE tg_towary ALTER ttw_nazwadost type text;
 ALTER TABLE tg_towary ALTER ttw_klucz type text;
 ALTER TABLE tg_towary ALTER ttw_sww type text;
 ALTER TABLE tg_towary ALTER ttw_koddost type text;
 ALTER TABLE tg_towary ALTER ttw_n1 type text;
 ALTER TABLE tg_towary ALTER ttw_n2 type text;
 ALTER TABLE tg_towary ALTER ttw_n3 type text;
 ALTER TABLE tg_towary ALTER ttw_ean type text;
 ALTER TABLE tg_towary ALTER ttw_pcn type text;

 ---transakcje
 ALTER TABLE tg_transakcje ALTER tr_nip type text;
 ALTER TABLE tg_transakcje ALTER tr_kkodpocz type text;
 ALTER TABLE tg_transakcje ALTER tr_oadres type text;
 ALTER TABLE tg_transakcje ALTER tr_omiasto type text;
 ALTER TABLE tg_transakcje ALTER tr_okodpocz type text;
 ALTER TABLE tg_transakcje ALTER tr_onip type text;
 ALTER TABLE tg_transakcje ALTER tr_kmiasto type text;
 ALTER TABLE tg_transakcje ALTER tr_numerdost type text;
 ALTER TABLE tg_transakcje ALTER tr_numerzam type text;
 ALTER TABLE tg_transakcje ALTER tr_inne type text;

 ---transelem
 ALTER TABLE tg_transelem ALTER tel_nrseryjny type text;

 ---slowniki
 ALTER TABLE ts_regiony ALTER rj_nazwa type text;
 ALTER TABLE kh_dziennik ALTER dz_kod type text;
 ALTER TABLE kh_lata ALTER ro_rok type text;
 ALTER TABLE tg_podgrupytow ALTER tpg_nazwa type text;
 ALTER TABLE ts_powiaty ALTER pw_nazwa  type text;
 ALTER TABLE ts_powiaty ALTER pw_wojewodztwo  type text;
 ALTER TABLE ts_statusklienta ALTER sk_opisstatusu type text;

 ---platnosci 
 ALTER TABLE kh_platnosci ALTER pl_nrobcy type text;

 ---rejestr head
 ALTER TABLE kh_rejestrhead ALTER rh_kkodpocz type text;
 ALTER TABLE kh_rejestrhead ALTER rh_kmiasto type text;
 ALTER TABLE kh_rejestrhead ALTER rh_numerdok type text;
 ALTER TABLE kh_rejestrhead ALTER rh_korekta type text;

 ALTER TABLE kh_wzorceelemkpir ALTER wk_nazwa type text;

 ---zapisyhead
 ALTER TABLE kh_zapisyhead ALTER zk_numerdowodu type text;

 ---zapisykpir
 ALTER TABLE kh_zapisykpir ALTER kp_kkodpocz type text;
 ALTER TABLE kh_zapisykpir ALTER kp_kmiasto type text;
 ALTER TABLE kh_zapisykpir ALTER kp_numerdok type text;
 ALTER TABLE kh_zapisykpir ALTER kp_uwagi type text;

 ---zlecenia
 ALTER TABLE tg_zlecenia ALTER zl_nazwa type text;

 ---ludzie klienta
 ALTER TABLE tb_ludzieklienta ALTER lk_nazwisko type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_imie type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_tytulstanowisko type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_nrlokalu type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_kodpocztowy type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_miejscowosc type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_telefon1 type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_telefon2 type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_telkom type text;
 ALTER TABLE tb_ludzieklienta ALTER lk_nrpaszportu type text;

----srodki trwale
 ALTER TABLE st_srodkitrwale ALTER str_nrinwent type text;
 ALTER TABLE st_srodkitrwale ALTER str_kst type text;
 ALTER TABLE st_srodkitrwale ALTER str_nazwa type text;
 ALTER TABLE st_srodkitrwale ALTER str_nrdokkupna type text;
 ALTER TABLE st_srodkitrwale ALTER str_uwagilikwidacji type text;

 ---dane firmy
 ALTER TABLE tb_firma ALTER fm_nazwa type text;
 ALTER TABLE tb_firma ALTER fm_adres type text;
 ALTER TABLE tb_firma ALTER fm_kod type text;
 ALTER TABLE tb_firma ALTER fm_miejscowosc type text;
 ALTER TABLE tb_firma ALTER fm_nip type text;
 ALTER TABLE tb_firma ALTER fm_regon type text;
 ALTER TABLE tb_firma ALTER fm_tel1 type text;
 ALTER TABLE tb_firma ALTER fm_tel2 type text;
 ALTER TABLE tb_firma ALTER fm_fax  type text;
 ALTER TABLE tb_firma ALTER fm_www type text;
 ALTER TABLE tb_firma ALTER fm_email type text;
 ALTER TABLE tb_firma ALTER fm_iln type text;
 ALTER TABLE tb_firma ALTER fm_nazwisko type text;
 ALTER TABLE tb_firma ALTER fm_imie type text;
 ALTER TABLE tb_firma ALTER fm_wojewodztwo type text;
 ALTER TABLE tb_firma ALTER fm_powiat type text;
 ALTER TABLE tb_firma ALTER fm_gmina type text;
 ALTER TABLE tb_firma ALTER fm_poczta type text;
 ALTER TABLE tb_firma ALTER fm_repimie type text;
 ALTER TABLE tb_firma ALTER fm_repnazwisko type text;


 ALTER TABLE tc_config ALTER cf_tabela  type text;
 ALTER TABLE tc_config ALTER cf_opis type text;

 ---sekretariat
 ALTER TABLE tg_archiwum ALTER a_zalacznik type text;
 ALTER TABLE tg_archiwum ALTER a_zrodlo type text;
 ALTER TABLE tg_archiwum ALTER a_job type text;
 ALTER TABLE tg_archiwum ALTER a_prefix type text;

 ---bilety
 ALTER TABLE tg_bilety ALTER bl_kod type text;

 ALTER TABLE tg_ignorowaneeany ALTER ie_ean type text;

 ALTER TABLE tg_inwdupusty ALTER iu_kod type text;
 ALTER TABLE tg_jednostki ALTER tjn_nazwa type text;
 ALTER TABLE tg_jednostki ALTER tjn_skrot type text;

 ---klient zlecenia
 ALTER TABLE tg_klientzlecenia ALTER kz_imie type text;
 ALTER TABLE tg_klientzlecenia ALTER kz_nazwisko type text;
 ALTER TABLE tg_klientzlecenia ALTER kz_nrpaszportu type text;
 ALTER TABLE tg_klientzlecenia ALTER kz_kodpocztowy type text;
 ALTER TABLE tg_klientzlecenia ALTER kz_miejscowosc type text;

 ALTER TABLE tg_magazyny ALTER tmg_kontoks type text;
 ALTER TABLE tg_magazyny ALTER tmg_iln type text;

 ---obiekty
 ALTER TABLE tg_obiekty ALTER ob_kod type text;
 ALTER TABLE tg_obiekty ALTER ob_nrseryjny type text;
 ALTER TABLE tg_obiekty ALTER ob_cecha1 type text;
 ALTER TABLE tg_obiekty ALTER ob_cecha2 type text;
 ALTER TABLE tg_obiekty ALTER ob_cecha3 type text;

 ---plan zlecenia
 ALTER TABLE tg_planzlecenia ALTER pz_pkwiu type text;
 ALTER TABLE tg_planzlecenia ALTER pz_kod type text;

 ALTER TABLE tg_produkcja  ALTER tsk_nazwa  type text;
 ALTER TABLE tg_przejazdy ALTER pr_skad type text;
 ALTER TABLE tg_przejazdy ALTER pr_dokad type text;

 ALTER TABLE tg_raport ALTER r_nazwa type text;

 ALTER TABLE tg_voucher ALTER vc_town type text;
 ALTER TABLE tm_hasla ALTER tm_login type text;
 ALTER TABLE tm_hasla ALTER tm_haslo type text;
 ALTER TABLE tm_uprawnienia ALTER tu_kod  type text;
 ALTER TABLE tp_wydzialy ALTER w_kod type text;

 ---banki
 ALTER TABLE ts_banki ALTER bk_kod type text;
 ALTER TABLE ts_banki ALTER bk_nazwa type text;
 ALTER TABLE ts_banki ALTER bk_adres type text;
 ALTER TABLE ts_banki ALTER bk_nrkonta type text;
 ALTER TABLE ts_banki ALTER bk_rejestr type text;

 ALTER TABLE ts_branze ALTER br_nazwa type text;
 ALTER TABLE ts_dzialy ALTER dz_nazwa type text;
 ALTER TABLE ts_grupysrtrw ALTER gst_opis type text;
 ALTER TABLE ts_nazwarejestru ALTER nr_nazwa type text;
 ALTER TABLE ts_operacjagoskpir ALTER og_kod  type text;
 ALTER TABLE ts_operacjagoskpir ALTER og_nazwa type text;
 ALTER TABLE ts_rodzajarchiwum ALTER r_nazwa type text;
 ALTER TABLE ts_samochody ALTER sm_marka type text;
 ALTER TABLE ts_samochody ALTER sm_numrejestr type text;
 ALTER TABLE ts_stanowisko ALTER st_nazwa type text;
 ALTER TABLE ts_stanowisko ALTER st_grwbazie type text;
 ALTER TABLE ts_wlascicielefirmy ALTER wf_nazwisko type text;
 ALTER TABLE ts_wlascicielefirmy ALTER wf_imie type text;
 ALTER TABLE ts_zrodloinf ALTER zi_opis type text;
 ALTER TABLE ts_zwrotgrzeczn ALTER zg_opiszwrotu type text;
 ALTER TABLE tu_uprawnienia ALTER u_nazwa type text;
 ALTER TABLE tu_uprawnienia ALTER u_ref type text;

 RETURN 8;
END;
$$;
