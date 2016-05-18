CREATE VIEW konta AS
 SELECT a.ktn_idkonta,
    a.kt_idkonta,
    a.kt_fullnumer,
    a.kt_nr_count,
    a.kt_fullnumer_splitted[1] AS kt_nr_p1,
    a.kt_fullnumer_splitted[2] AS kt_nr_p2,
    a.kt_fullnumer_splitted[3] AS kt_nr_p3,
    a.kt_fullnumer_splitted[4] AS kt_nr_p4,
    a.kt_fullnumer_splitted[5] AS kt_nr_p5,
    a.kt_fullnumer_splitted[6] AS kt_nr_p6,
    a.kt_fullnumer_splitted[7] AS kt_nr_p7,
    array_to_string(a.kt_fullnumer_splitted[8:1000], '-'::text) AS kt_nr_p8,
        CASE
            WHEN (a.kt_nr_count >= 1) THEN array_to_string(a.kt_fullnumer_splitted[1:1], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx1,
    array_to_string(a.kt_opis_array[(10 - array_length(a.kt_fullnumer_splitted, 1)):(10 - array_length(a.kt_fullnumer_splitted, 1))], ''::text) AS kt_opis_pfx1,
        CASE
            WHEN (a.kt_nr_count >= 2) THEN array_to_string(a.kt_fullnumer_splitted[1:2], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx2,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 1):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 1)], ''::text) AS kt_opis_pfx2,
        CASE
            WHEN (a.kt_nr_count >= 3) THEN array_to_string(a.kt_fullnumer_splitted[1:3], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx3,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 2):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 2)], ''::text) AS kt_opis_pfx3,
        CASE
            WHEN (a.kt_nr_count >= 4) THEN array_to_string(a.kt_fullnumer_splitted[1:4], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx4,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 3):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 3)], ''::text) AS kt_opis_pfx4,
        CASE
            WHEN (a.kt_nr_count >= 5) THEN array_to_string(a.kt_fullnumer_splitted[1:5], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx5,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 4):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 4)], ''::text) AS kt_opis_pfx5,
        CASE
            WHEN (a.kt_nr_count >= 6) THEN array_to_string(a.kt_fullnumer_splitted[1:6], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx6,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 5):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 5)], ''::text) AS kt_opis_pfx6,
        CASE
            WHEN (a.kt_nr_count >= 7) THEN array_to_string(a.kt_fullnumer_splitted[1:7], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx7,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 6):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 6)], ''::text) AS kt_opis_pfx7,
        CASE
            WHEN (a.kt_nr_count >= 8) THEN array_to_string(a.kt_fullnumer_splitted[1:8], '-'::text)
            ELSE NULL::text
        END AS kt_nr_pfx8,
    array_to_string(a.kt_opis_array[((10 - array_length(a.kt_fullnumer_splitted, 1)) + 7):((10 - array_length(a.kt_fullnumer_splitted, 1)) + 7)], ''::text) AS kt_opis_pfx8,
    a.kt_opis,
    a.idcentrali
   FROM kontainex a;
