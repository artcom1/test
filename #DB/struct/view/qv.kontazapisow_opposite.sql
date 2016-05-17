CREATE VIEW kontazapisow_opposite AS
 SELECT i.ktn_idkonta AS idkontazapisu_op,
    i.kt_idkonta AS idkonta_zapisuop,
    i.kt_fullnumer AS numerkonta_zapisuop,
    i.kt_nr_count AS numerkonta_zapisuop_pcount,
    i.kt_nr_p1 AS numerkonta_zapisuop_p1,
    i.kt_nr_p2 AS numerkonta_zapisuop_p2,
    i.kt_nr_p3 AS numerkonta_zapisuop_p3,
    i.kt_nr_p4 AS numerkonta_zapisuop_p4,
    i.kt_nr_p5 AS numerkonta_zapisuop_p5,
    i.kt_nr_p6 AS numerkonta_zapisuop_p6,
    i.kt_nr_p7 AS numerkonta_zapisuop_p7,
    i.kt_nr_p8 AS numerkonta_zapisuop_p8,
    i.kt_opis AS opiskonta_zapisuop,
    i.kt_nr_pfx1 AS fullnumerkonta_zapisuop_level1,
    i.kt_opis_pfx1 AS opisfullnumerkonta_zapisuop_level1,
    i.kt_nr_pfx2 AS fullnumerkonta_zapisuop_level2,
    i.kt_opis_pfx2 AS opisfullnumerkonta_zapisuop_level2,
    i.kt_nr_pfx3 AS fullnumerkonta_zapisuop_level3,
    i.kt_opis_pfx3 AS opisfullnumerkonta_zapisuop_level3,
    i.kt_nr_pfx4 AS fullnumerkonta_zapisuop_level4,
    i.kt_opis_pfx4 AS opisfullnumerkonta_zapisuop_level4,
    i.kt_nr_pfx5 AS fullnumerkonta_zapisuop_level5,
    i.kt_opis_pfx5 AS opisfullnumerkonta_zapisuop_level5,
    i.kt_nr_pfx6 AS fullnumerkonta_zapisuop_level6,
    i.kt_opis_pfx6 AS opisfullnumerkonta_zapisuop_level6,
    i.kt_nr_pfx7 AS fullnumerkonta_zapisuop_level7,
    i.kt_opis_pfx7 AS opisfullnumerkonta_zapisuop_level7,
    i.kt_nr_pfx8 AS fullnumerkonta_zapisuop_level8,
    i.kt_opis_pfx8 AS opisfullnumerkonta_zapisuop_level8,
    i.idcentrali
   FROM qvi.konta i;