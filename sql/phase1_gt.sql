-- EXTRACT ALL DATA WITH photometric uncertainty sigma < 0.2
CREATE TABLE gt_phase1 AS 
SELECT desig, ra, dec, m3_6, dm3_6,  m4_5, dm4_5,  m5_8, dm5_8,  m8_0, dm8_0, c36_45, c36_58, c36_80, c45_58, c45_80, c58_80 
FROM gtw49 
WHERE 
  (dm3_6 < 0.2) AND
  (dm4_5 < 0.2) AND
  (dm5_8 < 0.2) AND 
  (dm8_0 < 0.2);

--EXTRACT PAH galaxy (type 19) from sources with photometric uncertainty < 0.2
CREATE TABLE gt19n AS 
SELECT * FROM gt_phase1 
WHERE 
  ((c45_58  < (1.05/1.2)*(c58_80 - 1)) AND 
  (c45_58 < 1.05) AND 
  (c58_80 >1) AND 
  (m4_5 > 11.5)) 
  OR 
  ((c36_58 < (1.5/2)*(c45_80 -1)) AND
  (c36_58 < 1.5) AND 
  (c45_80 > 1) AND
  (m4_5 > 11.5));

--ELIMINATE PAH galaxy from sources with photometric uncertainy < 0.2
CREATE TABLE gt_phase1_sans19 AS 
SELECT a.* FROM 
  gt_phase1 AS a 
  LEFT OUTER JOIN 
  gt19n AS b 
  ON a.desig = b.desig 
WHERE b.desig is null;

--EXTRACT AGN (type 29) from sources without PAH galaxies:
CREATE TABLE gt29n AS 
SELECT * FROM gt_phase1_sans19 
WHERE 
  ((c45_80 > 0.5) AND (m4_5 > 13.5 +(c45_80 - 2.3)/0.4) AND ( m4_5 > 13.5)) 
  OR (m4_5 > 14+(c45_80 - 0.5)) 
  OR (m4_5 > 14.5 - (c45_80 - 1.2)/0.3) 
  OR (m4_5 >14.5); 

--ELIMINATE AGN from sources without PAH galaxies:
CREATE TABLE gt_phase1_sans19_29 AS 
SELECT a.* FROM 
  gt_phase1_sans19 AS a 
  LEFT OUTER JOIN 
  gt29n AS b 
  ON a.desig = b.desig
WHERE b.desig is null;

--SELECT shock gas emission (type 9) from sources without PAH AND AGN:
CREATE TABLE gt9n AS 
SELECT * FROM gt_phase1_sans19_29 
WHERE 
  (c36_45 > (1.2/0.55)*(c45_58 - 0.3)+0.8) AND 
  (c45_58 <= 0.85) AND 
  (c36_45 > 1.05);

--ELIMINATE shock gas emission from sources without PAH AND AGN:
CREATE TABLE gt_phase1_sans19_29_9 AS
SELECT a.* FROM 
  gt_phase1_sans19_29 AS a
  LEFT OUTER JOIN 
  gt9n AS b  
  ON a.desig = b.desig 
WHERE b.desig is null;

--load math extensions
SELECT load_extension('./libsqlitefunctions.so');

--EXTRACT PAH contaminated apertures (type 20), or PAH dominated sources in the paper
CREATE TABLE gt20n AS
SELECT * FROM gt_phase1_sans19_29_9 
WHERE
  c36_45 - SQRT(SQUARE(dm3_6)+SQUARE(dm4_5)) <= 1.4 * (c45_58+SQRT(SQUARE(dm4_5)+SQUARE(dm5_8)) - 0.7)+0.15 AND
  c36_45 - SQRT(SQUARE(dm3_6)+SQUARE(dm4_5)) <= 1.65;

--ELIMINATE PAH contaminated apertures
CREATE TABLE gt_phase1_sans19_29_9_20 AS 
SELECT a.* FROM 
  gt_phase1_sans19_29_9 AS a
  LEFT OUTER JOIN 
  gt20n AS b
  ON a.desig = b.desig
WHERE b.desig is null;

--EXTRACT CLASSI
CREATE TABLE gt1n AS SELECT * FROM gt_phase1_sans19_29_9_20
WHERE 
  c45_58 > 0.7 AND 
  c36_45 > 0.7;

--ELIMINATE CLASSI
CREATE TABLE gt_phase1_sans19_29_9_20_1 AS 
SELECT a.* FROM
  gt_phase1_sans19_29_9_20 AS a
  LEFT OUTER JOIN
  gt1n AS b
  ON a.desig = b.desig
WHERE b.desig IS NULL;

--EXTRACT CLASSII
CREATE TABLE gt2n AS SELECT * FROM gt_phase1_sans19_29_9_20_1 
WHERE 
  c36_58 + SQRT(SQUARE(dm3_6)+SQUARE(dm5_8)) <= (0.14/0.04)*(c45_80 - SQRT(SQUARE(dm4_5)+SQUARE(dm8_0))-0.5)+0.5 AND
  c36_45 - SQRT(SQUARE(dm3_6)+SQUARE(dm4_5)) > 0.15; 
