CREATE TABLE classII_vs_glimpse_00005 AS 
SELECT SSTOERC AS gtdesig, SSTGLMC AS gldesig, ((gt.ra - gl.ra)*(gt.ra - gl.ra) + (gt.dec - gl.dec)*(gt.dec - gl.dec)) AS dist_sq, 
gt.m3_6 AS gt3_6, gl.m3_6 AS gl3_6, gt.m4_5 AS gt4_5, gl.m4_5 AS gl4_5, gt.m5_8 AS gt5_8, gl.m5_8 AS gl5_8, gt.m8_0 AS gt8_0, gl.m8_0 AS gl8_0 
FROM gt2 AS gt JOIN gl_w49 AS gl 
WHERE (gl.ra > (gt.ra - 0.00005)) AND (gl.ra < (gt.ra + 0.00005)) AND (gl.dec > (gt.dec - 0.00005)) AND (gl.dec < (gt.dec + 0.0005))
ORDER BY gtdesig, dist_sq;
