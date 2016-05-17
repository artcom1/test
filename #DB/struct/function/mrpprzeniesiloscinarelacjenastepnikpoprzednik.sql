CREATE FUNCTION mrpprzeniesiloscinarelacjenastepnikpoprzednik(integer, integer, numeric, numeric, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii ALIAS FOR $1;
 _the_idelem ALIAS FOR $2;
 _the_x_licznik ALIAS FOR $3;
 _the_x_mianownik ALIAS FOR $4;
 _the_x_wspc ALIAS FOR $5;
 _thpn_idelem INT;
BEGIN
 ----szukamy relacji do aktualizacji
 _thpn_idelem=(SELECT thpn_idelem FROM tr_technoprevnext AS rpn JOIN tr_technoelem AS te ON (te.the_idelem=rpn.the_idnext) WHERE the_idprev=_the_idelem ORDER BY the_lp ASC LIMIT 1);
 IF (_thpn_idelem is NULL) THEN
  return NULL; ----nie ma relacji wychodzimy
 END IF;
 
 ---ustawiamy na znalezionej relacji dane z operacji
 UPDATE tr_technoprevnext SET thpn_flaga=(thpn_flaga&(~7))|1|8 ,thpn_x_licznik=_the_x_licznik, thpn_x_mianownik=_the_x_mianownik,thpn_x_wspc=_the_x_wspc WHERE thpn_idelem=_thpn_idelem;
 ---jak beda jakies jeszcze inne relacje to je wyzerowujemy
 UPDATE tr_technoprevnext SET thpn_flaga=(thpn_flaga&(~(7+8)))|1 ,thpn_x_licznik=0, thpn_x_mianownik=1,thpn_x_wspc=0 WHERE the_idprev=_the_idelem AND thpn_idelem!=_thpn_idelem;

 return _thpn_idelem;
END;
$_$;
