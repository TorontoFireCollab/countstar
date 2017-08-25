
# coding: utf-8

# In[1]:

import sqlite3 as sql
import math


# In[2]:

def square(x):
    if x != None:
        return x**2
    else:
        return None
def sqrt(x):
    if x != None:
        return math.sqrt(x)
    else:
        return None


# In[3]:

def add_math(con):
    con.create_function("SQUARE", 1, square)
    con.create_function("SQRT", 1, sqrt)
    return 0


# In[4]:

def update_type(con, target, source, ntype):
    cur = con.cursor()
    cur.execute('''UPDATE '''+ target + ''' SET Type = :ntype 
                WHERE desig IN (SELECT desig FROM ''' + source +''')''', {"ntype": ntype})
    con.commit()
    return 0


# In[5]:

def update_phase(con, target, source, phase):
    cur = con.cursor()
    cur.execute('''UPDATE '''+ target + ''' SET Phase = :phase  
                   WHERE desig IN (SELECT desig FROM '''+ source +''')''', {"phase": phase})
    con.commit()
    return 0


# In[7]:

def update_flag(con, target, source, flag):
    cur = con.cursor()
    cur.execute('''UPDATE '''+ target + ''' SET f_Type = :flag 
                   WHERE desig IN (SELECT desig FROM '''+ source +''')''', {"flag": flag})
    con.commit()
    return 0

