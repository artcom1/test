CREATE TRIGGER u_flc_onad AFTER DELETE ON tm_flagcounter FOR EACH ROW WHEN ((old.flc_counter <> 0)) EXECUTE PROCEDURE flc_onaiud();


--
--

CREATE TRIGGER u_flc_onai AFTER INSERT ON tm_flagcounter FOR EACH ROW WHEN ((new.flc_counter <> 0)) EXECUTE PROCEDURE flc_onaiud();


--
--

CREATE TRIGGER u_flc_onau AFTER UPDATE ON tm_flagcounter FOR EACH ROW WHEN ((((old.flc_counter * new.flc_counter) = 0) AND ((old.flc_counter + new.flc_counter) <> 0))) EXECUTE PROCEDURE flc_onaiud();
