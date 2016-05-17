CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 return getworktime($1,$2,$3,1);
 END
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _od_czasu      ALIAS FOR $1;
 _do_czasu      ALIAS FOR $2;
 _ob_idobiektu  ALIAS FOR $3;
 _typ_czasu     ALIAS for $4; ----0 - wszystkie, 1 -- planowany, 2 ---nieplanowany
 _w_idwydzialu  INT;
 r              RECORD;
 od_czasu       TIMESTAMP;
 do_czasu       TIMESTAMP;
 begin_d        TIMESTAMP;
 end_d          TIMESTAMP;
 max_right      TIMESTAMP;
 ret            INT;
 _hm_typ_txt       TEXT;
 _query            TEXT;
 _ob_idobiektu_txt TEXT;
 _w_idwydzialu_txt TEXT;
BEGIN

 IF (_typ_czasu=0) THEN
  _hm_typ_txt=' IN (0,3) ';
 END IF;
 
 IF (_typ_czasu=1) THEN
  _hm_typ_txt=' IN (0) ';
 END IF;
 
 IF (_typ_czasu=2) THEN
  _hm_typ_txt=' IN (3) ';
 END IF;

  _w_idwydzialu=(SELECT w_idwydzialu FROM tg_obiekty WHERE ob_idobiektu=_ob_idobiektu);
 od_czasu=_od_czasu;
 do_czasu=_do_czasu;
 max_right=od_czasu;

 ret=getMinutesFromSpan(do_czasu-od_czasu);
 
 _ob_idobiektu_txt=_ob_idobiektu::TEXT;
 IF (_ob_idobiektu IS NULL) THEN
  _ob_idobiektu_txt='NULL';
 END IF;
 
 _w_idwydzialu_txt=_w_idwydzialu::TEXT;
 IF (_w_idwydzialu IS NULL) THEN
  _w_idwydzialu_txt='NULL';
 END IF;
 
 _query='SELECT * FROM tr_harmonogram WHERE 
 (hm_odczasu,COALESCE(hm_doczasu,now())) OVERLAPS ('''|| od_czasu ||'''::TIMESTAMP,'''|| do_czasu ||'''::TIMESTAMP) AND 
         ( (ob_idobiektu='|| _ob_idobiektu_txt ||') OR (w_idwydzialu='|| _w_idwydzialu_txt ||' AND ob_idobiektu IS NULL) OR (w_idwydzialu IS NULL AND ob_idobiektu IS NULL) ) AND 
 hm_typ '|| _hm_typ_txt ||' ORDER BY hm_odczasu ASC';
 
 FOR r IN EXECUTE _query
 LOOP  
  begin_d=max(max_right,r.hm_odczasu);
  end_d=min(r.hm_doczasu,do_czasu);
  IF (begin_d<end_d) THEN
   RAISE NOTICE 'Wolny czas [Typ:%] od % do % ',_typ_czasu,begin_d,end_d;
   ret=ret-getMinutesFromSpan(end_d-begin_d);
   max_right=end_d;
  END IF;  
 END LOOP;

 RETURN ret;
END
$_$;
