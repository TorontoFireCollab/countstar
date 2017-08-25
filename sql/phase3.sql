CREATE TABLE mg_phase3 AS SELECT *, m5_8 - m24 AS c58_24, m4_5 - m24 AS c45_24  
FROM mipsgal_raw WHERE dm24 < 0.2;

CREATE TABLE phase3_likely_deeply_embedded AS SELECT * FROM (SELECT *,  
CASE
WHEN m8_0 IS NOT NULL THEN m8_0 - m24
WHEN m8_0 IS NULL AND m5_8 IS NOT NULL THEN m5_8 - m24
WHEN m8_0 IS NULL AND m5_8 IS NULL AND m4_5 IS NOT NULL THEN m4_5 - m24
WHEN m8_0 IS NULL AND m5_8 IS NULL AND m4_5 IS NULL AND m3_6 IS NOT NULL THEN m3_6 - m24
END AS cX_24
FROM mg_phase3)
WHERE m24 < 7 AND cX_24 > 4.5;

--REFLAG SHOCKED GAS EMISSION: select results are shocked gas emission that should be class i
SELECT a.desig
FROM gl9 AS a JOIN mg_phase3 AS b
ON a.desig = b.gl_desig
WHERE b.m24 < 7 AND b.m3_6 - b.m5_8 > 0.5 AND b.m4_5 - b.m24 > 4.5 AND b.m8_0 - b.m24 > 4;

--REFLAG AGN


