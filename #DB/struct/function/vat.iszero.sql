CREATE FUNCTION iszero(tb_vat) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT  ($1.v_netnetto=0) AND
         ($1.v_netvatn=0) AND
         ($1.v_netvatb=0) AND
         ($1.v_netbrutto=0) AND
 --------------------------------------
         ($1.v_nettokgo=0) AND
         ($1.v_vatkgon=0) AND
         ($1.v_vatkgob=0) AND
         ($1.v_bruttokgo=0) AND
 --------------------------------------
         ($1.v_netto=0) AND
         ($1.v_vatn=0) AND
         ($1.v_vatb=0) AND
         ($1.v_brutto=0) AND
 --------------------------------------
         ($1.v_iloscpoz=0) AND
         ($1.v_ilosc0cena=0) AND
         ($1.v_iloscwyd=0) AND
         ($1.v_iloscpozusl=0);
$_$;
