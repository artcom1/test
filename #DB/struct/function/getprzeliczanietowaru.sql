CREATE FUNCTION getprzeliczanietowaru(integer) RETURNS record
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 rec           RECORD;
 ret          TEXT;
BEGIN
 
-- ttw_newflaga:
-- 13,14 bit : rodzaj przeliczenia wagi dla elementow struktury konstrukcyjnej - w polaczeniu z bitem 29!
--             0 - liczenie wed???????????ug mb
--             1 - liczenie wed???????????ug m2
--             2 - liczenie wedlug m3
--             3 - liczenie wg przelicznika wagi 
-- 29    bit: 1 - przeliczanie Przeliczenia dla struktur, technologii, KKW: 0 - brak przeliczenia
-- 30    bit: 1 - Receptura na technologii wg. wymiar??????????w

 SELECT 
 (CASE WHEN ttw_newflaga&(1<<30)=(1<<30) THEN TRUE ELSE FALSE END) AS wymiary,
 (CASE WHEN ttw_newflaga&(1<<29)=0 THEN 0 ELSE (ttw_newflaga&(3<<13) >> 13 ) + 1 END) AS typprzeliczenia,
 ttw_dlugosc_mpq AS mb,
 ttw_powierzchnia_mpq AS m2,
 ttw_objetosc_mpq AS m3,
 ttw_waga::MPQ AS kg
 FROM tg_towary WHERE ttw_idtowaru=_ttw_idtowaru 
 INTO rec;
 	
 IF (rec.wymiary) THEN
  ret='Mam wymiary. ';
 ELSE
  ret='Nie mam wymiarow. ';
 END IF;
  
 ret=ret || 'Typ przeliczenia: ';
 
 IF (rec.typprzeliczenia=0) THEN
  ret=ret || 'BRAK';
 ELSIF (rec.typprzeliczenia=1) THEN 
  ret=ret || 'Dlugosc [mb]';
  ret=ret || '(Przelicznik=' || rec.mb::text || ')';
 ELSIF (rec.typprzeliczenia=2) THEN 
  ret=ret || 'Powierzchnia [m2]';
  ret=ret || '(Przelicznik=' || rec.m2::text || ')';
 ELSIF (rec.typprzeliczenia=3) THEN 
  ret=ret || 'Objetosc [m3]';
  ret=ret || '(Przelicznik=' || rec.m3::text || ')';
 ELSE
  ret=ret || 'Waga [kg]';
  ret=ret || '(Przelicznik=' || rec.kg::text || ')';
 END IF;

 RAISE NOTICE 'getPrzeliczanieTowaru: %',ret;
 
 RETURN rec;
END;
$_$;
