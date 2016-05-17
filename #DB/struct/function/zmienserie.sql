CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 update tg_transakcje set tr_seria=$2 where tr_seria=$1;
 update tb_ustawieniadomprac set pu_seriadok=$2 where pu_seriadok=$1;
 update ts_seriepracownikow SET sp_seria=$2 where sp_seria=$1;
 update kh_wzorceelfiltr set wf_txtvalue=$2 where wf_txtvalue=$1 AND wf_typ=3;
 update tg_rodzajtransakcji set trt_ostseria=$2 where trt_ostseria=$1;
 RETURN TRUE;
END; $_$;
