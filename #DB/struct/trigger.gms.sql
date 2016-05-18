CREATE TRIGGER gm_a_onaidsimordert AFTER INSERT OR DELETE ON tm_simorder FOR EACH ROW EXECUTE PROCEDURE onaiudsimorder();


--
--

CREATE TRIGGER gms_a_onausimordert AFTER UPDATE ON tm_simorder FOR EACH ROW WHEN ((new.* IS DISTINCT FROM old.*)) EXECUTE PROCEDURE onaiudsimorder();


--
--

CREATE TRIGGER gms_a_oniudsimwz AFTER INSERT OR DELETE OR UPDATE ON tm_simwz FOR EACH ROW EXECUTE PROCEDURE oniudsimwz();


--
--

CREATE TRIGGER gms_a_oniuduse AFTER INSERT OR DELETE OR UPDATE ON tm_touse FOR EACH ROW EXECUTE PROCEDURE oniuduse();
