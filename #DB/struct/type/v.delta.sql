CREATE TYPE delta AS (
	value_old numeric,
	id_old integer,
	value_new numeric,
	id_new integer
);


SET search_path = vendo, pg_catalog;
