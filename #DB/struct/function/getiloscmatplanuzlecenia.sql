CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idmaterialu   ALIAS FOR $1; ---int
 _iloscplanu    ALIAS FOR $2; ---numeric
 _wymiar_x      ALIAS FOR $3; ---numeric
 _wymiar_y      ALIAS FOR $4; ---numeric
 _wymiar_z      ALIAS FOR $5; ---numeric
 _nadmiar_x     ALIAS FOR $6; ---numeric
 _nadmiar_y     ALIAS FOR $7; ---numeric
 _nadmiar_z     ALIAS FOR $8; ---numeric
 _narzut        ALIAS FOR $9; ---numeric

 iloscmat       NUMERIC:=0;
 iloscmat_mpq   MPQ:=0;
 przelicznik    MPQ:=0;
 dzielnik       NUMERIC:=0;
 typ            TEXT;
 typm2          TEXT;
 typwyliczenia  INT;
 x              NUMERIC:=1;
 y              NUMERIC:=1;
 z              NUMERIC:=1;
 xb             NUMERIC:=0;
 yb             NUMERIC:=0;
 zb             NUMERIC:=0;
 towar          RECORD; 
BEGIN
 ---sprawdzamy czy mamy potrzebne dane wejsciowe
 IF (_idmaterialu IS NULL OR _idmaterialu<=0) THEN
  return 0; ----brak materialu, nie robimy nic
 END IF;
 ---------------------------------------------------------------------------------------
 ---wyliczenie wspolczynnika planu do materialu
 ---------------------------------------------------------------------------------------
 typ=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='struktura_licz_mb');
 typm2=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='struktura_licz_pow');
 SELECT (ttw_newflaga&(3<<13))>>13 AS flaga, ttw_objetosc_mpq, ttw_powierzchnia_mpq, ttw_dlugosc_mpq,tmg_magazynprod  INTO towar FROM tg_towary WHERE ttw_idtowaru=_idmaterialu;
 typwyliczenia=towar.flaga;

 IF (typwyliczenia=0) THEN ---STRUKTURA_TYP_WAGI_MB
  przelicznik=towar.ttw_dlugosc_mpq;
  dzielnik=1000;
  IF (typ='0' OR typ is null) THEN --- STRUKTURA_WYL_WAGI_X
   x=_wymiar_x;
   xb=_nadmiar_x;
  END IF;
  IF (typ='1') THEN --- STRUKTURA_WYL_WAGI_Y
   x=_wymiar_y;
   xb=_nadmiar_y;
  END IF;
  IF (typ='2') THEN --- STRUKTURA_WYL_WAGI_Z
   x=_wymiar_z;
   xb=_nadmiar_z;
  END IF;
 ELSE
  IF (typwyliczenia=1) THEN ---STRUKTURA_TYP_WAGI_M2
   przelicznik=towar.ttw_powierzchnia_mpq;
   dzielnik=1000000;
   IF (typm2='0' OR typm2 is null) THEN --- STRUKTURA_WYL_POL_XY
    x=_wymiar_x;
    y=_wymiar_y;
    xb=_nadmiar_x;
    yb=_nadmiar_y;
   END IF;
   IF (typm2='1' ) THEN --- STRUKTURA_WYL_POL_YZ
    x=_wymiar_y;
    y=_wymiar_z;
    xb=_nadmiar_y;
    yb=_nadmiar_z;
   END IF;
   IF (typm2='2' ) THEN --- STRUKTURA_WYL_POL_XZ
    x=_wymiar_x;
    y=_wymiar_z;
    xb=_nadmiar_x;
    yb=_nadmiar_z;
   END IF;
  ELSE
   IF (typwyliczenia=2) THEN ----STRUKTURA_TYP_WAGI_M3
    przelicznik=towar.ttw_objetosc_mpq;
    dzielnik=1000000000;
    x=_wymiar_x;
    y=_wymiar_y;
    z=_wymiar_z;
    xb=_nadmiar_x;
    yb=_nadmiar_y;
    zb=_nadmiar_z;
    
   END IF;
  END IF;
 END IF;

 IF (przelicznik=0 OR przelicznik IS NULL) THEN
  RETURN 0;
 END IF;

 iloscmat_mpq=((x::mpq+xb)*(y+yb)*(z+zb)*((100+_narzut)/100)/przelicznik/dzielnik);
 RAISE NOTICE 'ILOSCI material(%):typ(%):iloscmat(%)=round((%+%)*(%+%)*(%+%)*((100+%)/100)/%/%,4)',_idmaterialu,typwyliczenia,iloscmat,x,xb,y,yb,z,zb,_narzut,przelicznik,dzielnik;

 iloscmat=round(_iloscplanu*iloscmat_mpq,4);
 ---zwracam wynik
 RETURN iloscmat;
END;
$_$;
