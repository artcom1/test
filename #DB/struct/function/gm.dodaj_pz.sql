CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in          ALIAS FOR $1;
 _dodelete    ALIAS FOR $2;
 inl          gm.DODAJ_PZ_TYPE;
 ret          gm.DODAJ_PZ_RETTYPE;
 retl         gm.DODAJ_PZ_RETTYPE;
 rec          RECORD;
 --------
 iloscrest    NUMERIC;
 wartoscrest  NUMERIC;
 wartosctmp   NUMERIC;
 wspwrt       NUMERIC:=1;
BEGIN

 IF (_in.tex_idelem IS NOT NULL) THEN
  ret=gm.dodaj_pz_wtex(_in,_dodelete);
  RETURN ret;
 END IF;

 IF (_in.tel_iloscf=0) THEN
  _dodelete=TRUE;
 END IF;
 
 IF (COALESCE(_in._istransodwrocona,FALSE)=TRUE) THEN
  wspwrt=-wspwrt;
  _in.tel_wartosc=-_in.tel_wartosc;
 END IF;

 ret.wartosc=0;
 iloscrest=_in.tel_iloscf;
 wartoscrest=_in.tel_wartosc;

 inl.tel_idelem=_in.tel_idelem;
 inl.tr_idtrans=_in.tr_idtrans;
 inl.ttw_idtowaru=_in.ttw_idtowaru;
 inl.ttm_idtowmag=_in.ttm_idtowmag;
 inl.tmg_idmagazynu=_in.tmg_idmagazynu;
 inl.k_idklienta=_in.k_idklienta;
 inl.rc_data=_in.rc_data;
 inl.prt_idpartii=_in.prt_idpartii;
 inl._isapz=_in._isapz;
 inl._iskonsygnata=_in._iskonsygnata;
 inl.rc_cenajmcrs=_in.rc_cenajmcrs;


 FOR rec IN SELECT * FROM tg_teex AS ex 
                     WHERE ex.tel_idelem=_in.tel_idelem 
		     ORDER BY ex.tex_idelem
 LOOP
  inl._istransodwrocona=_in._istransodwrocona;
  inl.tex_idelem=rec.tex_idelem;
  inl.tel_iloscf=rec.tex_iloscf;
  inl.prt_idpartii=rec.prt_idpartii;
  IF (_dodelete=TRUE) THEN
   inl.tel_iloscf=0;
  END IF;
  ---Oblicz wartosc
  IF (inl.tel_iloscf=0) THEN
   wartosctmp=0;
  ELSIF (inl.tel_iloscf=iloscrest) THEN
   wartosctmp=wartoscrest;
  ELSE
   wartosctmp=floorRoundMax(_in.tel_wartosc*inl.tel_iloscf/_in.tel_iloscf,wartoscrest);
  END IF;
  inl.tel_wartosc=wartosctmp*wspwrt;
  inl.tel_iloscrez=rec.tex_iloscfrez;
  ---Odejmij lokalne resty
  wartoscrest=wartoscrest-inl.tel_wartosc*wspwrt;
  iloscrest=iloscrest-inl.tel_iloscf;
  ---Wykonaj funkcje
  retl=gm.dodaj_pz_wtex(inl,_dodelete);
  ---Oblicz wartosc
  ret.wartosc=ret.wartosc+retl.wartosc*wspwrt;
 END LOOP;
 
 _in.tel_wartosc=_in.tel_wartosc*wspwrt;
 wspwrt=-wspwrt;
 
 ----Nie znaleziono zadnego rekordu teex
 IF NOT FOUND THEN
  ret=gm.dodaj_pz_wtex(_in,_dodelete);
  RETURN ret;
 ELSE
  _in.tel_iloscf=0;
  _in.tex_idelem=NULL;
  PERFORM gm.dodaj_pz_wtex(_in,TRUE);
 END IF;

 ---Zgadza sie wszystko - wyjdz
 IF (iloscrest=0) AND (wartoscrest=0) THEN
  RETURN ret;
 END IF;

 ---Bezwzglednie nie moge rozpisac wiecej
 IF (iloscrest<0) OR (wartoscrest<0) THEN
  RAISE EXCEPTION '44|%:%:%:%|Blad rozpisania na teex',_in.tel_idelem,_in.tel_iloscf,iloscrest,wartoscrest;
 END IF;

 --Dla APZetow mozna nie rozpisywac wszystkiego
 IF (_in._isapz=TRUE) THEN
  RETURN ret;
 END IF;

 RAISE EXCEPTION '44|%:%:%:%|Blad rozpisania na teex',_in.tel_idelem,_in.tel_iloscf,iloscrest,wartoscrest;

 RETURN ret;
END;
$_$;
