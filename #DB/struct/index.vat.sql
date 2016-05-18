CREATE UNIQUE INDEX vat_tb_vat_i1 ON tb_vat USING btree (tr_idtrans, v_stvat, v_zw, v_kurswal, (COALESCE(v_idwaluty, '-1'::integer)), v_isorg, v_iswal, v_iscorr, v_ispkormakro, v_iskgoforwal);


--
--

CREATE INDEX vat_tb_vat_i2 ON tb_vat USING btree (tr_idtrans);
