CREATE TABLE classI_vs_glimpse_001_nn_corrected AS 
  SELECT a.gtdesig, gldesig, a.dist_sq, gt3_6, gl3_6, gt4_5, gl4_5, gt5_8, gl5_8, gt8_0, gl8_0 
  FROM classI_vs_glimpse_001_corrected AS a JOIN 
    (SELECT gtdesig, MIN(dist_sq) AS mds FROM classI_vs_glimpse_001_corrected GROUP BY gtdesig) AS b ON 
  a.gtdesig = b.gtdesig AND a.dist_sq = b.mds;
