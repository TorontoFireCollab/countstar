
# coding: utf-8

# In[4]:

import astropy 
from astropy.table import Table, Column, join
import numpy as np
from astropy.coordinates import SkyCoord
from astropy import units as u
spatial_err = 0.3/3600*u.degree


# In[5]:

def update_type(target, source, tp):
    for target['desigation'] in source['designation']:
        target['type'] = tp
    return 0


# In[8]:

#threshold is in units of spatial_err (typically 0.3 arcsec)
#we want to merge mag_24 in source into target
def coord_merge(target, source, threshold):
    tc = SkyCoord(ra=target['ra'], dec=target['dec'])
    sc = SkyCoord(ra=source['ra'], dec=source['dec'])
    idx, d2d, d3d = sc.match_to_catalog_sky(tc)
    #idx is index into tc (target) coordinates that are closest objects to each of the coordinates in sc (source)
    #There are as many objects in idx as in source
    for i in range(0, len(idx)):
        if d2d[i] < threshold * spatial_err:
            target['mag24'][idx[i]] = source['mag24'][i]
            target['d24m'][idx[i]] = source['d24m'][i]
    return 0


# In[7]:

#merge mag_24 in source into target catalog
def desig_merge(target, source):
    return join(target, source, keys='designation', join_type = 'left')


# In[ ]:

#compute the minimum separation between two catalogs
#for each object in source, find the object in target that is closest
#returns min(dist(obj1, obj2)), obj1 in catalog 1, obj2 in catalog 2
#The order of the arguments do not change the result, but using the smaller catalog as the second argument will 
#the function run faster
def cat_dist(target, source):
    tc = SkyCoord(ra=target['ra'], dec=target['dec'])
    sc = SkyCoord(ra=source['ra'], dec=source['dec'])
    idx, d2d, d3d = sc.match_to_catalog_sky(tc)
    return min(d2d)

