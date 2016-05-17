CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in          ALIAS FOR $1;    --- Parametry wejsciowe
 pap          ALIAS FOR $2;
 s            ALIAS FOR $3;
 t_ilosclrez  ALIAS FOR $4;    --- Ilosc rezerwacji lekkich do wykorzystania
 idpartiipz   ALIAS FOR $5;    --- ID partii PZ
 stanmagrest NUMERIC;          --- Ilosc niezarezerwowanego towaru na magazynie
 t_iloscel   NUMERIC;
 tmp         NUMERIC;
 ruch_data   RECORD;
 q           TEXT;
 id          INT;
 iloscpoz    NUMERIC;
BEGIN 

 ----RAISE NOTICE 'Wchodze % % % % %',$1,$2,$3,$4,$5;

 IF (s.sim_iloscpz>0) THEN iloscpoz=s.sim_iloscpz; END IF;
 IF (s.sim_iloscrezn>0) THEN iloscpoz=s.sim_iloscrezn; END IF;
 IF (s.sim_iloscrezl>0) THEN iloscpoz=s.sim_iloscrezl; END IF;

 IF (iloscpoz=0) THEN
  RETURN 0;
 END IF;


 IF (_in IS NULL AND pap IS NULL) THEN
  iloscpoz=s.sim_iloscpz;
  IF (iloscpoz<=0) THEN RETURN 0; END IF;

  UPDATE gm.tm_simulation AS ss SET 
   sim_iloscpz=sim_iloscpz+iloscpoz
  WHERE ss.sim_sid=s.sim_sid AND 
        ss.sim_simid=s.sim_simid AND 
	ss.rc_idruchurez IS NULL AND
	ss.rc_idruchupz IS NOT DISTINCT FROM s.rc_idruchupz
  RETURNING ss.sim_id INTO id;

  IF (id IS NULL) THEN
   INSERT INTO gm.tm_simulation
    (sim_sid,sim_simid,
     rc_idruchupz,
     sim_iloscpz
    ) VALUES
    (
    s.sim_sid,s.sim_simid,
    s.rc_idruchupz,
    iloscpoz
    );
  END IF;


  RETURN 0;
 END IF;


 q=gm.dodaj_wz_querypz(_in,pap,s.rc_idruchupz IS NOT NULL,idpartiipz);

---           COALESCE(ss.sim_iloscpz+ss.sim_iloscrezl+ss.sim_iloscrezn,0) AS dod,
 ---RAISE NOTICE '\r\n%',gm.toNotice(q);
 q='SELECT qi.*,
           COALESCE(ss.sim_iloscpz+ss.sim_iloscrezl,0) AS dod,
	   COALESCE(rrez.rc_iloscrez,0) AS iloscrez,
	   COALESCE(ssr.sim_iloscrezl,0) AS iloscrezlwyk,
	   COALESCE(ssr.sim_iloscrezn,0) AS iloscreznwyk,
	   rrez.rc_flaga AS rc_flagarez
     FROM ('||q||') AS qi 
     LEFT OUTER JOIN gm.tv_simulation AS ss ON (qi.rc_idruchu=ss.rc_idruchupz AND ss.sim_sid='||s.sim_sid||' AND ss.sim_simid='||s.sim_simid||')
     LEFT OUTER JOIN tg_ruchy AS rrez ON (rrez.rc_idruchu='||gm.toString(s.rc_idruchurez)||' AND isRezerwacja(rrez.rc_flaga) AND rrez.rc_ruch IS NOT NULL)
     LEFT OUTER JOIN gm.tm_simulation AS ssr ON (qi.rc_idruchu=ssr.rc_idruchupz AND ssr.rc_idruchurez=rrez.rc_idruchu AND ssr.sim_sid='||s.sim_sid||' AND ssr.sim_simid='||s.sim_simid||')';
 FOR ruch_data IN EXECUTE q
 LOOP
  EXIT WHEN (iloscpoz<=0);

  CONTINUE WHEN (idpartiipz IS NOT NULL) AND (ruch_data.prt_idpartiipz IS DISTINCT FROM idpartiipz);
  CONTINUE WHEN (s.rc_idruchupz IS NOT NULL) AND (ruch_data.rc_idruchu IS DISTINCT FROM s.rc_idruchupz);


  ---RAISE NOTICE 'Zostalo % zuzyto % ',ruch_data.rc_zostalo,ruch_data.dod;
  ---Odejmij od tego to co w symulacji zuzyto
  t_iloscel=(ruch_data.rc_zostalo-ruch_data.dod);

  IF (ruch_data.rc_flagarez IS NOT NULL) THEN
   IF (isRezerwacja(ruch_data.rc_flagarez)=TRUE) THEN
    ---Dla rezerwacji liczymy inaczej - jako ilosc niewykorzystana
    t_iloscel=(ruch_data.iloscrez-ruch_data.iloscrezlwyk-ruch_data.iloscreznwyk);
    ---RAISE NOTICE 'Mam dla rezerwacji % ',t_iloscel;
   END IF;
  END IF;

  ----RAISE NOTICE 'Mam rekord ID:% % % (% %)',ruch_data.rc_idruchu,iloscpoz,t_iloscel,ruch_data.rc_zostalo,ruch_data.dod;

  ---min(iloscpoz,ilosc_niezarezerwowana_na_pz)
  t_iloscel=round(max(min(iloscpoz,t_iloscel),0),4);
  ----RAISE NOTICE '% % Iloscpoz % ilosclrez % biore % (%) %',ruch_data.rc_idruchu,s,iloscpoz,t_ilosclrez,t_iloscel,ruch_data.rc_zostalo,ruch_data.iloscrez;


  CONTINUE WHEN t_iloscel<=0;
  
  ---RAISE NOTICE 'Mam % % %',s,t_iloscel,ruch_data.rc_idruchu;

  ---Ilosc niezarezerwowana na partii
  stanmagrest=(SELECT ptm_stanmag-ptm_rezerwacje-ptm_rezerwacjel FROM tg_partietm WHERE ttm_idtowmag=_in.ttm_idtowmag AND prt_idpartii=ruch_data.prt_idpartiipz);
  ---Odejmij symulacje
  stanmagrest=stanmagrest-COALESCE((SELECT sum(sim_iloscpz-sim_iloscrezn-sim_iloscrezl)
                           FROM gm.tv_simulation AS ss 
			   JOIN tg_ruchy AS r ON (r.rc_idruchu=ss.rc_idruchupz)
			   WHERE r.ttm_idtowmag=_in.ttm_idtowmag AND r.prt_idpartiipz=ruch_data.prt_idpartiipz
			         AND ss.sim_sid=s.sim_sid AND ss.sim_simid=s.sim_simid),0);
  --Dodaj do stanu ilosc z aktualnej rezerwacji
  stanmagrest=stanmagrest+ruch_data.iloscrez;

  ---Minimum (iloscel,ilosc_niezarezerwowan_na_partii+zezwolenie_na_zdjecie_z_partii)
  t_iloscel=min(t_iloscel,stanmagrest+t_ilosclrez);

  CONTINUE WHEN t_iloscel<=0;

  UPDATE gm.tm_simulation AS ss SET 
   sim_iloscpz=(CASE WHEN s.sim_iloscpz>0 THEN sim_iloscpz+t_iloscel ELSE sim_iloscpz END),
   sim_iloscrezn=(CASE WHEN s.sim_iloscrezn>0 THEN sim_iloscrezn+t_iloscel ELSE sim_iloscrezn END),
   sim_iloscrezl=(CASE WHEN s.sim_iloscrezl>0 THEN sim_iloscrezl+t_iloscel ELSE sim_iloscrezl END)
  WHERE ss.sim_sid=s.sim_sid AND 
        ss.sim_simid=s.sim_simid AND 
	ss.rc_idruchurez IS NOT DISTINCT FROM s.rc_idruchurez AND 
	ss.rc_idruchupz IS NOT DISTINCT FROM ruch_data.rc_idruchu
  RETURNING ss.sim_id INTO id;

  ----RAISE NOTICE 'Dodaje do ilosci % ',t_iloscel;

  IF (id IS NULL) THEN
   INSERT INTO gm.tm_simulation
    (sim_sid,sim_simid,
     rc_idruchurez,rc_idruchupz,
     sim_iloscpz,
     sim_iloscrezn,
     sim_iloscrezl
    ) VALUES
    (
    s.sim_sid,s.sim_simid,
    s.rc_idruchurez,ruch_data.rc_idruchu,
    (CASE WHEN s.sim_iloscpz>0 THEN t_iloscel ELSE 0 END),
    (CASE WHEN s.sim_iloscrezn>0 THEN t_iloscel ELSE 0 END),
    (CASE WHEN s.sim_iloscrezl>0 THEN t_iloscel ELSE 0 END)
    );
  END IF;

  iloscpoz=round(iloscpoz-t_iloscel,4);
 END LOOP;


 RETURN iloscpoz;
END; 
$_$;
