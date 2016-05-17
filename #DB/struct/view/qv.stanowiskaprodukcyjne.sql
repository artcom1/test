CREATE VIEW stanowiskaprodukcyjne AS
 SELECT tg_obiekty.ob_idobiektu AS idobiektu,
    tg_obiekty.ob_kod AS kodobiektu,
    tg_obiekty.ob_nazwa AS nazwaobiektu,
    tg_obiekty.ob_nrseryjny AS nrseryjnyobiektu,
    tg_obiekty.w_idwydzialu AS idwydzialu,
    tg_obiekty.rb_idrodzaju AS rodzajstanowiska,
    tg_obiekty.ob_kosztpracy AS kosztpracy
   FROM public.tg_obiekty
  WHERE ((tg_obiekty.ob_flaga & 128) = 128);
