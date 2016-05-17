CREATE TABLE ts_operacjagoskpir (
    og_idoperacji integer DEFAULT nextval(('ts_operacjagoskpir_s'::text)::regclass) NOT NULL,
    og_kod text,
    og_nazwa text
);
