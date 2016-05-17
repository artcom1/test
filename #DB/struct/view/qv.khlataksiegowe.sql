CREATE VIEW khlataksiegowe AS
 SELECT y.ro_idroku AS rok_ksiegowy,
    y.ro_rok AS opis_roku,
    y.ro_start AS mcstart,
    y.ro_end AS mckoniec,
    (replace("substring"((y.ro_start)::text, 1, ((4 + 1) + 2)), '-'::text, ''::text))::integer AS mcstartint,
    (replace("substring"((y.ro_end)::text, 1, ((4 + 1) + 2)), '-'::text, ''::text))::integer AS mckoniecint,
    y.fm_idcentrali AS indexcentrali
   FROM public.kh_lata y
  WHERE (y.ro_iswymiar = false);
