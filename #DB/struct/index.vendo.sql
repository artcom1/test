CREATE UNIQUE INDEX tm_numeryseryjne_uniq ON tm_numeryseryjne USING btree (fm_idcentrali, k_idklienta, ns_isactive, ns_istymczasowy);


--
--

CREATE INDEX vendo_tm_vorders_i1 ON tm_vorders USING btree (ord_backendpid, ord_timestamp);
