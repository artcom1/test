CREATE FUNCTION oniudkhwymiaryvalues() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _deltawnwalo NUMERIC:=0;
 _deltamawalo NUMERIC:=0;
 _deltawno NUMERIC:=0;
 _deltamao NUMERIC:=0;
 _deltawnwal NUMERIC:=0;
 _deltamawal NUMERIC:=0;
 _deltawn NUMERIC:=0;
 _deltama NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  _deltawnwalo=_deltawnwalo-OLD.wmv_valuewnwal;
  _deltamawalo=_deltamawalo-OLD.wmv_valuemawal;
  _deltawno=_deltawno-OLD.wmv_valuewn;
  _deltamao=_deltamao-OLD.wmv_valuema;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  _deltawnwal=_deltawnwal+NEW.wmv_valuewnwal;
  _deltamawal=_deltamawal+NEW.wmv_valuemawal;
  _deltawn=_deltawn+NEW.wmv_valuewn;
  _deltama=_deltama+NEW.wmv_valuema;
 END IF;

 IF (TG_OP='UPDATE') THEN
  _deltawnwal=_deltawnwal+_deltawnwalo;
  _deltamawal=_deltamawal+_deltamawalo;
  _deltawn=_deltawn+_deltawno;
  _deltama=_deltama+_deltamao;
  _deltawnwalo=0;
  _deltamawalo=0;
  _deltawno=0;
  _deltamao=0;
 END IF;

 IF (TG_OP='INSERT') THEN
  NEW.mc_miesiac=(SELECT mc_miesiac FROM kh_wymiarysumvalues WHERE wmm_idsumy=NEW.wmm_idsumy);
  NEW.wmv_isbufor=(SELECT wmm_isbufor FROM kh_wymiarysumvalues WHERE wmm_idsumy=NEW.wmm_idsumy);
 END IF;

 RAISE NOTICE 'Jestem % % % % ',_deltawnwal,_deltamawal,_deltawn,_deltama;

 IF (_deltawnwalo<>0) OR (_deltamawalo<>0) OR (_deltawno<>0) OR (_deltamao<>0) THEN
  UPDATE kh_wymiarysumvalues SET 
         wmm_valuerestwnwal=wmm_valuerestwnwal-_deltawnwalo,
         wmm_valuerestmawal=wmm_valuerestmawal-_deltamawalo,
         wmm_valuerestwn=wmm_valuerestwn-_deltawno,
         wmm_valuerestma=wmm_valuerestma-_deltamao
	 WHERE wmm_idsumy=OLD.wmm_idsumy;
 END IF;

 IF (_deltawnwal<>0) OR (_deltamawal<>0) OR (_deltawn<>0) OR (_deltama<>0) THEN
  UPDATE kh_wymiarysumvalues SET 
         wmm_valuerestwnwal=wmm_valuerestwnwal-_deltawnwal,
         wmm_valuerestmawal=wmm_valuerestmawal-_deltamawal,
         wmm_valuerestwn=wmm_valuerestwn-_deltawn,
         wmm_valuerestma=wmm_valuerestma-_deltama
	 WHERE wmm_idsumy=NEW.wmm_idsumy;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
