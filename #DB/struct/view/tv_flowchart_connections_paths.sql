CREATE VIEW tv_flowchart_connections_paths AS
 WITH RECURSIVE tb_flowchart_connections_paths(fct_id, fce_id_from, fce_id_to, level, path) AS (
         SELECT c.fct_id,
            c.fce_id_from,
            c.fce_id_to,
            1,
            ARRAY[c.fct_id, c.fce_id_from] AS "array"
           FROM tb_flowchart_connections c
        UNION ALL
         SELECT c.fct_id,
            w.fce_id_from,
            c.fce_id_to,
            (w.level + 1),
            (w.path || ARRAY[w.fce_id_to])
           FROM (tb_flowchart_connections_paths w
             JOIN tb_flowchart_connections c ON ((w.fce_id_to = c.fce_id_from)))
          WHERE (NOT (c.fce_id_to = ANY (w.path)))
        )
 SELECT g.fct_id,
    g.fce_id_from,
    g.fce_id_to,
    g.level,
    g.path
   FROM tb_flowchart_connections_paths g;
