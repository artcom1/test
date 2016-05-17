CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP!='DELETE') THEN
 
  IF ((NEW.ttw_new2flaga&(1<<1))!=0) THEN
   NEW.ttw_rtowaru=(1<<8);  ---Pseudotowar
  ELSIF ((NEW.ttw_new2flaga&(1<<0))!=0) THEN
   NEW.ttw_rtowaru=(1<<7);  ---Rozmiarowka
  ELSIF ((NEW.ttw_flaga&(1<<19))!=0) THEN
   NEW.ttw_rtowaru=(1<<5);  ---Bilet
  ELSIF ((NEW.ttw_flaga&(1<<18))!=0) THEN
   NEW.ttw_rtowaru=(1<<4);  ---Zestaw
  ELSIF ((NEW.ttw_flaga&(1<<13))!=0) THEN
   NEW.ttw_rtowaru=(1<<6);  ---Czynnosc
  ELSIF ((NEW.ttw_flaga&(1<<4))!=0) THEN
   NEW.ttw_rtowaru=(1<<3);  ---TK
  ELSIF ((NEW.ttw_flaga&(1<<2))!=0) THEN
   NEW.ttw_rtowaru=(1<<2);  ---Koszt
  ELSIF (NEW.ttw_usluga=FALSE) THEN
   NEW.ttw_rtowaru=(1<<0);  ---Towar
  ELSE 
   NEW.ttw_rtowaru=(1<<1);  ---Usluga
  END IF;
  
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END
$$;
