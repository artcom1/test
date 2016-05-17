CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tmp NUMERIC;
BEGIN

 IF ($2=TRUE) THEN
  UPDATE kr_rozrachunki SET rr_flaga=rr_flaga|8 WHERE rr_idrozrachunku=$1;
  UPDATE kr_rozrachunki SET rr_flaga=rr_flaga&(~(1<<21)) WHERE rr_flaga&7=5 AND rr_idrozrachunku=$1;
 ELSE
  UPDATE kr_rozrachunki SET rr_flaga=rr_flaga&(~8) WHERE rr_idrozrachunku=$1;    

  --- Kompensaty na platnosciach
  UPDATE kh_platnosci SET 
   pl_saldokomp=max(
                 nullZero((SELECT sum(rr_kwotawal-rr_wartoscpozwal) FROM kr_rozrachunki AS ri WHERE rr_flaga&7=5 AND rr_iswn=TRUE AND ri.pl_idplatnosc=kh_platnosci.pl_idplatnosc)),
		 -nullZero((SELECT sum(rr_kwotawal-rr_wartoscpozwal) FROM kr_rozrachunki AS ri WHERE rr_flaga&7=5 AND rr_iswn=FALSE AND ri.pl_idplatnosc=kh_platnosci.pl_idplatnosc))
		)
  WHERE pl_idplatnosc=(SELECT pl_idplatnosc FROM kr_rozrachunki WHERE rr_idrozrachunku=$1 AND rr_flaga&7=5) AND 
   pl_saldokomp<>max(
                 nullZero((SELECT sum(rr_kwotawal-rr_wartoscpozwal) FROM kr_rozrachunki AS ri WHERE rr_flaga&7=5 AND rr_iswn=TRUE AND ri.pl_idplatnosc=kh_platnosci.pl_idplatnosc)),
		 -nullZero((SELECT sum(rr_kwotawal-rr_wartoscpozwal) FROM kr_rozrachunki AS ri WHERE rr_flaga&7=5 AND rr_iswn=FALSE AND ri.pl_idplatnosc=kh_platnosci.pl_idplatnosc))
		);
  UPDATE kr_rozrachunki SET rr_flaga=rr_flaga|(1<<21) WHERE rr_flaga&7=5 AND rr_idrozrachunku=$1;
 END IF;

 RETURN TRUE;
END
$_$;
