CREATE FUNCTION skopiujrezerwacje(skopiuj_rezerwacje_type) RETURNS skopiuj_rezerwacje_rettype
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in          ALIAS FOR $1;
 rdata        RECORD;
 iloscpz      NUMERIC:=0;
 iloscrez     NUMERIC:=0;
 iloscpoznew  NUMERIC;
 flaga        INT;
 -------------------------
 deleteOLD    BOOL:=FALSE;
 ret          gm.SKOPIUJ_REZERWACJE_RETTYPE;
 trs          gm.PUSH_REZSTACK_TYPE;
 rc_recvertmp INT;
BEGIN
 
 IF (_in.rc_ilosctocopy=0) THEN
  RETURN NULL;
 END IF;

 SELECT * INTO rdata FROM tg_ruchy WHERE rc_idruchu=_in.rc_idruchu_src;


 IF (_in.rc_ruch_new IS NULL) THEN
  --Wez ilosc ktora jest zarezerwowana z PZetem
  iloscpz=min(rdata.rc_iloscrez,_in.rc_ilosctocopy);
  iloscrez=iloscpz;
  --Oznacz PZet zeby sobie nie dobieral innych rezerwacji bo mu dobierzemy
  PERFORM gm.blockPZet(rdata.rc_ruch,TRUE);
 ELSE
  iloscpoznew=_in.rc_ilosctocopy;
 END IF;

 IF (rdata.rc_ilosc=_in.rc_ilosctocopy) THEN
  deleteOLD=TRUE;
 END IF;

 --Zmniejsz na biezacym
 UPDATE tg_ruchy SET rc_ilosc=round(rc_ilosc-_in.rc_ilosctocopy,4),
		     rc_iloscpoz=rc_iloscpoz-iloscpz,
                     rc_iloscrez=rc_iloscrez-iloscrez
		     WHERE rc_idruchu=rdata.rc_idruchu;

 IF (iloscpz<=0) THEN 
---  RETURN NULL; 
 END IF;

 ---Dodaj nowy rekord, ktory bedzie odnosil sie do biezacego dokumentu
 ---I bedzie zawieral ilosc ktora sciagamy z biezacego PZeta
 flaga = rdata.rc_flaga;
 
 IF (COALESCE(_in._leaveflags,FALSE)=FALSE) THEN
  IF (_in.tel_idelem_dst IS NULL) OR (_in.tel_idelem_dst=rdata.tel_idelem) THEN
   IF (_in.tel_idelem_dst IS NULL) THEN
    flaga=(rdata.rc_flaga&(~(256)));
   END IF;
   flaga=flaga&(~(1<<19));
  ELSE
   flaga=(rdata.rc_flaga|256);
   flaga=flaga|_in.rc_addflaga;
  END IF;
 ELSE
  flaga=rdata.rc_flaga;
  flaga=flaga|COALESCE(_in.rc_addflaga,0);
 END IF;
 flaga=flaga&(~COALESCE(_in.rc_delflaga,0));

 IF (_in.tel_idelem_dst IS NOT NULL) AND (_in.tel_idelem_dst<>rdata.tel_idelem) THEN
  rc_recvertmp=nextval('gm.tg_rezstack_ver');
 END IF;

 ret.rc_idruchu_new=nextval('tg_ruchy_s');
 ret.rc_recver_new=nextval('gm.tg_rezstack_ver');

 ---RAISE NOTICE 'Kopia % % z %->%',_in.rc_ruch_new,rdata.rc_ruch,rdata.rc_idruchu,ret.rc_idruchu_new;

 ---Tutaj tworze (lub nie) rekord ktory powstanie z tej rezerwacji
 INSERT INTO tg_ruchy 
  (rc_idruchu,tel_idelem,tr_idtrans,ttw_idtowaru,
   ttm_idtowmag,tmg_idmagazynu,
   rc_data,rc_dataop,
   rc_ilosc,rc_iloscpoz,rc_iloscrez,
   rc_flaga,k_idklienta,rc_ruch,
   rc_seqid,prt_idpartiiwz,
   rc_recver,tex_idelem,
   prt_idpartiipz
   )
 VALUES
  (ret.rc_idruchu_new,_in.tel_idelem_dst,_in.tr_idtrans_dst,rdata.ttw_idtowaru,
   rdata.ttm_idtowmag,rdata.tmg_idmagazynu,
   rdata.rc_data,rdata.rc_dataop,
   round(_in.rc_ilosctocopy,4),round(COALESCE(iloscpoznew,iloscpz),4)+COALESCE(_in.rc_iloscpoztoadd,0),round(iloscrez,4),
   flaga,rdata.k_idklienta,COALESCE(_in.rc_ruch_new,rdata.rc_ruch),
   rdata.rc_seqid,rdata.prt_idpartiiwz,
   ret.rc_recver_new,_in.tex_idelem_dst,
   COALESCE(_in.prt_idpartiipz_new,rdata.prt_idpartiipz)); 


 ----RAISE NOTICE 'Dodalem przez skopiowanie ruch % z % ',ret.rc_idruchu_new,rdata.rc_idruchu;
 IF (gm.isOznaczonyRuchN(_in.rc_idruchu_src)=TRUE) THEN
  PERFORM gm.copyOznaczenia(_in.rc_idruchu_src,ret.rc_idruchu_new);
 END IF;

 PERFORM gm.copyRezStack(_in.rc_idruchu_src,ret.rc_idruchu_new,rc_recvertmp);

 IF (rc_recvertmp IS NOT NULL) THEN
  trs=NULL;
  trs.tel_idelem_old=rdata.tel_idelem;
  trs.tel_idelem_new=_in.tel_idelem_dst;
  trs.tex_idelem_new=_in.tex_idelem_dst;
  trs.prt_idpartii_old=rdata.prt_idpartiiwz;
  trs.prt_idpartii_new=rdata.prt_idpartiiwz;
  trs.rc_flaga_old=flaga;
  trs.rc_recver_old=rc_recvertmp;
  trs.rc_recver_new=ret.rc_recver_new;
  PERFORM gm.pushRezStack(ret.rc_idruchu_new,trs);
 END IF;

 IF (deleteOLD=TRUE) THEN
  DELETE FROM gm.tg_rezstack WHERE rc_idruchu=(SELECT rc_idruchu FROM tg_ruchy WHERE rc_ilosc=0 AND rc_idruchu=rdata.rc_idruchu);
  DELETE FROM tg_ruchy WHERE rc_ilosc=0 AND rc_idruchu=rdata.rc_idruchu;
 END IF;

 IF (_in.rc_ruch_new IS NULL) THEN
  --Odznacz PZet zeby sobie mogl juz  dobierac inne rezerwacje
  PERFORM gm.blockPZet(rdata.rc_ruch,FALSE);
 END IF;

 return ret;
END; 
$_$;
