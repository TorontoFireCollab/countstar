--Create a table that compares user specified table a and b. This table has columns:
--(a_IAU_desig, b_IAU_desig, dist_sq, a.m3_6, b.m3_6, a.m4_5, b.m4_5, a.m5_8, b.m5_8, a.m8_0, b.m8+0)
--currently positions of objects in a and b must be in RA and DEC.
--For each object in table a, search for all objects in table b within a square centered around the object, within user specified margin

SELECT load_extension('/home/kecai/w49/libsqlitefunctions.so');

CREATE TABLE IF NOT EXISTS TBA_v_TBB_SUFFIX_nb AS 
SELECT a.desig AS TBAdesig, b.desig AS TBBdesig, SQRT(SQUARE(a.ra - b.ra) + SQUARE(a.dec - b.dec)) AS dist, 
a.m3_6 AS TBAm3_6, b.m3_6 AS TBBm3_6, a.m4_5 AS TBAm4_5, b.m4_5 AS TBBm4_5, a.m5_8 AS TBAm5_8, b.m5_8 AS TBBm5_8, a.m8_0 AS TBAm8_0, b.m8_0 AS TBBm8_0 
FROM TBA AS a JOIN TBB AS b 
WHERE (b.ra > (a.ra - MARGIN)) AND (b.ra < (a.ra + MARGIN)) AND (b.dec > (a.dec - MARGIN)) AND (b.dec < (a.dec + MARGIN))
ORDER BY a.desig, dist;

CREATE TABLE IF NOT EXISTS TBA_v_TBB_SUFFIX AS 
SELECT t.*
FROM TBA_v_TBB_SUFFIX_nb AS t JOIN 
  (SELECT TBAdesig, MIN(dist) AS mds FROM TBA_v_TBB_SUFFIX_nb GROUP BY TBAdesig) AS m ON 
  t.TBAdesig = m.TBAdesig AND t.dist = m.mds;
