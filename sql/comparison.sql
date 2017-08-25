select m.desig, g.desig, m.m3_6, g.m3_6, m.m4_5, g.m4_5, m.m5_8, g.m5_8, m.m8_0, g.m8_0 from class1g as g left outer join class1m as m on g.desig = m.desig
union all
select m.desig, g.desig, m.m3_6, g.m3_6, m.m4_5, g.m4_5, m.m5_8, g.m5_8, m.m8_0, g.m8_0 from class1m as m left outer join class1g as g on m.desig = g.desig;

create table compare1 as 
select m.desig as mdesig, g.desig as gdesig, 
       m.m3_6 as m36, g.m3_6 as g36, m.m4_5 as m45, g.m4_5 as g45, m.m5_8 as m58, g.m5_8 as g58, m.m8_0 as m80, g.m8_0 as g80 
           from class1g as g left outer join class1m as m on g.desig = m.desig
union
select m.desig as mdesig, g.desig as gdesig, 
       m.m3_6 as m36, g.m3_6 as g36, m.m4_5 as m45, g.m4_5 as g45, m.m5_8 as m58, g.m5_8 as g58, m.m8_0 as m80, g.m8_0 as g80
           from class1m as m left outer join class1g as g on m.desig = g.desig;
