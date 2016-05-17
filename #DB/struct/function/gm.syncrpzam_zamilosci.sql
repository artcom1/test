CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 UPDATE tg_realizacjapzam 
 SET rm_iloscf=_ilosc,
     rm_iloscfnadmiar=_nadmiar 
 WHERE (tel_idelemsrc=_idelem) AND   --- Transelem
       (rm_flaga&(1<<13)<>0) AND     --- Oznaczony bit synchronizacji
	   (((rm_flaga>>4)&(1|2|4|8))=_what) AND
	   ((rm_iloscf<>_ilosc) OR (rm_iloscfnadmiar!=_nadmiar));  ---- Zmiana ilosci

 RETURN NULL;
END;
$$;
