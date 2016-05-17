CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN uaktualnieniePracZMRP($1,0);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _is_tpz ALIAS FOR $2;
BEGIN
 IF (_is_tpz>0) THEN
  RETURN uaktualnieniePracZMRP($1,NULL,1,getFlagaKosztowPracyMRP_TPZ());
 END IF;
 
 RETURN uaktualnieniePracZMRP($1,NULL,0,getFlagaKosztowPracyMRP());
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 idwykonania ALIAS FOR $1;
 idwykonania_det ALIAS FOR $2;
 _is_tpz ALIAS FOR $3;
 mrp_skp_koszt_flaga ALIAS FOR $4;
 
 prace RECORD;
 danedopracy RECORD;
 nod RECORD;
 
 flaga INT;
 prdatastart timestamp with time zone;
 prdatastop timestamp with time zone;
 rbh NUMERIC;
  
 query TEXT:='';  ---zapytanie o wykonania
 q_tmp TEXT:='';
 
 _koszt TEXT:='0';
 _koszt_ilosc TEXT:='0';
 _koszt_czas TEXT:='0';
 _koszt_czas_pracownik TEXT:='0';
 _koszt_czas_stanowisko TEXT:='0'; 
BEGIN
  
 query='SELECT knw_zaangazpracwykonanie,fm_idcentrali,kwd_flaga,det.p_idpracownika,kwd_idelemu,COALESCE(kwd_datastart,knw_datastart) AS datastart,COALESCE(kwd_dataend,knw_datawyk) AS datastop,kwd_rbh,wyliczIloscWykonaniaMRP(knw_iloscwyk,kwe_iloscplanwyk,the_flaga) AS ilosc,top_nazwa||''-''||kwe_nazwa AS temat ';
  
 --Ilosc x koszt jednostkowy (operacji technologicznej)
 IF ((mrp_skp_koszt_flaga&(1<<0))=(1<<0)) THEN
  _koszt_ilosc='round(getEfektywnyNormatywPrac(knw_kosztnaj*knw_wspkosztuprac*wyliczIloscWykonaniaMRP(knw_iloscwyk,kwe_iloscplanwyk,the_flaga)/(CASE WHEN (knw_wydajnosc=0) THEN 1 ELSE knw_wydajnosc END),suma_rbh,kwd_rbh,ilosc_prac),2)';
 END IF;
 
 --Czas produkcji x koszt godziny (operacji technologicznej)
 IF ((mrp_skp_koszt_flaga&(1<<1))=(1<<1)) THEN
  IF ((mrp_skp_koszt_flaga&(1<<3))=(1<<3)) THEN
   --(z uwzglednieniem zaangazowania)
   _koszt_czas='round(kwd_rbh*knw_kosztnah*knw_wspkosztuprac*(nod.kwe_zaangazpracownika/100),2)';
  ELSE
   _koszt_czas='round(kwd_rbh*knw_kosztnah*knw_wspkosztuprac,2)';
  END IF;
 END IF;
 
 --Czas produkcji x koszt godziny pracownika
 IF ((mrp_skp_koszt_flaga&(1<<2))=(1<<2)) THEN
  IF ((mrp_skp_koszt_flaga&(1<<3))=(1<<3)) THEN
    --(z uwzglednieniem zaangazowania)
   _koszt_czas_pracownik='round(kwd_rbh*NullZero(pr.p_kosztnah)*(nod.kwe_zaangazpracownika/100),2)';
   q_tmp=q_tmp||' LEFT JOIN tb_pracownicy AS pr ON (det.p_idpracownika=pr.p_idpracownika) ';
  ELSE
   _koszt_czas_pracownik='round(kwd_rbh*NullZero(pr.p_kosztnah),2)';
   q_tmp=q_tmp||' LEFT JOIN tb_pracownicy AS pr ON (det.p_idpracownika=pr.p_idpracownika) ';
  END IF;
 END IF;
    
 --Czas produkcji x koszt godziny stanowiska
 IF ((mrp_skp_koszt_flaga&(1<<4))=(1<<4)) THEN
  _koszt_czas_stanowisko='round(kwd_rbh*NullZero(ob_kosztpracy),2)';
  q_tmp=q_tmp||' LEFT JOIN tg_obiekty AS ob ON (wyk.ob_idobiektu=ob.ob_idobiektu) ';
 END IF;
 
 --Koszt
 _koszt='round('||_koszt_ilosc||'+'||_koszt_czas||'+'||_koszt_czas_pracownik||'+'||_koszt_czas_stanowisko||',2)';
 query=query||','||_koszt||' AS koszt ';
 
 --Cena jednostkowa
 IF (_is_tpz=1) THEN -- Dla TPZetow dziele przez czas
  query=query||',round('||_koszt||'/(CASE WHEN COALESCE(kwd_rbh,0)<>0 THEN round(kwd_rbh,2) ELSE 1 END),2) AS cenajedn ';
 ELSE -- Dla normalnych dziele przez ilosc, chyba ze jest ona rowna zero to przez czas, a jak on jest rowny 0 to przez 1
  query=query||',round('||_koszt||'/(CASE WHEN COALESCE(knw_iloscwyk,0)<>0 THEN round(knw_iloscwyk,2) WHEN COALESCE(kwd_rbh,0)<>0 THEN round(kwd_rbh,2) ELSE 1 END),2) AS cenajedn ';
 END IF;
 --pobieram wspolczynnik do wyliczenia kosztow netto
 query=query||',pracow.p_narzutprocent AS narzutprocent,((100+pracow.p_narzutprocent)/100) AS wspnettobrutto';
 
 query=query||' FROM tr_kkwnodwykdet AS det JOIN tb_pracownicy AS pracow USING (p_idpracownika) JOIN tr_kkwnodwyk AS wyk USING (knw_idelemu) JOIN tr_kkwhead AS h ON (det.kwh_idheadu=h.kwh_idheadu) JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=det.kwe_idelemu) JOIN tr_operacjetech USING (top_idoperacji) JOIN (SELECT count(*)::numeric AS ilosc_prac, sum(kwd_rbh) AS suma_rbh, knw_idelemu FROM tr_kkwnodwykdet GROUP BY knw_idelemu) AS pracrbh  ON (wyk.knw_idelemu=pracrbh.knw_idelemu) '||q_tmp||' WHERE wyk.knw_idelemu='||idwykonania;

 IF (idwykonania_det IS NOT NULL) THEN
  query=query||' AND det.kwd_idelemu='||idwykonania_det;
 END IF;

 IF (_is_tpz=1) THEN
  query=query||' AND det.kwd_flaga&(1<<2)=(1<<2)';
 ELSE
  query=query||' AND det.kwd_flaga&(1<<2)=0';
 END IF;
 
 FOR danedopracy IN EXECUTE query
 LOOP  
  SELECT * INTO prace FROM tg_praceall WHERE pra_typeref=156 AND pra_idref=danedopracy.kwd_idelemu;
  IF (prace.pra_idpracy>0) THEN
  ---mam juz prace, uaktualniamy
   flaga=prace.pra_flaga;
   prdatastart=danedopracy.datastart;
   rbh=danedopracy.kwd_rbh;
   prdatastop=NULL;
   ---zakonczenie pracy
   IF ((danedopracy.kwd_flaga&1)=1) THEN -------pracownik zakonczyl prace
     flaga=flaga|2;
     prdatastop=danedopracy.datastop;
   END IF;
   IF ((danedopracy.kwd_flaga&1)=0) THEN  -------praca nie skonczona
     flaga=flaga&(~2);
   END IF;
  
   UPDATE tg_praceall SET pra_zaangazpracownika=danedopracy.knw_zaangazpracwykonanie, p_idpracownika=danedopracy.p_idpracownika, pra_koszt=danedopracy.koszt, pra_kosztnetto=round((CASE WHEN danedopracy.wspnettobrutto=0 THEN 0 ELSE danedopracy.koszt/danedopracy.wspnettobrutto END),2), pra_narzutprocent=danedopracy.narzutprocent, pra_ilosc=danedopracy.ilosc, pra_cenajedn=danedopracy.cenajedn, pra_rbh=rbh, pra_datastart=prdatastart, pra_datastop=prdatastop, pra_flaga=flaga WHERE pra_idpracy=prace.pra_idpracy;
  ELSE
  ---dodajemy nowa prace
   flaga=8;---praca pochodzi z produkcji
 
   prdatastop=NULL;
   ----rejestracja start-stop
   IF ((danedopracy.kwd_flaga&2)=2) THEN
     flaga=flaga|1;
   END IF;
   ---zakonczenie pracy
   IF ((danedopracy.kwd_flaga&1)=1) THEN
     flaga=flaga|2;
   END IF;
   --mamy odrazu zakonczenie pracy przy start-stop
   IF ((danedopracy.kwd_flaga&3)=3) THEN
     prdatastop=danedopracy.datastop;
   END IF;

   prdatastart=danedopracy.datastart;
   rbh=danedopracy.kwd_rbh;

   INSERT INTO tg_praceall (p_idpracownika, pra_zaangazpracownika, pra_typeref, pra_idref, pra_datastart, pra_datastop, pra_rbh, pra_ilosc, pra_koszt, pra_kosztnetto, pra_narzutprocent, pra_temat, pra_flaga,pra_cenajedn, fm_idcentrali) VALUES (danedopracy.p_idpracownika, danedopracy.knw_zaangazpracwykonanie, 156,danedopracy.kwd_idelemu,prdatastart,prdatastop,rbh,danedopracy.ilosc,danedopracy.koszt,round((CASE WHEN danedopracy.wspnettobrutto=0 THEN 0 ELSE danedopracy.koszt/danedopracy.wspnettobrutto END),2),danedopracy.narzutprocent,danedopracy.temat,flaga,danedopracy.cenajedn,danedopracy.fm_idcentrali);
  END IF;
 END LOOP;
 RETURN 1;
END;
$_$;
