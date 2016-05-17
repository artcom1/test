CREATE FUNCTION oniudrealizacjapzam() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold NUMERIC:=0;
 deltanew NUMERIC:=0;
 deltaoldi NUMERIC:=0;
 deltanewi NUMERIC:=0;
 deltaoldrez NUMERIC:=0;
 deltanewrez NUMERIC:=0;
 gdzieprzeniesco INT:=0;
 gdzieprzeniescn INT:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN 
  deltaoldi=deltaoldi-round(OLD.rm_iloscfwynik*OLD.rm_przell/OLD.rm_przelm,4);
  IF ((OLD.rm_flaga&2)=0) THEN
   deltaold=deltaold-round(OLD.rm_iloscfwynik*OLD.rm_przell/OLD.rm_przelm,4);
  END IF;
  IF ((OLD.rm_flaga&512)=512) THEN
   deltaoldrez=deltaoldrez-round(OLD.rm_iloscfwynik*OLD.rm_przell/OLD.rm_przelm,4);
  END IF;
  gdzieprzeniesco=(OLD.rm_flaga>>4)&15; 
 END IF;

 IF (TG_OP<>'DELETE') THEN
  NEW.rm_iloscf=round(NEW.rm_iloscf,4);
  IF (NEW.rm_flaga&(1<<12)!=0) THEN
   NEW.rm_iloscfwynik=round(COALESCE(NEW.rm_iloscfnegated-NEW.rm_iloscf+NEW.rm_iloscfnadmiar,NEW.rm_iloscf+NEW.rm_iloscfnadmiar-min(NEW.rm_iloscf+NEW.rm_iloscfnadmiar,NEW.rm_iloscfminus)),4);
  ELSE 
   NEW.rm_iloscfwynik=round(COALESCE(NEW.rm_iloscfnegated-NEW.rm_iloscf,NEW.rm_iloscf-min(NEW.rm_iloscf,NEW.rm_iloscfminus)),4);
  END IF;
  
  IF (NEW.rm_iloscfnegated IS NOT NULL AND NEW.rm_iloscfminus!=0) THEN
   RAISE EXCEPTION 'Blad iloscfnegated do iloscfminus';
  END IF;
 
  deltanewi=deltanewi+round(NEW.rm_iloscfwynik*NEW.rm_przell/NEW.rm_przelm,4);
  IF ((NEW.rm_flaga&2)=0) THEN
   deltanew=deltanew+round(NEW.rm_iloscfwynik*NEW.rm_przell/NEW.rm_przelm,4);
  END IF;
  IF ((NEW.rm_flaga&512)=512) THEN
   deltanewrez=deltanewrez+round(NEW.rm_iloscfwynik*NEW.rm_przell/NEW.rm_przelm,4);
  END IF;
  gdzieprzeniescn=(NEW.rm_flaga>>4)&15; 
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(NEW.tel_idpzam)=nullZero(OLD.tel_idpzam) AND gdzieprzeniescn=gdzieprzeniesco) THEN
   deltanew=deltanew+deltaold;
   deltanewi=deltanewi+deltaoldi;
   deltanewrez=deltanewrez+deltaoldrez;
   deltaold=0;
   deltaoldi=0;
   deltaoldrez=0;
  END IF;
 END IF;


 IF (deltaold<>0) THEN
   --Zablokuj update transelemu
   PERFORM vendo.deltatparami('TEEX_NOTEUPDATE_'||OLD.tel_idpzam::text,1,0);
   UPDATE tg_teex SET tex_iloscfzreal=tex_iloscfzreal+deltaold WHERE tex_idelem=OLD.tex_idpzam AND deltaold<>0;
   PERFORM vendo.deltatparami('TEEX_NOTEUPDATE_'||OLD.tel_idpzam::text,-1,0);

   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,1,OLD.tel_idpzam);   
   UPDATE tg_transelem SET 
          tel_ilosc=round((tel_ilosc*tel_przelnilosci-1000*deltaold)/tel_przelnilosci,4),
          tel_iloscdorezerwacji=(CASE WHEN OLD.rm_flaga&7=0 THEN round(tel_iloscdorezerwacji-deltaold,4) ELSE tel_iloscdorezerwacji END),
          tel_flaga=(CASE WHEN tel_skojzestaw>0 AND tel_newflaga&(1<<29)=0 THEN (tel_flaga|8192) ELSE  (tel_flaga|8192)&(~1024) END) 
   WHERE tel_idelem=OLD.tel_idpzam ;

   --Zupdatuj jeszcze raz tg_teex tak by sie wykonal na pewno trigger
   UPDATE tg_teex SET tex_idelem=tex_idelem WHERE tex_idelem=OLD.tex_idpzam AND deltaold<>0;
    
   UPDATE tg_transelem SET
          tel_wnettowal=obliczWartoscPoZmianieIlosci(tel_idelem,tel_iloscf,tel_wnettowal,tel_newflaga)
   WHERE tel_idelem=OLD.tel_idpzam AND (tel_newflaga&(1<<23))<>0;
   
   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,-1,OLD.tel_idpzam);   

   IF (gdzieprzeniesco=1) THEN
    UPDATE tg_zamilosci SET zmi_if_zreal=zmi_if_zreal+deltaold WHERE tel_idelem=OLD.tel_idpzam;
   END IF;
   IF (gdzieprzeniesco=2) THEN
    UPDATE tg_zamilosci SET zmi_if_anul=zmi_if_anul+deltaold WHERE tel_idelem=OLD.tel_idpzam;
   END IF;
   IF (gdzieprzeniesco=3) THEN
    UPDATE tg_zamilosci SET zmi_if_inne=zmi_if_inne+deltaold WHERE tel_idelem=OLD.tel_idpzam;
   END IF;
   IF (gdzieprzeniesco=4) THEN
    UPDATE tg_packelem SET pe_iloscinpz=round(pe_iloscinpz+deltaold,4) WHERE pe_idelemu=OLD.pe_idelemuzam;
   END IF;
 END IF;
 
 IF (deltaoldi<>0) THEN
  IF (gdzieprzeniesco=8) THEN
   UPDATE tg_zamilosci SET zmi_if_zwrotks=zmi_if_zwrotks+deltaoldi WHERE tel_idelem=OLD.tel_idpzam;
  END IF;
 END IF;

 IF (deltanew<>0) THEN
   PERFORM vendo.deltatparami('TEEX_NOTEUPDATE_'||NEW.tel_idpzam::text,1,0);
   UPDATE tg_teex SET tex_iloscfzreal=tex_iloscfzreal+deltanew WHERE tex_idelem=NEW.tex_idpzam AND deltanew<>0;
   PERFORM vendo.deltatparami('TEEX_NOTEUPDATE_'||NEW.tel_idpzam::text,-1,0);
   
   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,1,NEW.tel_idpzam);   
   
   UPDATE tg_transelem SET 
          tel_ilosc=round((tel_ilosc*tel_przelnilosci-1000*deltanew)/tel_przelnilosci,4),
          tel_iloscdorezerwacji=(CASE WHEN NEW.rm_flaga&7=0 THEN round(tel_iloscdorezerwacji-deltanew,4) ELSE tel_iloscdorezerwacji END),
          tel_flaga=(CASE WHEN tel_skojzestaw>0 AND tel_newflaga&(1<<29)=0 THEN (tel_flaga|8192) ELSE  (tel_flaga|8192)&(~1024) END) 
   WHERE tel_idelem=NEW.tel_idpzam;

   --Zupdatuj jeszcze raz tg_teex tak by sie wykonal na pewno trigger
   UPDATE tg_teex SET tex_idelem=tex_idelem WHERE tex_idelem=NEW.tex_idpzam AND deltanew<>0;
      
   UPDATE tg_transelem SET
          tel_wnettowal=obliczWartoscPoZmianieIlosci(tel_idelem,tel_iloscf,tel_wnettowal,tel_newflaga)
   WHERE tel_idelem=NEW.tel_idpzam AND (tel_newflaga&(1<<23))<>0;

   PERFORM gm.blockTriggerFunction('MARKTEASSAFEFORCHANGE'::gm.TRIGGERFUNCTION,-1,NEW.tel_idpzam);   
   
   IF (gdzieprzeniescn=1) THEN
    UPDATE tg_zamilosci SET zmi_if_zreal=zmi_if_zreal+deltanew WHERE tel_idelem=NEW.tel_idpzam;
   END IF;
   IF (gdzieprzeniescn=2) THEN
    UPDATE tg_zamilosci SET zmi_if_anul=zmi_if_anul+deltanew WHERE tel_idelem=NEW.tel_idpzam;
   END IF;
   IF (gdzieprzeniescn=3) THEN
    UPDATE tg_zamilosci SET zmi_if_inne=zmi_if_inne+deltanew WHERE tel_idelem=NEW.tel_idpzam;
   END IF;
   IF (gdzieprzeniescn=4) THEN
    UPDATE tg_packelem SET pe_iloscinpz=round(pe_iloscinpz+deltanew,4) WHERE pe_idelemu=NEW.pe_idelemuzam;
   END IF;
 END IF;
 IF (deltanewi<>0) THEN
  IF (gdzieprzeniescn=8) THEN
   UPDATE tg_zamilosci SET zmi_if_zwrotks=zmi_if_zwrotks+deltanewi WHERE tel_idelem=NEW.tel_idpzam;
  END IF;   
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
