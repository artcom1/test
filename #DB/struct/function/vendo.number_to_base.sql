CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
WITH RECURSIVE n(i, n, r) AS (
    SELECT -1, num, 0
  UNION ALL
    SELECT i + 1, n / base, (n % base)::INT
    FROM n
    WHERE n > 0
)
SELECT string_agg(ch, '')
FROM (
  SELECT CASE
           WHEN r BETWEEN 0 AND 9 THEN r::TEXT
           WHEN r BETWEEN 10 AND 35 THEN chr(ascii('A') + r - 10)
           ELSE '%'
         END ch
  FROM n
  WHERE i >= 0
  ORDER BY i DESC
) ch
$$;
