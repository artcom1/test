CREATE VIEW khzapisy AS
 SELECT zn.zp_idelzapisu AS idelzapisu,
    zn.ktn_idkonta AS idkontazapisu,
    zn.zp_nrdowodu AS nrdowodu,
    zn.zp_kwotawn AS kwotawn,
    zn.zp_kwotama AS kwotama,
    zn.zp_kwotawnwal AS kwotawnwal,
    zn.zp_kwotamawal AS kwotamawal,
    zn.wl_idwaluty AS idwaluty_zapisu,
    zn.ktn_idkontaoposite AS idkontazapisu_op,
    zn.zk_datadok AS datadok,
    zn.mn_miesiac AS miesiac,
    zn.zk_fullnumer AS fullnumer,
    zn.zk_opis AS opis_header,
    zn.zp_opis AS opis_position,
    zn.r_idroku AS rok_ksiegowy,
    kt.k_idklienta AS tr_kidklienta,
    zn.zp_typ AS typzapisu,
    (zn.zp_flaga & 1) AS zapiszatwierdzony,
    zn.idcentrali
   FROM (qvi.khzapisy_normalized zn
     JOIN public.kh_konta kt ON ((kt.kt_idkonta = zn.kt_idkonta)));
