CREATE FUNCTION settings_set(_component text, _context text, _ownertype integer, _ownerid text, _name text, _value text, _valuehash text, _flag integer) RETURNS TABLE(storeid integer, settingid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    _sts_id INT;
    _stt_id INT;
BEGIN
    IF _component IS NULL THEN
        _component := '';
    END IF;    
    IF _context IS NULL THEN
        _context := '';
    END IF;    
    IF _ownerid IS NULL THEN
        _ownerid := '';
    END IF;
    
    SELECT ss.sts_id INTO _sts_id
    FROM tb_settings_storages AS ss
    WHERE ss.sts_component=_component AND ss.sts_context=_context;
              
    IF _sts_id IS NULL THEN
        INSERT INTO tb_settings_storages(sts_component, sts_context) 
        VALUES(_component, _context)
        RETURNING sts_id INTO _sts_id;
    END IF;    
    
    IF _value IS NULL THEN
        DELETE FROM tb_settings
        WHERE stt_sts_id = _sts_id
            AND stt_ownertype = _ownertype
            AND stt_ownerid = _ownerid
            AND stt_name = _name;
    ELSE         
        UPDATE tb_settings
        SET stt_value = _value,
            stt_valueHash = _valueHash,
            stt_lastchanged = now(),
            stt_flag = _flag
        WHERE stt_sts_id = _sts_id
            AND stt_ownertype = _ownertype
            AND stt_ownerid = _ownerid
            AND stt_name = _name
        RETURNING stt_id INTO _stt_id;
            
        IF _stt_id IS NULL THEN
            INSERT INTO tb_settings(stt_sts_id, stt_ownertype, stt_ownerid, stt_name, stt_value, stt_valuehash, stt_flag)
            VALUES (_sts_id, _ownertype, _ownerid, _name, _value, _valueHash, _flag)
            RETURNING stt_id INTO _stt_id;
        END IF;
        
        PERFORM pg_notify('lc_settings', _component || '#' || _context || '#' || _ownertype || '#' || _ownerid || '#' || _name);
        
        RETURN QUERY SELECT _sts_id, _stt_id;
    END IF;	
END
$$;
