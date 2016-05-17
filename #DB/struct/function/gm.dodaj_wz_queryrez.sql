CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in          ALIAS FOR $1;
 pap          ALIAS FOR $2;
 _withrl      ALIAS FOR $3;
 q TEXT;
BEGIN
  ---SELECT
  q='SELECT r.rc_ilosc,r.rc_iloscpoz,r.rc_iloscrez,r.rc_cenajedn,r.rc_idruchu,r.rc_ruch,r.rc_flaga,r.prt_idpartiipz ';
  ---Opcjonalnie podaj ilosc rezerwacji lekkich
  IF (_withrl=TRUE) THEN q=q||',(CASE WHEN r.rc_ruch IS NULL THEN r.rc_iloscrez ELSE 0 END) AS rc_iloscrezl '; END IF;
  ---tg_ruchy
  q=q||'FROM tg_ruchy AS r ';
  ---Dla rezerwacji lekkich LEFT JOIN z informacjami z PZ
  IF (_withrl=TRUE) THEN q=q||'LEFT OUTER '; END IF;
  ---Dolacz PZ
  q=q||'JOIN tg_ruchy AS pz ON (r.rc_ruch=pz.rc_idruchu) ';
  ---Dolacz informacje o partii PZ
  q=q||'LEFT OUTER JOIN tg_partie AS ppz ON (COALESCE(pz.prt_idpartiipz,r.prt_idpartiipz)=ppz.prt_idpartii) ';
  q=q||'LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) ';
  ---Towar/TowMag
  IF (_in.ttm_idtowmag IS NOT NULL) THEN
   q=q||'WHERE r.ttm_idtowmag='||_in.ttm_idtowmag||' AND ';
  ELSE
   q=q||' JOIN tg_magazyny AS mg ON (mg.tmg_idmagazynu=pz.tmg_idmagazynu) ';
   q=q||'WHERE r.ttw_idtowaru='||_in.ttw_idtowaru||' AND mg.fm_idcentrali=COALESCE('||gm.toString(_in.fm_idcentrali)||',vendo.getIDCentrali()) AND ';
   
  END IF;
  ---ID klienta
  ---Rezerwacja
  ---Cos zarezerwowane
  ---Bez transelemu lub transelemy sie zgadzaja
  ---Bez texa lub texy sie zgadzaja
  ---Wskazanie
  ---Rezerwacje lekkie lub PZet
  ---Zgadzaja sie partie
  q=q||' (r.k_idklienta='||COALESCE(_in.tel_oidklienta,_in.k_idklienta,-1)||' OR (r.tel_idelem IS NOT NULL AND ('||gm.toString('r.tel_idelem',_in.rez_idelem)||' OR '||gm.toString('r.tel_idelem',_in.rez_idelem2)||'))) AND 
	 isRezerwacja(r.rc_flaga) AND 
	 (r.rc_iloscrez>0) AND 
	 (r.tel_idelem=NULL OR 
	  '||gm.toString('r.tel_idelem',_in.rez_idelem)||' OR 
	  '||gm.toString('r.tel_idelem',_in.rez_idelem2)||' OR
	  ('||gm.toString(_in.tex_idelem)||' IS NOT NULL AND r.tex_idelem IS NULL AND r.tel_idelem='||gm.toString(_in.tel_idelem)||')
	  ) AND 
	 (NOT '||_in._pominrez||' OR ozn.rc_idruchu IS NOT NULL)
	 '||gm.getWhereClause('ppz',pap,_in.ttw_whereparams)||'
     ORDER BY (ozn.rc_idruchu IS NOT NULL) DESC,pz.rc_flaga&(1<<29) DESC,pz.rc_idruchu IS NOT NULL DESC,    
              gm.comparePartie(ppz,'||vendo.record2string(pap)||'::tg_partie,'||_in.ttw_whereparams||') DESC,
           r.rc_seqid ASC,r.rc_idruchu ASC';

		   
 RETURN q;
END
$_$;
