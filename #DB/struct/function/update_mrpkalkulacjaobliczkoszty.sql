CREATE FUNCTION update_mrpkalkulacjaobliczkoszty(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii ALIAS FOR $1;
 kalk_ilosc  NUMERIC:=0;
 koszty_mat  NUMERIC:=0;
 koszty_narz NUMERIC:=0;
 koszty_inne NUMERIC:=0;
 rec RECORD;
BEGIN
 kalk_ilosc=(SELECT th_optpartia FROM tr_technologie AS th WHERE th.th_idtechnologii=_th_idtechnologii AND th.th_rodzaj=4);
 IF (COALESCE(kalk_ilosc,0)=0) THEN
  RETURN 0;
 END IF;
 
 koszty_mat=mrpkalkulacjaobliczkoszty_mat(_th_idtechnologii,kalk_ilosc);
 koszty_narz=mrpkalkulacjaobliczkoszty_narz(_th_idtechnologii,kalk_ilosc);
 koszty_inne=mrpkalkulacjaobliczkoszty_inne(_th_idtechnologii,kalk_ilosc);
 
 SELECT
 sum(COALESCE((CASE WHEN the.the_nodtype=0 THEN (((kalk_ilosc/the.the_wydajnosc)*the.the_tpj)+the.the_tpz)*((the.the_kosztnah+the.the_kosztstannah)/60)+the.the_kosztnaj*kalk_ilosc ELSE 0 END),0)) AS robocizna,
 sum(COALESCE((CASE WHEN the.the_nodtype=0 THEN ((((kalk_ilosc/the.the_wydajnosc)*the.the_tpj)+the.the_tpz)*((the.the_kosztnah+the.the_kosztstannah)/60)+the.the_kosztnaj*kalk_ilosc)*(the.the_narzutwydzialowy)/100 ELSE 0 END),0)) AS wydzialowe,
 sum(COALESCE((CASE WHEN the.the_nodtype=1 THEN the.the_kosztnaj*kalk_ilosc ELSE 0 END),0)) AS obce
 INTO rec
 FROM tr_technoelem AS the
 WHERE 
 the.th_idtechnologii=_th_idtechnologii;
  
 UPDATE tr_mrpkalkulacje SET 
 kalk_koszt_robocizna=COALESCE(rec.robocizna,0),
 kalk_koszt_obrobkaobca=COALESCE(rec.obce,0),
 kalk_koszt_wydzialowe=COALESCE(rec.wydzialowe,0),
 kalk_koszt_materialy=COALESCE(koszty_mat,0),
 kalk_koszt_narzedzia=COALESCE(koszty_narz,0),
 kalk_koszt_inne=COALESCE(koszty_inne,0)
 WHERE 
 th_idtechnologii=_th_idtechnologii; 
 
 RETURN 1;
END;
$_$;
