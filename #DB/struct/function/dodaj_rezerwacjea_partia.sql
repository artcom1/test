CREATE FUNCTION dodaj_rezerwacjea_partia(integer, integer, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN dodaj_rezerwacjea_partia($1,$2,$3,$4,NULL);
END;
$_$;


--
--

CREATE FUNCTION dodaj_rezerwacjea_partia(integer, integer, integer, integer, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN dodaj_rezerwacjea_partia($1,$2,$3,$4,$5,NULL);
END;
$_$;


--
--

CREATE FUNCTION dodaj_rezerwacjea_partia(integer, integer, integer, integer, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _id_te_kpz    ALIAS FOR $1;
 _id_te_pz     ALIAS FOR $2;
 _id_trans_kpz ALIAS FOR $3;
 _idtowmag     ALIAS FOR $4;
 _maxilosc     ALIAS FOR $5;
 _idruchupz    ALIAS FOR $6;
 ilosc         NUMERIC:=0;
 t_iloscel     NUMERIC;
 te            RECORD;
 ruch_data     RECORD;
 restilosc     NUMERIC;
 anychange     BOOL;
BEGIN

 restilosc=_maxilosc;

 SELECT * INTO te FROM tg_towmag WHERE ttm_idtowmag=_idtowmag;

 LOOP
  anychange=FALSE;
   
  FOR ruch_data IN SELECT rc_iloscpoz,rc_iloscrez,rc_iloscrezzr,rc_idruchu,
                          ptm.ptm_stanmag-ptm.ptm_rezerwacjel-ptm.ptm_rezerwacje AS maxi
                   FROM tg_ruchy AS r 
                   JOIN tg_partietm AS ptm ON (ptm.prt_idpartii=r.prt_idpartiipz AND ptm.ttm_idtowmag=r.ttm_idtowmag)
                   WHERE (_idruchupz IS NULL OR rc_idruchu=_idruchupz) 
		   AND tel_idelem=_id_te_pz AND isPZet(rc_flaga) 
		   AND rc_iloscpoz-(rc_iloscrez-rc_iloscrezzr)>0 
  LOOP
   IF (restilosc IS NOT NULL) THEN
    t_iloscel=min(restilosc,ruch_data.rc_iloscpoz-(ruch_data.rc_iloscrez-ruch_data.rc_iloscrezzr));
   ELSE
    t_iloscel=ruch_data.rc_iloscpoz-(ruch_data.rc_iloscrez-ruch_data.rc_iloscrezzr);
   END IF;
   t_iloscel=min(t_iloscel,ruch_data.maxi);

   IF (t_iloscel>0) THEN
    RAISE NOTICE 'Dodaje rezerwacje automatyczna';
    INSERT INTO tg_ruchy 
     (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,rc_data,rc_ilosc,rc_iloscpoz,rc_flaga,k_idklienta,rc_ruch,rc_seqid)
    VALUES
     (_id_te_kpz,_id_trans_kpz,te.ttw_idtowaru,te.ttm_idtowmag,te.tmg_idmagazynu,now(),round(t_iloscel,4),round(t_iloscel,4),1+256+512,0,ruch_data.rc_idruchu,nextval('tg_ruchy_seqid')); 

    anychange=TRUE;
    ilosc=ilosc+t_iloscel;
    restilosc=restilosc-t_iloscel;
    EXIT;
   END IF;    
  END LOOP;

  EXIT WHEN anychange=FALSE;
 END LOOP;

 RETURN ilosc;
END;
$_$;
