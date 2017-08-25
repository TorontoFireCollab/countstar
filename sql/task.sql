
SELECT COUNT(SSTGLMC) FROM (SELECT SSTOERC, SSTGLMC FROM gclassI AS c1 JOIN glimpseI_irac AS gl WHERE (gl.ra > (c1.ra - 0.001)) AND (gl.ra < (c1.ra + 0.001)) AND (gl.ra > (c1.ra - 0.001)) AND (gl.dec < (c1.dec + 0.001))) GROUP BY SSTOERC

--search for neighbors within a radious
--search in glimpseI_irac for neighbors of classI objects within a square of centered around the classI object and side length 0.002 
CREATE TABLE classI_in_glimpse AS SELECT SSTOERC AS gut_desig, c1.ra, c1.dec,c1.m3_6, c1.m4_5, c1.m5_8, c1.m8_0, SSTGLMC AS glimpse_desig, gl.ra, gl.dec, gl.m3_6, gl.m4_5, gl.m5_8, gl.m8_0 FROM gclassI AS c1 JOIN glimpseI_irac AS gl WHERE (gl.ra > (c1.ra - 0.001)) AND (gl.ra < (c1.ra + 0.001)) AND (gl.ra > (c1.ra - 0.001)) AND (gl.dec < (c1.dec + 0.001)) ;

select a.gut_desig, a.glimpse_desig, ((ra - "ra:1")*(ra - "ra:1")+(dec - "dec:1")*(dec - "dec:1")) as dist_sq, m3_6, "m3_6:1", m4_5, "m4_5:1", m5_8, "m5_8:1", m8_0, "m8_0:1" from classI_in_glimpse_0001 as a join (select b.gut_desig, count(gut_desig) as cnt from classI_in_glimpse_0001 as b group by b.gut_desig) as match_count on a.gut_desig = match_count.gut_desig where cnt <10 order by a.gut_desig, dist_sq;

SELECT gtdesig, gldesig, ((gtra - glra)*(gtra - glra) + (gtdec - gldec)*(gtdec - gldec)) AS dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 FROM classI_in_glimpse_001 order by gtdesig, dist_sq;

--compute the distances between classI objects and their neigbors (which are results from searching within a certain radius)
CREATE VIEW classI_vs_glimpse_001 AS SELECT gtdesig, gldesig, ((gtra - glra)*(gtra - glra) + (gtdec - gldec)*(gtdec - gldec)) AS dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 FROM classI_in_glimpse_001 order by gtdesig, dist_sq;

SELECT gtdesig, gldesig, MIN(dist_sq), gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 FROM classI_vs_glimpse_001 GROUP BY gtdesig; 

--SELECT rows with the min(dist_sq) for each classI object identified by gutermuth
SELECT a.gtdesig, a.gldesig, a.dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 FROM classI_vs_glimpse_001 AS a JOIN (SELECT gtdesig, MIN(dist_sq) AS mds FROM classI_vs_glimpse_001 GROUP BY gtdesig) AS b ON a.gtdesig = b.gtdesig AND a.dist_sq = b.mds;

CREATE TABLE classII_vs_glimpse_001 AS SELECT gtdesig, gldesig, ((gtra - glra)*(gtra - glra) + (gtdec - gldec)*(gtdec - gldec)) AS dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 FROM glassII AS 
