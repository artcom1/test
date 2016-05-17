CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelemdok  ALIAS FOR $1;
 _tel_idelemkor  ALIAS FOR $2;
 _kwc_ilosc      ALIAS FOR $3;
  
 rec_ruch RECORD;
 
 _tel_idelemsrc     INT;
 _tel_idelemdst     INT;
 _dmag_iddyspozycji INT;
BEGIN

  SELECT 
  dmag_iddyspozycji, tel_idelemsrc
  INTO rec_ruch FROM tr_ruchy 
  WHERE tel_idelemdst=_tel_idelemdok OR tel_idelemsrc=_tel_idelemdok;
  
  _tel_idelemsrc=NULL;
  _tel_idelemdst=NULL;
  
  IF (rec_ruch.tel_idelemsrc IS NOT NULL) THEN
   _tel_idelemsrc=_tel_idelemkor;
  ELSE
   _tel_idelemdst=_tel_idelemkor;
  END IF;
   
  _dmag_iddyspozycji=rec_ruch.dmag_iddyspozycji;
  
  UPDATE tr_dyspozycjamag SET dmag_flaga=dmag_flaga|(1<<8) WHERE dmag_iddyspozycji=rec_ruch.dmag_iddyspozycji;
        
  INSERT INTO tr_ruchy (dmag_iddyspozycji, tel_idelemsrc, tel_idelemdst, kwc_flaga) VALUES (_dmag_iddyspozycji, _tel_idelemsrc, _tel_idelemdst, (1<<8));

 RETURN 1;
END;
$_$;
