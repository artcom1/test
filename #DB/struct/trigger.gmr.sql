CREATE TRIGGER a_a_gmr_planzleceniarozmelems AFTER INSERT OR DELETE OR UPDATE ON tg_planzleceniarozmelems FOR EACH ROW EXECUTE PROCEDURE onaiudplanzleceniarozmelems();
