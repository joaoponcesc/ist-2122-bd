--ex1
select nome
from(
    select tin, count(*)
    from (
        select distinct nome_cat, tin from responsavel_por
    ) c
    group by tin
    having count(*) >= all(
        select count(*)
        from (
            select distinct nome_cat, tin from responsavel_por
        ) b
        group by tin)
) a
natural join retalhista;

--ex2
select nome
from (
    select count(distinct nome_cat), tin
    from responsavel_por
    group by (tin)
    having count(distinct nome_cat) = any(
        select count(*)
        from categoria_simples)
) a
natural join retalhista;

--ex3
select ean 
    from produto 
    where ean not in 
    (select ean 
        from evento_reposicao);

--ex4
select ean 
from (select distinct ean, tin from evento_reposicao) a
group by ean
having count(*) = 1;


