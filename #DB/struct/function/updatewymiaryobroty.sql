CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kt_idkonta ALIAS FOR $1;
 _wme_idelemu ALIAS FOR $2;
 _mc_miesiac ALIAS FOR $3;
 _deltawn ALIAS FOR $4;
 _deltama ALIAS FOR $5;
 _isbufor ALIAS FOR $6;
 ret INT;
BEGIN
 
 ret=(SELECT wmo_idobrotu FROM kh_wymiaryobroty WHERE kt_idkonta=_kt_idkonta AND wme_idelemu=_wme_idelemu AND COALESCE(mc_miesiac,-1)=COALESCE(_mc_miesiac,-1));
 IF (ret IS NULL) THEN

  INSERT INTO kh_wymiaryobroty
            (ro_idroku,kt_idkonta,ktn_idkonta,wms_idwymiaru,wme_idelemu,mc_miesiac,wmo_sumwn,wmo_summa,wmo_sumwnbuf,wmo_summabuf)
	 VALUES
	   (
	    (SELECT ro_idroku FROM kh_konta WHERE kt_idkonta=_kt_idkonta),
	    _kt_idkonta,
	    (SELECT ktn_idkonta FROM kh_konta WHERE kt_idkonta=_kt_idkonta),
	    (SELECT wms_idwymiaru FROM kh_wymiaryelems WHERE wme_idelemu=_wme_idelemu),
	    _wme_idelemu,
	    _mc_miesiac,
	    (CASE WHEN _isbufor=TRUE THEN 0 ELSE _deltawn END),
	    (CASE WHEN _isbufor=TRUE THEN 0 ELSE _deltama END),
	    (CASE WHEN _isbufor=FALSE THEN 0 ELSE _deltawn END),
	    (CASE WHEN _isbufor=FALSE THEN 0 ELSE _deltama END)
	   );
  return currval('kh_wymiaryobroty_s');
 END IF;

 UPDATE kh_wymiaryobroty SET wmo_sumwn=wmo_sumwn+(CASE WHEN _isbufor=TRUE THEN 0 ELSE _deltawn END),
                             wmo_summa=wmo_summa+(CASE WHEN _isbufor=TRUE THEN 0 ELSE _deltama END),
                             wmo_sumwnbuf=wmo_sumwnbuf+(CASE WHEN _isbufor=FALSE THEN 0 ELSE _deltawn END),
                             wmo_summabuf=wmo_summabuf+(CASE WHEN _isbufor=FALSE THEN 0 ELSE _deltama END)
			 WHERE wmo_idobrotu=ret;

 RETURN ret;
END;
$_$;
