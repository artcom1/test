CREATE FUNCTION createnotifytable() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
 CREATE TEMP TABLE tm_notifies
 (
  nn_timestamp TIMESTAMP DEFAULT clock_timestamp(),
  nn_cmd       INT DEFAULT 0,                    ---- 0 - DC (changed), 1 - D (deleted), 2 - I (insert)
  nn_datatype  INT,
  nn_id        TEXT
 );
 CREATE INDEX tm_notifies_i1 ON tm_notifies(nn_datatype,nn_id);
 CREATE INDEX tm_notifies_i2 ON tm_notifies(nn_datatype,nn_timestamp);
 PERFORM vendo.settparami('_HASNOTIFYTABLE',1);
 RETURN vendo.enableNotifyToTable(true);
END;
$$;
