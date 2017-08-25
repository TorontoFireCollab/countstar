SELECT load_extension('/home/kecai/w49/libsqlitefunctions.so');

--CALCULATE errors in colors
CREATE TABLE gtw49_color_error AS SELECT *, 
SQRT(SQUARE(dm3_6)+SQUARE(dm4_5)) AS dc36_45, SQRT(SQUARE(dm3_6)+SQUARE(dm5_8)) AS dc36_58, 
SQRT(SQUARE(dm3_6)+SQUARE(dm8_0)) AS dc36_80, SQRT(SQUARE(dm4_5)+SQUARE(dm5_8)) AS dc45_58, 
SQRT(SQUARE(dm4_5)+SQUARE(dm8_0)) AS dc45_80, SQRT(SQUARE(dm5_8)+SQUARE(dm8_0)) AS dc58_80 
FROM gtw49;

DROP TABLE gtw49;
ALTER TABLE gtw49_color_error RENAME TO gtw49;
