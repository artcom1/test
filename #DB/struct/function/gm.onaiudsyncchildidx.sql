CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 syncgmag BOOL:=false;
 syncpdo1 BOOL:=false;
 syncg1   BOOL:=false;
 flagamask INT:=0;
 newflagamask INT:=0;
BEGIN
 ---Trigger AFTER dla nadindexow

 --- Nie ma potrzeby sprawdzania czegokolwiek
 IF ((NEW.ttw_newflaga&(1<<22))=0) THEN
  RETURN NEW;
 END IF;

 IF ((NEW.ttw_new2flaga&1)=0) THEN
  IF (NEW.ttw_usluga=TRUE) OR 
     ((NEW.ttw_flaga&(4|16|32|8192|(1<<18)|(1<<19)|(1<<23)))!=0) 
  THEN
   RAISE EXCEPTION 'Nadindeks moze byc tylko towarem a nie jest (%)!',NEW.ttw_idtowaru;
  END IF;
 END IF;
 
 syncgmag=((vendo.getconfigvalue('TOWIDX_SYNCGMAGAZYNOWA')='1') OR (NEW.ttw_rtowaru=128));
 syncpdo1=(vendo.getconfigvalue('TOWIDX_SYNCPDO1')='1'); 
 syncg1=(vendo.getconfigvalue('TOWIDX_SYNCG1')='1');
 flagamask=(1|2|2048|4096|(3<<21));
 newflagamask=(2|(1<<8)|(1<<9)|(1<<10));
 if (syncpdo1=TRUE) THEN
  newflagamask=newflagamask|(3<<13)|(1<<29)|(1<<30);
 END IF;
   
 UPDATE tg_towary SET
   ttw_parentkod=NEW.ttw_klucz,
   tjn_idjedn=NEW.tjn_idjedn,
   tgr_idgrupy=(CASE WHEN syncg1=TRUE THEN NEW.tgr_idgrupy ELSE tgr_idgrupy END),
   tpg_idpodgrupy=NEW.tpg_idpodgrupy,
   tgw_idgrupy=NEW.tgw_idgrupy,
   ttw_vats=NEW.ttw_vats,
   ttw_vatz=NEW.ttw_vatz,
   ttw_sww=NEW.ttw_sww,
   ttw_pcn=NEW.ttw_pcn,
   ttw_flaga=ttw_flaga&(~flagamask)|(NEW.ttw_flaga&flagamask),
   ttw_newflaga=ttw_newflaga&(~newflagamask)|(NEW.ttw_newflaga&newflagamask),
   tmg_idonlymagazynu=NEW.tmg_idonlymagazynu,
   fm_idonlycentrali=NEW.fm_idonlycentrali,
   ttw_inoutmethod=(CASE WHEN syncgmag=TRUE THEN NEW.ttw_inoutmethod ELSE ttw_inoutmethod END),
   ttw_whereparams=(CASE WHEN syncgmag=TRUE THEN NEW.ttw_whereparams ELSE ttw_whereparams END),
   ttw_pzhashmethod=(CASE WHEN syncgmag=TRUE THEN NEW.ttw_pzhashmethod ELSE ttw_pzhashmethod END),
   ttw_wzhashmethod=(CASE WHEN syncgmag=TRUE THEN NEW.ttw_wzhashmethod ELSE ttw_wzhashmethod END),
   ttw_dlugosc_mpq=(CASE WHEN syncpdo1=TRUE THEN NEW.ttw_dlugosc_mpq ELSE ttw_dlugosc_mpq END),
   ttw_powierzchnia_mpq=(CASE WHEN syncpdo1=TRUE THEN NEW.ttw_powierzchnia_mpq ELSE ttw_powierzchnia_mpq END),
   ttw_objetosc_mpq=(CASE WHEN syncpdo1=TRUE THEN NEW.ttw_objetosc_mpq ELSE ttw_objetosc_mpq END)
  WHERE
   ttw_idxref=NEW.ttw_idtowaru AND
   ttw_idxref IS NOT NULL AND 
   (
    ttw_parentkod IS DISTINCT FROM NEW.ttw_klucz OR
    tjn_idjedn IS DISTINCT FROM NEW.tjn_idjedn OR
    tgr_idgrupy IS DISTINCT FROM NEW.tgr_idgrupy OR
    tpg_idpodgrupy IS DISTINCT FROM NEW.tpg_idpodgrupy OR 
    tgw_idgrupy IS DISTINCT FROM NEW.tgw_idgrupy OR 
    (ttw_flaga&(3<<21)) IS DISTINCT FROM (NEW.ttw_flaga&(3<<21)) OR 
    ttw_vats IS DISTINCT FROM NEW.ttw_vats OR 
    ttw_vatz IS DISTINCT FROM NEW.ttw_vatz OR
    ttw_sww IS DISTINCT FROM NEW.ttw_sww OR
    ttw_pcn IS DISTINCT FROM NEW.ttw_pcn OR
    (ttw_flaga&flagamask) IS DISTINCT FROM (NEW.ttw_flaga&flagamask)OR
    (ttw_newflaga&newflagamask) IS DISTINCT FROM (NEW.ttw_newflaga&newflagamask) OR
    tmg_idonlymagazynu IS DISTINCT FROM NEW.tmg_idonlymagazynu OR
    fm_idonlycentrali IS DISTINCT FROM NEW.fm_idonlycentrali OR
(syncgmag=TRUE AND (
     ttw_inoutmethod IS DISTINCT FROM NEW.ttw_inoutmethod OR
     ttw_whereparams IS DISTINCT FROM NEW.ttw_whereparams OR
     ttw_pzhashmethod IS DISTINCT FROM NEW.ttw_pzhashmethod OR
     ttw_wzhashmethod IS DISTINCT FROM NEW.ttw_wzhashmethod 
 )
) OR
(syncpdo1=TRUE AND (
     ttw_dlugosc_mpq IS DISTINCT FROM NEW.ttw_dlugosc_mpq OR
     ttw_powierzchnia_mpq IS DISTINCT FROM NEW.ttw_powierzchnia_mpq OR
     ttw_objetosc_mpq IS DISTINCT FROM NEW.ttw_objetosc_mpq
 )
)
   );

 RETURN NEW;
END
$$;
