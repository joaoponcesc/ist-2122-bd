DROP VIEW IF EXISTS Vendas;

CREATE VIEW Vendas(
	ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT e.ean, t.nome, EXTRACT(YEAR FROM instante) as ano, EXTRACT(QUARTER FROM instante) AS trimestre,
	EXTRACT(MONTH FROM instante) as mes, EXTRACT(DAY FROM instante) AS dia_mes, EXTRACT(DOW FROM instante) AS dia_semana, distrito, concelho, unidades
FROM evento_reposicao e JOIN tem_categoria t
	ON e.ean = t.ean
NATURAL JOIN
instalada_em i JOIN ponto_de_retalho p
	ON i.local_de_instalacao = p.nome