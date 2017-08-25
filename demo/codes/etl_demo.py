
# coding: utf-8

# In[ ]:

import catalog_util_astro as cua
import astropy 
from astropy.table import Table, Column, join
import numpy as np
from astropy.coordinates import SkyCoord
from astropy import units as u


# In[ ]:

#Typical ETL Process for Catalog Data downloaded from GATOR. 
#The goal is to read glimpse and mipsgal catalog into astropy tables and merge mipsgal table into glimpse table.
#The result should be a table containing objects with magnitude and magnitude uncertainties at 
#3.6, 4.5, 5.8, 8.0 microns, JHK bands and 24 microns 


# In[ ]:

#1. Read tables from files

#Read glimpse catalog
g = Table.read('/home/caike/countstar/demo/data/glimpse_demo.tbl', format='ascii')

#Read mipsgal catalog
m = Table.read('/home/caike/countstar/demo/data/mipsgal_demo.tbl', format='ascii')


# In[ ]:

#2. Rename columns of the mipsgal table.
#We follow the naming convention of glimpse catalog
m.rename_column('glimpse_name', 'designation')
m.rename_column('mag_24', 'mag24')
m.rename_column('sigma_mag_24', 'd24m')


# In[ ]:

#3. Strip the 8-character prefix in glimpse designation
for i in range(0, len(g['designation'])):
    g['designation'][i] = g['designation'][i][8:]


# In[ ]:

#4. Split mipsgal catalog into two parts: 

#a part containing objects that have glimpse names
#this part will be merged into glimpse catalog by designation
ma = m[m['designation'].mask==False]['designation', 'mag24', 'd24m'] 

#a part containing objects that do not have glimpse names
#this part will be merged into glimpse catalog by matching objects with separation less than a user defined threshold.
mb = m[m['designation'].mask==True]['ra', 'dec', 'mag24', 'd24m']


# In[ ]:

#Use desig_merge function to merge ma into g. 
#desig_merge returns a new table containing merged data
merged = cua.desig_merge(g, ma)


# In[ ]:

#To merge mb into g, first compute the distance mb and g. 
#Only when it is small enough do we have the need to merge mb into g.  
cua.cat_dist(g, mb)


# In[ ]:

#If we do decide to merge mb into g, need to merge mb into the table returned by desig_merge
#The third argument is the threshold separation between objects, in units of spatial_err, such that
#If separation between two objects < threshold * spatial_err, the two objects will be considered the same
#And 24 micron detection in mb will be updated into merged
cua.coord_merge(merged, mb, 1)

#After this step, merged will be the table we can perform analysis on. 

