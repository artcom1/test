CREATE TABLE tg_postgreslog (
    plog_log_time timestamp(3) with time zone,
    plog_user_name text,
    plog_database_name text,
    plog_process_id integer,
    plog_connection_from text,
    plog_session_id text NOT NULL,
    plog_session_line_num bigint NOT NULL,
    plog_command_tag text,
    plog_session_start_time timestamp with time zone,
    plog_virtual_transaction_id text,
    plog_transaction_id bigint,
    plog_error_severity text,
    plog_sql_state_code text,
    plog_message text,
    plog_detail text,
    plog_hint text,
    plog_internal_query text,
    plog_internal_query_pos integer,
    plog_context text,
    plog_query text,
    plog_query_pos integer,
    plog_location text,
    plog_application_name text
);
