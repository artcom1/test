CREATE FUNCTION oznaczruchn(oznid bigint, ruchid integer, domark boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
---- Funkcja oznacza lub odznacza (w zaleznosci od parametru domark) podany w ruchid ruch dla SETID=oznid
BEGIN

 IF (domark=TRUE) THEN
 
  IF (gm.isAnyOznaczonyRuchN(oznid)=FALSE) THEN
   RAISE EXCEPTION 'Nie ustawiono flagi mozliwosci oznaczania ruchu o SETID=%',oznid;
  END IF;
    
  INSERT INTO tm_oznaczoneruchy
   (ozr_setid,rc_idruchu)
   SELECT oznid,ruchid 
   WHERE NOT EXISTS (SELECT ozr_id FROM tm_oznaczoneruchy WHERE ozr_setid=oznid AND rc_idruchu=ruchid LIMIT 1) AND
         ( 
		  (gm.prevOznaczRuchN()<0) OR EXISTS
		  (
		   SELECT ozr_id FROM tm_oznaczoneruchy WHERE ozr_setid=gm.prevOznaczRuchN(oznid) AND rc_idruchu=ruchid LIMIT 1
		  ) OR
		  (vendo.getTParamI('ANYOZNACZONYRUCH_IGNOREPREV_'||oznid,0)>0)
		 );
 ELSE 
  DELETE FROM tm_oznaczoneruchy WHERE ozr_setid=oznid AND rc_idruchu=ruchid;
 END IF;
    
 ---Zrob oznaczenie na dzieciach
 PERFORM gm.oznaczruchn(oznid,rc_idruchu_child,domark) FROM gm.tm_childs WHERE gcl_sessionid=vendo.initmysession() AND rc_idruchu_parent=ruchid;
  
 RETURN TRUE;
END;
$$;
