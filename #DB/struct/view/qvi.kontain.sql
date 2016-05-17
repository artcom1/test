CREATE VIEW kontain AS
 SELECT a.ktn_idkonta,
    a.kt_idkonta,
    public.numerkonta(kt.kt_prefix, kt.kt_numer, (kt.kt_zerosto)::integer) AS kt_fullnumer,
    regexp_split_to_array(public.numerkonta(kt.kt_prefix, kt.kt_numer, (kt.kt_zerosto)::integer), '-'::text) AS kt_fullnumer_splitted,
    kt.kt_opis
   FROM (( SELECT kt_1.kt_idkonta,
            kt_1.ktn_idkonta,
            max(l.ro_end) OVER w AS ro_endmax,
            l.ro_end
           FROM (public.kh_konta kt_1
             JOIN public.kh_lata l ON ((l.ro_idroku = kt_1.ro_idroku)))
          WINDOW w AS (PARTITION BY kt_1.ktn_idkonta)) a
     JOIN public.kh_konta kt ON ((a.kt_idkonta = kt.kt_idkonta)))
  WHERE (a.ro_end = a.ro_endmax);
