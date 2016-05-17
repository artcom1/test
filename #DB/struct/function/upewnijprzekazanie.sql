CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _src_te  ALIAS FOR $1;
 _src_kwe ALIAS FOR $2;
 _dst_kwh ALIAS FOR $3;
 _ilosc   ALIAS FOR $4;
 _typ     ALIAS FOR $5;
 r        RECORD;
BEGIN

 SELECT kwr_idruchu,kwr_flaga,kwr_ilosc INTO r FROM tp_ruchy WHERE nullZero(kwr_etapsrc)=nullZero(_src_kwe) AND nullZero(kwr_etapdst)=0 AND nullZero(tel_idelemsrc)=nullZero(_src_te) AND nullZero(tel_idelemdst)=0 AND nullZero(kwh_idheadudst)=nullZero(_dst_kwh) AND TPisTyp(kwr_flaga,_typ);
 IF NOT FOUND THEN
  IF (_ilosc=0) THEN
   RETURN NULL;
  END IF;
  INSERT INTO tp_ruchy
   (kwr_flaga,kwr_etapsrc,kwr_etapdst,tel_idelemsrc,tel_idelemdst,kwh_idheadudst,kwr_ilosc)
  VALUES
   (_typ&(7+16),_src_kwe,NULL,_src_te,NULL,_dst_kwh,_ilosc);
  RETURN currval('tp_ruchy_s');
 ELSE
  IF (_ilosc=0) THEN
   DELETE FROM tp_ruchy WHERE kwr_idruchu=r.kwr_idruchu;
   RETURN NULL;
  ELSE
   UPDATE tp_ruchy SET kwr_ilosc=vit((_typ&8)<>0,kwr_ilosc)+_ilosc WHERE kwr_idruchu=r.kwr_idruchu AND kwr_ilosc<>(vit((_typ&8)<>0,kwr_ilosc)+_ilosc);
   RETURN r.kwr_idruchu;
  END IF;
 END IF;

END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _src_te  ALIAS FOR $1;
 _src_kwe ALIAS FOR $2;
 _dst_te  ALIAS FOR $3;
 _dst_kwe ALIAS FOR $4;
 _ilosc   ALIAS FOR $5;
 _typ     ALIAS FOR $6;
 r        RECORD;
BEGIN

 SELECT kwr_idruchu,kwr_flaga,kwr_ilosc INTO r FROM tp_ruchy WHERE nullZero(kwr_etapsrc)=nullZero(_src_kwe) AND nullZero(kwr_etapdst)=nullZero(_dst_kwe) AND nullZero(tel_idelemsrc)=nullZero(_src_te) AND nullZero(tel_idelemdst)=nullZero(_dst_te) AND nullZero(kwh_idheadudst)=0 AND TPisTyp(kwr_flaga,_typ);
 IF NOT FOUND THEN
  IF (_ilosc=0 AND _typ&(16)=0) THEN
   RETURN NULL;
  END IF;
  INSERT INTO tp_ruchy
   (kwr_flaga,kwr_etapsrc,kwr_etapdst,tel_idelemsrc,tel_idelemdst,kwr_ilosc)
  VALUES
   (_typ&(7+16),_src_kwe,_dst_kwe,_src_te,_dst_te,_ilosc);
  RETURN currval('tp_ruchy_s');
 ELSE
  IF (_ilosc=0 AND _typ&(16)=0) THEN
   DELETE FROM tp_ruchy WHERE kwr_idruchu=r.kwr_idruchu;
   RETURN NULL;
  ELSE
   UPDATE tp_ruchy SET kwr_ilosc=vit((_typ&8)<>0,kwr_ilosc)+_ilosc WHERE kwr_idruchu=r.kwr_idruchu AND kwr_ilosc<>(vit((_typ&8)<>0,kwr_ilosc)+_ilosc);
   RETURN r.kwr_idruchu;
  END IF;
 END IF;
END;
$_$;
