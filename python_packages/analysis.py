
# coding: utf-8

# In[ ]:

import sqlite3 as sql
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import time
#angres is angular resolution, 0.3 arcsec. 0.000083 is in degree
angres = 0.00008333333


# In[8]:

def missmatch(constr, source, target, *objtypes):
    con = sql.connect(constr)
    cur = con.cursor()
    query = '''CREATE TABLE ''' + target + ''' AS SELECT * FROM '''+ source + ''' WHERE Type <> oType AND ('''
    i = 0
    for objtype in objtypes:
        query += ' Type =' + str(objtype) + ' OR oType =' + str(objtype)
        i+=1
        if i < len(objtypes):
            query += ' OR '
        else:
            query += ')'
    cur.execute(query)
    return target, query  


# In[ ]:

def scan(constr, small, large, radius=3):
    con = sql.connect(constr)
    cur = con.cursor()
    target = small+'_'+large
    cur.execute('''CREATE TABLE '''+ target + ''' AS SELECT * FROM ''' 
                   + small +''' AS sm JOIN '''+ large +''' AS lg ON 1 = 1 WHERE
                   lg.ra > sm.ra - ? AND 
                   lg.ra < sm.ra + ? AND
                   lg.dec > sm.dec - ? AND
                   lg.dec < sm.dec + ? AND
                   lg.desig <> sm.desig''', [radius*angres]*4)
    return target


# In[3]:

def scatter_plot_query(con,  xlb, ylb, imagepath, *queries):
    if len(queries) > 7:
        print 'Please provide no more than 7 queries.'
        return 0
    else:
        markers = ['ro', 'bx', 'g^', 'ys', 'cd', 'm|', 'k.']
        con = sql.connect(con)
        i = 0
        for query in queries:
            df = pd.read_sql_query(query, con)
            plt.plot(df[[0]], df[[1]], markers[i], label='q'+ str(i+1))
            i = i+1    
        plt.xlabel(xlb)
        plt.ylabel(ylb)
        plt.legend()
        ts = time.time()
        plt.savefig(imagepath+str(ts)+'.png', dpi=96)
        plt.close()
        return 0


# In[ ]:



