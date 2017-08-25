CREATE TABLE classII_vs_glimpse_00005_nn AS 
  SELECT a.gtdesig, gldesig, a.dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 
  FROM classII_vs_glimpse_00005 AS a JOIN 
    (SELECT gtdesig, MIN(dist_sq) AS mds FROM classII_vs_glimpse_00005 GROUP BY gtdesig) AS b ON 
  a.gtdesig = b.gtdesig AND a.dist_sq = b.mds;
