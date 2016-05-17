CREATE VIEW tv_activesessions AS
 SELECT DISTINCT b.id
   FROM tm_vusers b
  WHERE (EXISTS ( SELECT v.id
           FROM tv_vusers v
          WHERE (v.id = b.id)));
