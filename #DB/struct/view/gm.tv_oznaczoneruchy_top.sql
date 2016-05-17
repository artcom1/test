CREATE VIEW tv_oznaczoneruchy_top AS
 SELECT tm_oznaczoneruchy.rc_idruchu
   FROM tm_oznaczoneruchy
  WHERE (tm_oznaczoneruchy.ozr_setid = topoznaczruchn());
