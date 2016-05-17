CREATE VIEW wymiary AS
 SELECT i.ktn_idkonta AS idkontawymiaru,
    i.idwymiaru,
    i.mc_miesiac AS miesiac_wymiaru,
    i.valuewnwal AS valuewnwal_wymiaru,
    i.valuemawal AS valuemawal_wymiaru,
    i.valuewn AS valuewn_wymiaru,
    i.valuema AS valuema_wymiaru,
    i.idwaluty AS idwaluty_wymiaru,
    i.idpracownika AS idpracownika_wymiaru,
    i.idklienta AS tr_kidklienta,
    i.idzlecenia AS idzlecenia_wymiaru,
    i.idsrodkatrwalego AS idsrodkatrwalego_wymiaru,
    i.idgrupytowarow AS tgr_idgrupy,
    i.idpodgrupytowarow AS tpg_idpodgrupy,
    i.idgrupywww AS tgw_idgrupy,
    i.idrodzajuklienta AS idrodzajuklienta_wymiaru,
    i.idwagiklienta AS idwagiklienta_wymiaru,
    i.iddzialu AS iddzialu_wymiaru,
    i.idfirmy AS idfirmy_wymiaru,
    i.idmagazynu AS idmagazynu_wymiaru,
    i.idosrodkapk AS idosrodkapk_wymiaru,
    i.idtowaru AS ttw_idtowaru,
    i.idcustom AS idcustom_wymiaru,
    i.isdopelnienie AS isdopelnienie_wymiaru,
    i.idcentrali
   FROM qvi.wymiary i;