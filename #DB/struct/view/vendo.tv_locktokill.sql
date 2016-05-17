CREATE VIEW tv_locktokill AS
 SELECT DISTINCT tv_locks.other_pid
   FROM tv_locks
  WHERE (NOT (tv_locks.other_pid IN ( SELECT tv_locks_1.waiting_pid
           FROM tv_locks tv_locks_1)))
  ORDER BY tv_locks.other_pid;
