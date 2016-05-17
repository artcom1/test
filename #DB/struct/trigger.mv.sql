CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_multivals FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('296', 'mvs_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_mvmoveables FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('301', 'mva_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_mvpodrodzaj FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('304', 'mvp_id');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_multivalfiltr FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('343', 'mvf_idfiltru');


--
--

CREATE TRIGGER z_datachanged_univ AFTER UPDATE ON ts_multivalpage FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('350', 'mvg_id');


--
--

CREATE TRIGGER z_datachanged_univ_mvs AFTER UPDATE ON ts_multivalfiltr FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE vendo.ondatachanged('-296', 'mvs_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_multivals FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('296', 'mvs_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_mvmoveables FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('301', 'mva_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_mvpodrodzaj FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('304', 'mvp_id');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_multivalfiltr FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('343', 'mvf_idfiltru');


--
--

CREATE TRIGGER z_datadeleted_insdel AFTER INSERT OR DELETE ON ts_multivalpage FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('350', 'mvg_id');


--
--

CREATE TRIGGER z_datadeleted_insdel_mvs AFTER INSERT OR DELETE ON ts_multivalfiltr FOR EACH ROW EXECUTE PROCEDURE vendo.ondatachanged('-296', 'mvs_id');


SET search_path = mvv, pg_catalog;
