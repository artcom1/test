CREATE FUNCTION hasosobnyrozrachunekvat(_tr_zamknieta integer, _tr_newflaga integer, _idwaluty integer) RETURNS boolean
    LANGUAGE sql
    AS $$
 SELECT (_idwaluty!=1) AND
        (
         (_tr_newflaga&(1<<23)!=0) OR   --VAT zawsze w PLNach
         (   ---Stara opcja
		  (_tr_zamknieta&(1<<29)!=0) AND    ---Osobny kurs VAT
          (_tr_zamknieta&(1<<7)=0) --Dokument od netto           
		 )
		);
$$;
