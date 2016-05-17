CREATE FUNCTION przepiszrozrachunki(integer, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelzapisu ALIAS FOR $1;
 _iswn ALIAS FOR $2;

 wartosczp NUMERIC;
 wartoscrr NUMERIC;

 zp RECORD;
 flag INT;
BEGIN
 
 UPDATE kh_zapisyelem set zp_idelzapisu=zp_idelzapisu WHERE zp_idelzapisu=_idelzapisu;

 SELECT * INTO zp FROM kh_zapisyelem WHERE zp_idelzapisu=_idelzapisu;
 wartosczp=zp.zp_kwota;

 IF (zp.tr_idtrans IS NOT NULL) THEN 

  IF ((SELECT tr_idtrans FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu LIMIT 1) IS NOT NULL) THEN
   RETURN TRUE;
  END IF;

  wartoscrr=nullZero((SELECT sum(rr_wartoscwnpln+rr_wartoscmapln) FROM kr_rozrachunki WHERE tr_idtrans=zp.tr_idtrans AND rr_iswn=_iswn AND rr_flaga&7 IN (0) AND zp_idelzapisu IS NULL));

  RAISE NOTICE 'TR: Wartosc na zapisie %',wartosczp;
  RAISE NOTICE 'TR: Wartosc na rozrachunkach % ',wartoscrr;

  IF (wartosczp<>wartoscrr) THEN
   IF (wartoscrr=0) THEN
    IF ((SELECT tr_zamknieta&64 FROM tg_transakcje WHERE tr_idtrans=zp.tr_idtrans)=0) THEN
     RETURN TRUE;
    END IF;
   END IF;
  END IF;

  --- Skasuj poprzednie rozrachunki KH
  DELETE FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu AND rr_iswn=_iswn;

  --- Zrob update na przeniesionych rozrachunkach
  UPDATE kr_rozrachunki SET zp_idelzapisu=zp.zp_idelzapisu,kt_idkonta=(CASE WHEN _iswn=TRUE THEN zp.kt_idkontawn ELSE zp.kt_idkontama END) WHERE tr_idtrans=zp.tr_idtrans AND rr_iswn=_iswn AND rr_flaga&7 IN (0);

  RETURN TRUE;
 END IF;

 IF (zp.pl_idplatnosc IS NOT NULL) THEN 

  IF ((SELECT pl_idplatnosc FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu LIMIT 1) IS NOT NULL) THEN
   RETURN TRUE;
  END IF;

  wartoscrr=(SELECT sum(rr_wartoscwnpln+rr_wartoscmapln) FROM kr_rozrachunki WHERE pl_idplatnosc=zp.pl_idplatnosc AND rr_iswn=_iswn AND rr_flaga&7 IN (0));

  IF (wartoscrr IS NULL) THEN

   ---Utworz rozrachunki
   flag=(SELECT pl_flaga FROM kh_platnosci WHERE pl_idplatnosc=zp.pl_idplatnosc AND (CASE WHEN _iswn THEN pl_wplyw=-1 ELSE pl_wplyw=1 END));
   UPDATE kh_platnosci SET pl_flaga=pl_flaga&(~(4|24)) WHERE pl_idplatnosc=zp.pl_idplatnosc AND (CASE WHEN _iswn THEN pl_wplyw=-1 ELSE pl_wplyw=1 END);
   wartoscrr=(SELECT sum(rr_wartoscwnpln+rr_wartoscmapln) FROM kr_rozrachunki WHERE pl_idplatnosc=zp.pl_idplatnosc AND rr_iswn=_iswn AND rr_flaga&7 IN (0) AND zp_idelzapisu IS NULL);
   IF (wartoscrr IS NULL) THEN
    UPDATE kh_platnosci SET pl_flaga=flag WHERE pl_idplatnosc=zp.pl_idplatnosc AND (CASE WHEN _iswn THEN pl_wplyw=-1 ELSE pl_wplyw=1 END);
    RETURN TRUE;
   END IF;
   IF (wartoscrr<>wartosczp) THEN
    RAISE NOTICE 'PL1: Wartosc na zapisie %',wartosczp;
    RAISE NOTICE 'PL1: Wartosc na rozrachunkach % ',wartoscrr;
    RAISE EXCEPTION 'Blad synchronizacji dla zapisu % platnosci % i strony % ',_idelzapisu,zp.pl_idplatnosc,_iswn;
   END IF;

   ---Skasuj je
   DELETE FROM kr_rozrachunki WHERE pl_idplatnosc=zp.pl_idplatnosc AND rr_iswn=_iswn;
   --Przypisz rozrachunki z KH do platnosci
   UPDATE kr_rozrachunki SET pl_idplatnosc=zp.pl_idplatnosc,kt_idkonta=(CASE WHEN _iswn=TRUE THEN zp.kt_idkontawn ELSE zp.kt_idkontama END) WHERE rr_iswn=_iswn AND zp_idelzapisu=zp.zp_idelzapisu;

   wartoscrr=(SELECT sum(rr_wartoscwnpln+rr_wartoscmapln) FROM kr_rozrachunki WHERE pl_idplatnosc=zp.pl_idplatnosc AND rr_iswn=_iswn AND rr_flaga&7 IN (0));

   IF (wartoscrr IS NULL) THEN
    RAISE NOTICE 'PL1: Wartosc na zapisie %',wartosczp;
    RAISE NOTICE 'PL1: Wartosc na rozrachunkach % ',wartoscrr;
    RAISE EXCEPTION 'Blad dla zapisu % platnosci % i strony % ',_idelzapisu,zp.pl_idplatnosc,_iswn;
   END IF;

   IF (wartosczp<>wartoscrr) THEN
    RAISE EXCEPTION 'Nie moge przeniesc rozrachunkow z KH dla zapisu % platnosci % i strony % ',_idelzapisu,zp.pl_idplatnosc,_iswn;
   END IF;

   UPDATE kh_platnosci SET pl_pozostalo=nullZero((SELECT sum(rr_wartoscpozwal) FROM kr_rozrachunki WHERE rr_flaga&3=0 AND kr_rozrachunki.pl_idplatnosc=kh_platnosci.pl_idplatnosc)) WHERE (PLisNormal(pl_flaga) OR PLisBufor(pl_flaga)) AND pl_wplyw<0 AND pl_idplatnosc=zp.pl_idplatnosc;
   UPDATE kh_platnosci SET pl_pozostalo=-nullZero((SELECT sum(rr_wartoscpozwal) FROM kr_rozrachunki WHERE rr_flaga&3=0 AND kr_rozrachunki.pl_idplatnosc=kh_platnosci.pl_idplatnosc)) WHERE (PLisNormal(pl_flaga) OR PLisBufor(pl_flaga)) AND pl_wplyw>0 AND pl_idplatnosc=zp.pl_idplatnosc;

   RETURN TRUE;
  END IF;

  RAISE NOTICE 'PL: Wartosc na zapisie %',wartosczp;
  RAISE NOTICE 'PL: Wartosc na rozrachunkach % ',wartoscrr;

  IF (wartosczp<>wartoscrr) THEN
   ---RAISE EXCEPTION 'Nie moge przeniesc rozrachunkow dla zapisu % platnosci % i strony % ',_idelzapisu,zp.pl_idplatnosc,_iswn;
  END IF;

  --- Skasuj poprzednie rozrachunki KH
  DELETE FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu AND rr_iswn=_iswn;

  --- Zrob update na przeniesionych rozrachunkach
  UPDATE kr_rozrachunki SET zp_idelzapisu=zp.zp_idelzapisu,kt_idkonta=(CASE WHEN _iswn=TRUE THEN zp.kt_idkontawn ELSE zp.kt_idkontama END) WHERE pl_idplatnosc=zp.pl_idplatnosc AND rr_iswn=_iswn AND rr_flaga&7 IN (0);

  RETURN TRUE;
 END IF;


 RETURN FALSE;
END;
$_$;
