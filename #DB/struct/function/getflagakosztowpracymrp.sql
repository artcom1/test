CREATE FUNCTION getflagakosztowpracymrp() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret INT:=0;
 _koszt_flaga INT;
 
 _koszt_ilosc TEXT:='0';
 _koszt_czas TEXT:='0';
 _koszt_czas_pracownik TEXT:='0';
 _koszt_czas_pracownik_z_zaangaz TEXT:='0';
 _koszt_czas_stanowisko TEXT:='0'; 
BEGIN
  _koszt_flaga=vendo.gettparami('mrp_skp_koszt_flaga',NULL);   
  IF (_koszt_flaga IS NOT NULL) THEN
   RETURN _koszt_flaga;
  END IF;
  
 _koszt_ilosc=vendo.getconfigvalue('mrp_skp_koszt_ilosc');
 _koszt_czas=vendo.getconfigvalue('mrp_skp_koszt_czas_operacja');
 _koszt_czas_pracownik=vendo.getconfigvalue('mrp_skp_koszt_czas_pracownik');
 _koszt_czas_pracownik_z_zaangaz=vendo.getconfigvalue('mrp_skp_koszt_czas_pracownik_z_zaangaz');
 _koszt_czas_stanowisko=vendo.getconfigvalue('mrp_skp_koszt_czas_stanowisko');
 
 IF (_koszt_ilosc='1') THEN
  ret=ret+(1<<0);
 END IF;
 
 IF (_koszt_czas='1') THEN
  ret=ret+(1<<1);
 END IF;
 
 IF (_koszt_czas_pracownik='1') THEN
  ret=ret+(1<<2);
 END IF;
 
 IF ((_koszt_czas_pracownik='1' OR _koszt_czas='1') AND _koszt_czas_pracownik_z_zaangaz='1') THEN
  ret=ret+(1<<3);
 END IF;
 
 IF (_koszt_czas_stanowisko='1') THEN
  ret=ret+(1<<4);
 END IF;
  
 PERFORM vendo.settparami('mrp_skp_koszt_flaga',ret);
 RETURN ret;
END;
$$;
