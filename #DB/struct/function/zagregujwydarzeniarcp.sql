CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pracownik ALIAS FOR $1;
 datarcp ALIAS FOR $2;
 finalize ALIAS FOR $3;
 dataporcp DATE;
 wydrec RECORD;
 czas_firma INTERVAL := 0;
 czas_sluzba INTERVAL := 0;
 czas_przerwa INTERVAL := 0;
 czas_wolny INTERVAL;
 last_typ INTEGER := 0;
 last_czas TIMESTAMP;
 czas_wejscia TIMESTAMP = NULL;
 czas_wyjscia TIMESTAMP = NULL;
 oldagg RECORD;
 last_work INTEGER := 0;
BEGIN
 FOR wydrec IN
 SELECT rcpa_ostatni_tryb AS rcp_typwydarzenia, rcpa_ostatni_klik AS rcp_czaswydarzenia, true AS isreal FROM tb_rcp_agregacja WHERE p_idpracownika=pracownik AND rcpa_ostatni_klik=datarcp
 UNION
SELECT rcp_typwydarzenia, rcp_czaswydarzenia, true AS isreal FROM tb_rcp_wydarzenia WHERE p_idpracownika=pracownik AND rcp_czaswydarzenia::date=datarcp
UNION
SELECT 2 AS rcp_typwydarzenia, (datarcp+1) AS rcp_czaswydarzenia, false AS isreal WHERE finalize
    ORDER BY rcp_czaswydarzenia ASC
 LOOP
--zapamietuj czasy pierwszego wejscia i ostatniego wyjscia
IF wydrec.rcp_typwydarzenia=1 THEN
	czas_wejscia=COALESCE(czas_wejscia, wydrec.rcp_czaswydarzenia);
ELSE
	czas_wyjscia=wydrec.rcp_czaswydarzenia;
END IF;

IF last_typ=1 THEN
	--bylo wejscie: dodaj czas w firmie
	czas_firma=czas_firma+(wydrec.rcp_czaswydarzenia-last_czas);
ELSIF last_typ=2 THEN
	--byl koniec pracy
	IF wydrec.rcp_typwydarzenia=2 THEN
		IF last_work=1 THEN
			czas_firma=czas_firma+(wydrec.rcp_czaswydarzenia-last_czas);
		ELSIF last_work=3 THEN
			czas_sluzba=czas_sluzba+(wydrec.rcp_czaswydarzenia-last_czas);
		ELSIF last_work=4 THEN
			czas_przerwa=czas_przerwa+(wydrec.rcp_czaswydarzenia-last_czas);
		END IF;
	END IF;
ELSIF last_typ=3 THEN
	--bylo wyjscie sluzbowe
	IF wydrec.rcp_typwydarzenia=3 THEN
		IF last_work=1 THEN
			czas_firma=czas_firma+(wydrec.rcp_czaswydarzenia-last_czas);
		ELSIF last_work=4 THEN
			czas_przerwa=czas_przerwa+(wydrec.rcp_czaswydarzenia-last_czas);
		END IF;
	ELSE
		czas_sluzba=czas_sluzba+(wydrec.rcp_czaswydarzenia-last_czas);
	END IF;
ELSIF last_typ=4 THEN
	--bylo wyjscie prywatne: dodaj czas na przerwie
	IF wydrec.rcp_typwydarzenia=4 THEN
		IF last_work=1 THEN
			czas_firma=czas_firma+(wydrec.rcp_czaswydarzenia-last_czas);
		ELSIF last_work=3 THEN
			czas_sluzba=czas_sluzba+(wydrec.rcp_czaswydarzenia-last_czas);
		END IF;
	ELSE
		czas_przerwa=czas_przerwa+(wydrec.rcp_czaswydarzenia-last_czas);
	END IF;
END IF; 

IF (last_typ<>0) AND (last_typ<>2) AND (last_work<>last_typ) THEN
	last_work=last_typ;
END IF;

--zapamietaj czas i rodzaj tego zdarzenia
last_czas=wydrec.rcp_czaswydarzenia;
IF wydrec.isreal THEN
	last_typ=wydrec.rcp_typwydarzenia;
END IF;
 END LOOP;

 SELECT rcpa_idagregacji, (rcpa_flaga&1)::boolean AS flaga INTO oldagg FROM tb_rcp_agregacja WHERE rcpa_data=datarcp AND p_idpracownika=pracownik;

 IF finalize IS NULL THEN
	finalize = oldagg.flaga;
 END IF;
 IF finalize IS NULL THEN
	finalize = false;
 END IF;

 --dla kompletnosci wylicze czas wolny
 IF finalize THEN
	czas_wolny = '24:00:00'::interval-(czas_firma+czas_sluzba+czas_przerwa);
 ELSE
	czas_wolny = (last_czas-datarcp)-(czas_firma+czas_sluzba+czas_przerwa);
 END IF;

 --zapisz wyliczenia
 IF (oldagg.rcpa_idagregacji=NULL)
 THEN
INSERT INTO tb_rcp_agregacja(
p_idpracownika, 
rcpa_data, 
rcpa_sumy_czasu, 
rcpa_ostatni_tryb,
rcpa_ostatni_klik,
rcpa_wejscie,
rcpa_wyjscie,
rcpa_zmiana,
rcpa_flaga)
VALUES(
pracownik, 
datarcp, 
ARRAY[czas_firma, czas_wolny, czas_sluzba, czas_przerwa],
last_typ,
last_czas,
czas_wejscia,
czas_wyjscia,
1,
finalize::integer);
 ELSE
UPDATE tb_rcp_agregacja SET
rcpa_sumy_czasu=ARRAY[czas_firma, czas_wolny, czas_sluzba, czas_przerwa],
rcpa_ostatni_tryb=last_typ,
rcpa_ostatni_klik=last_czas,
rcpa_wejscie=czas_wejscia,
rcpa_wyjscie=czas_wyjscia,
rcpa_flaga=finalize::integer
WHERE rcpa_idagregacji=oldagg.rcpa_idagregacji;
 END IF;
END;
$_$;
