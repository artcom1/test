CREATE VIEW wymiary_customvalues AS
 SELECT v.wme_idelemu,
    v.wme_kod AS wymiar_customvalue_kod,
    v.wme_nazwa AS wymiar_customvalue_nazwa,
    v.wms_idwymiaru AS wymiar_customvalue_wymiar
   FROM public.kh_wymiaryelems v
  WHERE (v.wme_datatyperef = 0);
