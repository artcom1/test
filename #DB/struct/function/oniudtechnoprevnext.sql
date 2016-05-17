CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 th RECORD;
 operacja RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.th_idtechnologii=(SELECT th_idtechnologii FROM tr_technoelem WHERE the_idelem=NEW.the_idprev);
  IF (NEW.th_idtechnologii<>(SELECT th_idtechnologii FROM tr_technoelem WHERE the_idelem=NEW.the_idnext)) THEN
   RAISE EXCEPTION 'Elementy technologii nie sa w tej samej technologii';
  END IF;

  ----------------------------------------------------------------------------------------
  ---czesc do przenoszenia ilosci z operacji
  ----------------------------------------------------------------------------------------
  SELECT th_flaga INTO th FROM tr_technologie AS t WHERE t.th_idtechnologii=NEW.th_idtechnologii;
  IF (th.th_flaga&64=64) THEN
   ---mamy przenoszenie ilosci z operacji, wiec musimy ustawic odpowiednie ilosci
   -----szukamy operacji o lp wiekszym o 1 od aktulnego  
   SELECT thpn_idelem, thpn_flaga, the_idelem,the_x_licznik,the_x_mianownik,the_x_wspc  INTO operacja FROM tr_technoelem AS te LEFT JOIN tr_technoprevnext AS tpn ON (tpn.the_idprev=te.the_idelem AND tpn.thpn_flaga&8=8) WHERE te.the_idelem=NEW.the_idprev;
   IF (operacja.thpn_idelem is NULL) THEN
    ---nie mamy do tej pory relacji wiec na tworzonej relacji uzupelniamy dane z operacji
    NEW.thpn_flaga=(NEW.thpn_flaga&(~7))|(1+8); ---ustawiamy stosowne flagi na wpisie
    NEW.thpn_x_licznik=operacja.the_x_licznik;
    NEW.thpn_x_mianownik=operacja.the_x_mianownik;
    NEW.thpn_x_wspc=operacja.the_x_wspc;
   ELSE
    NEW.thpn_flaga=(NEW.thpn_flaga&(~7))|(1); ---ustawiamy stosowne flagi na wpisie
    NEW.thpn_x_licznik=0;
    NEW.thpn_x_mianownik=1;
    NEW.thpn_x_wspc=0;   
   END IF;
  END IF;
  ----------------------------------------------------------------------------------------
  ---koniec czesci do przenoszenia ilosci z operacji
  ----------------------------------------------------------------------------------------
 END IF;



 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
