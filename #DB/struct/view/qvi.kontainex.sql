CREATE VIEW kontainex AS
 SELECT a.ktn_idkonta,
    a.kt_idkonta,
    a.kt_fullnumer,
    a.kt_fullnumer_splitted,
    array_length(a.kt_fullnumer_splitted, 1) AS kt_nr_count,
    a.kt_opis,
    ((((((((ARRAY[NULL::text] || ktpm7.kt_opis) || ktpm6.kt_opis) || ktpm5.kt_opis) || ktpm4.kt_opis) || ktpm3.kt_opis) || ktpm2.kt_opis) || ktpm1.kt_opis) || ktbase.kt_opis) AS kt_opis_array,
    l.fm_idcentrali AS idcentrali
   FROM (((((((((kontain a
     LEFT JOIN public.kh_konta ktbase ON ((ktbase.kt_idkonta = a.kt_idkonta)))
     LEFT JOIN public.kh_konta ktpm1 ON ((ktpm1.kt_idkonta = ktbase.kt_ref)))
     LEFT JOIN public.kh_konta ktpm2 ON ((ktpm2.kt_idkonta = ktpm1.kt_ref)))
     LEFT JOIN public.kh_konta ktpm3 ON ((ktpm3.kt_idkonta = ktpm2.kt_ref)))
     LEFT JOIN public.kh_konta ktpm4 ON ((ktpm4.kt_idkonta = ktpm3.kt_ref)))
     LEFT JOIN public.kh_konta ktpm5 ON ((ktpm5.kt_idkonta = ktpm4.kt_ref)))
     LEFT JOIN public.kh_konta ktpm6 ON ((ktpm6.kt_idkonta = ktpm5.kt_ref)))
     LEFT JOIN public.kh_konta ktpm7 ON ((ktpm7.kt_idkonta = ktpm6.kt_ref)))
     JOIN public.kh_lata l ON ((l.ro_idroku = ktbase.ro_idroku)));
