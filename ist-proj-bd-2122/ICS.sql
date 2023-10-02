create or replace function chk_re_1_proc()
returns trigger as
$$
begin
    if new.super_categoria = new.categoria then
        raise exception 'Uma categoria não pode estar contida em si propria';
    end if;
    
    return new;
end;    
$$ language plpgsql;

drop trigger if exists chk_re_1 on tem_outra;

create trigger chk_re_1
before insert or update on tem_outra
for each row execute procedure chk_re_1_proc();


create or replace function chk_re_4_proc()
returns trigger as
$$
declare 
    x int := (select unidades
        from planograma 
        where (
            ean = new.ean and
            nro = new.nro and
            num_serie = new.num_serie and
            fabricante = new.fabricante
            )
        );
begin
    if new.unidades > x then 
        raise exception 'Numero de unidades repostas excede o planograma';
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists chk_re_4 on evento_reposicao;

create trigger chk_re_4
before insert or update on evento_reposicao
for each row execute procedure chk_re_4_proc();


create or replace function chk_re_5_proc()
returns trigger as
$$
begin
    if new.ean not in (
        select ean 
        from tem_categoria 
        where nome = (
            select nome
            from prateleira
            where new.nro = nro and new.num_serie = num_serie and new.fabricante = fabricante
        )
    ) then
        raise exception 'Produto nao pode ser colocado na prateleira';
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists chk_re_5 on evento_reposicao;

create trigger chk_re_5
before insert or update on evento_reposicao
for each row execute procedure chk_re_5_proc();