--olap 1
SELECT dia_semana, concelho, sum(unidades)
FROM (select * from vendas where dia_mes BETWEEN 1 and 30 AND mes = 8 AND ano = 2022) a
GROUP BY GROUPING SETS (dia_semana, concelho, ());

--olap 2
SELECT concelho, cat, dia_semana, sum(unidades)
FROM (select * from vendas where distrito = 'Lisboa') a
GROUP BY GROUPING SETS ((concelho, cat, dia_semana), ());
