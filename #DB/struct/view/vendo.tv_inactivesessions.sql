CREATE VIEW tv_inactivesessions AS
 SELECT DISTINCT b.id
   FROM tm_vusers b
  WHERE (NOT (EXISTS ( SELECT v.id
           FROM tv_vusers v
          WHERE (v.id = b.id))));
