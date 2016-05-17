CREATE TABLE tb_assemblies (
    asm_id integer NOT NULL,
    asm_name text NOT NULL,
    asm_version text NOT NULL,
    asm_publickeytoken text,
    asm_hash text NOT NULL,
    asm_asc_id integer NOT NULL
);
