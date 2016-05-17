CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN

 IF ((_method>>8)!=0) THEN
   RETURN ' LEFT OUTER JOIN tg_stanytowmagazyn AS '||_tablealias||'stm ON ('||_tablealias||'stm.ttw_idtowaru='||_tablealias||'.ttw_idtowaru AND '||_tablealias||'stm.tmg_idmagazynu='||_tablealias||'.tmg_idmagazynu) ';
 END IF;
 
 RETURN '';
END; 
$$;
