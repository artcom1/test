CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 dnettoo  NUMERIC:=0;
 dvato    NUMERIC:=0;
 dbruttoo NUMERIC:=0;
 dnetton  NUMERIC:=0;
 dvatn    NUMERIC:=0;
 dbrutton NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.vz_refid IS NOT NULL) THEN
   dnettoo=dnettoo-OLD.vz_netto;
   dvato=dvato-OLD.vz_vat;
   dbruttoo=dbruttoo-OLD.vz_brutto;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.vz_refid IS NOT NULL) THEN
   dnetton=dnetton+NEW.vz_netto;
   dvatn=dvatn+NEW.vz_vat;
   dbrutton=dbrutton+NEW.vz_brutto;
  END IF;
 END IF;


 IF (TG_OP='UPDATE') THEN
  IF (NEW.vz_refid=OLD.vz_refid) THEN
   dnetton=dnetton+dnettoo;
   dvatn=dvatn+dvato;
   dbrutton=dbrutton+dbruttoo;
   dnettoo=0;
   dvato=0;
   dbruttoo=0;
  END IF;
  IF ( 
      abs(NEW.vz_nettoroz)>abs(NEW.vz_netto) OR abs(NEW.vz_vatroz)>abs(NEW.vz_vat) OR abs(NEW.vz_bruttoroz)>abs(NEW.vz_brutto) OR
      NEW.vz_nettoroz*NEW.vz_netto>0 OR NEW.vz_vatroz*NEW.vz_vat>0 OR NEW.vz_bruttoroz*NEW.vz_brutto>0
     ) 
  THEN
   dvatn=abs(NEW.vz_bruttoroz+NEW.vz_brutto);
   RAISE EXCEPTION '29|%:%:%|Bledne rozliczenie VAT zaliczkowe (o % brutto) % %',dvatn,NEW.vz_stawkavat,NEW.vz_flagazw,dvatn,NEW.vz_bruttoroz,NEW.vz_brutto;
  END IF;
 END IF;

 IF (dnettoo<>0 OR dvato<>0 OR dbruttoo<>0) THEN
  UPDATE tb_vatzal SET vz_nettoroz=vz_nettoroz+dnettoo,vz_vatroz=vz_vatroz+dvato,vz_bruttoroz=vz_bruttoroz+dbruttoo WHERE vz_id=OLD.vz_refid;
 END IF;

 IF (dnetton<>0 OR dvatn<>0 OR dbrutton<>0) THEN
  UPDATE tb_vatzal SET vz_nettoroz=vz_nettoroz+dnetton,vz_vatroz=vz_vatroz+dvatn,vz_bruttoroz=vz_bruttoroz+dbrutton WHERE vz_id=NEW.vz_refid;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
