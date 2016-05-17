CREATE VIEW tv_locks AS
 SELECT waiting.locktype AS waiting_locktype,
    (waiting.relation)::regclass AS waiting_table,
    waiting_stm.query AS waiting_query,
    waiting.mode AS waiting_mode,
    waiting.pid AS waiting_pid,
    other.locktype AS other_locktype,
    (other.relation)::regclass AS other_table,
    other_stm.query AS other_query,
    other.mode AS other_mode,
    other.pid AS other_pid,
    other.granted AS other_granted
   FROM (((pg_locks waiting
     JOIN pg_stat_activity waiting_stm ON ((waiting_stm.pid = waiting.pid)))
     JOIN pg_locks other ON ((((waiting.database = other.database) AND (waiting.relation = other.relation)) OR (waiting.transactionid = other.transactionid))))
     JOIN pg_stat_activity other_stm ON ((other_stm.pid = other.pid)))
  WHERE ((NOT waiting.granted) AND (waiting.pid <> other.pid));
