drop table if exists categoria cascade;
drop table if exists categoria_simples cascade;
drop table if exists super_categoria cascade;
drop table if exists tem_outra cascade;
drop table if exists produto cascade;
drop table if exists tem_categoria cascade;
drop table if exists IVM cascade;
drop table if exists ponto_de_retalho cascade;
drop table if exists instalada_em cascade;
drop table if exists prateleira cascade;
drop table if exists planograma cascade;
drop table if exists retalhista cascade;
drop table if exists responsavel_por cascade;
drop table if exists evento_reposicao cascade;

create table categoria(
    nome varchar(32) not null unique,
    constraint pk_categoria primary key(nome)
);

create table categoria_simples(
    nome varchar(32) not null unique,
    constraint pk_categoria_simples primary key(nome),
    constraint fk_categoria_simples foreign key(nome)
        references categoria(nome)
);

create table super_categoria(
    nome varchar(32) not null unique,
    constraint pk_super_categoria primary key(nome),
    constraint fk_super_categoria foreign key(nome)
        references categoria(nome)
);

create table tem_outra(
    super_categoria varchar(32) not null,
    categoria varchar(32) not null unique,
    constraint pk_tem_outra primary key(categoria),
    constraint fk_tem_outra_super foreign key(super_categoria)
        references categoria(nome),
    constraint fk_tem_outra_categoria foreign key(categoria)
        references categoria(nome)
);

create table produto(
    ean char(13) not null unique,
    cat varchar(32) not null, 
    descr varchar(80) not null,
    constraint pk_produto primary key(ean),
    constraint fk_produto foreign key(cat)
        references categoria(nome)
);

create table tem_categoria(
    ean char(13) not null unique,
    nome varchar(32) not null,
    constraint pk_tem_categoria PRIMARY KEY(ean, nome),
    constraint fk_tem_categoria_ean foreign key(ean)
        references produto(ean),
    constraint fk_tem_categoria_nome foreign key(nome)
        references categoria(nome)
);

create table IVM(
    num_serie int not null,
    fabricante varchar(32) not null,
    constraint pk_ivm primary key(num_serie, fabricante)
); 

create table ponto_de_retalho(
    nome varchar(32) not null unique,
    distrito varchar(17) not null,
    concelho varchar(32) not null,
    constraint pk_ponto_de_retalho primary key(nome)
);

create table instalada_em(
    num_serie int not null,
    fabricante varchar(32) not null,
    local_de_instalacao varchar(32) not null,
    constraint pk_instalada_em primary key(num_serie, fabricante),
    constraint fk_instalada_em_ivm foreign key(num_serie, fabricante)
        references IVM(num_serie, fabricante),
    constraint fk_instalada_em_local foreign key(local_de_instalacao)
        references ponto_de_retalho(nome)
);

create table prateleira(
    nro int not null,
    num_serie int not null,
    fabricante varchar(32) not null,
    altura decimal(5,2) not null,
    nome varchar(32) not null,
    constraint pk_prateleira primary key(nro, num_serie, fabricante),
    constraint fk_prateleira_ivm foreign key(num_serie, fabricante)
        references ivm(num_serie, fabricante),
    constraint fk_prateleira_nome foreign key(nome)
        references categoria(nome)
);

create table planograma(
    ean char(13) not null,
    nro int not null,
    num_serie int not null,
    fabricante varchar(32) not null,
    faces int not null,
    unidades int not null,
    loc varchar(32) not null,
    constraint pk_planograma PRIMARY KEY(ean, nro, num_serie, fabricante),
    constraint fk_planograma_ean FOREIGN KEY(ean)
        references produto(ean),
    constraint fk_planograma_prateleira FOREIGN KEY(nro, num_serie, fabricante)
        REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE retalhista(
    tin varchar(32) not null unique,
    nome varchar(32) not null unique,
    CONSTRAINT pk_retalhista PRIMARY KEY(tin)
);

create TABLE responsavel_por(
    nome_cat varchar(32) not null,
    tin varchar(32) not null,
    num_serie int not null,
    fabricante varchar(32) not null,
    CONSTRAINT pk_responsavel_por PRIMARY KEY(num_serie, fabricante),
    CONSTRAINT fk_responsavel_por_categoria FOREIGN KEY(nome_cat)
        references categoria(nome),
    CONSTRAINT fk_responsavel_por_tin FOREIGN KEY(tin)
        references retalhista(tin),
    CONSTRAINT fk_responsavel_por_ivm FOREIGN KEY(num_serie, fabricante)
        references IVM(num_serie, fabricante)
);

CREATE TABLE evento_reposicao(
    ean char(13) not null,
    nro int not null,
    num_serie int not null,
    fabricante varchar(32) not null,
    instante TIMESTAMP not null,
    unidades int not null,
    tin varchar(32) not null,
    constraint pk_evento_reposicao PRIMARY KEY(ean, nro, num_serie, fabricante, instante),
    CONSTRAINT fk_evento_reposicao_planograma FOREIGN KEY(ean, nro, num_serie, fabricante)
        references planograma(ean, nro, num_serie, fabricante),
    CONSTRAINT fk_evento_reposicao_tin FOREIGN KEY(tin)
        references retalhista(tin)
);

insert into categoria values('agua');
insert into categoria values('sumo');
insert into categoria values('vinho');
insert into categoria values('bebida');
insert into categoria values('bolacha');
insert into categoria values('goma');
insert into categoria values('bolo');
insert into categoria values('doce');
insert into categoria values('batata frita');
insert into categoria values('caju');
insert into categoria values('cacahuete');
insert into categoria values('salgado');
insert into categoria values('pacote');

insert into categoria_simples values('agua');
insert into categoria_simples values('sumo');
insert into categoria_simples values('vinho');
insert into categoria_simples values('bolacha');
insert into categoria_simples values('goma');
insert into categoria_simples values('bolo');
insert into categoria_simples values('batata frita');
insert into categoria_simples values('caju');
insert into categoria_simples values('cacahuete');

insert into super_categoria values('bebida');
insert into super_categoria values('doce');
insert into super_categoria values('salgado');
insert into super_categoria values('pacote');

insert into tem_outra values('bebida', 'agua');
insert into tem_outra values('bebida', 'sumo');
insert into tem_outra values('bebida', 'vinho');
insert into tem_outra values('doce', 'bolacha');
insert into tem_outra values('doce', 'goma');
insert into tem_outra values('doce', 'bolo');
insert into tem_outra values('salgado', 'batata frita');
insert into tem_outra values('salgado', 'caju');
insert into tem_outra values('salgado', 'cacahuete');
insert into tem_outra values('pacote', 'doce');
insert into tem_outra values('pacote', 'salgado');

insert into IVM values('12369420', 'Samsung');
insert into IVM values('65919299', 'Bosch');
insert into IVM values('11101001', 'LG');
insert into IVM values('37666112', 'Xiaomi');
insert into IVM values('37516782', 'Smeg');
insert into IVM values('23489076', 'Fuji');
insert into IVM values('85518143', 'Fuji');
insert into IVM values('61649892', 'Fuji');
insert into IVM values('32697485', 'Fuji');
insert into IVM values('51726430', 'Fuji');
insert into IVM values('41191412', 'Fuji');
insert into IVM values('22918743', 'Fuji');
insert into IVM values('22704098', 'Fuji');
insert into IVM values('36416958', 'Fuji');

insert into ponto_de_retalho values('Galp - Oeiras', 'Lisboa', 'Oeiras');
insert into ponto_de_retalho values('Pingo Doce - Cacem', 'Lisboa', 'Sintra');
insert into ponto_de_retalho values('Continente - Carnaxide', 'Lisboa', 'Oeiras');
insert into ponto_de_retalho values('IST - TagusPark', 'Lisboa', 'Oeiras');
insert into ponto_de_retalho values('Casa do Chefe de Grupo', 'Lisboa', 'Cascais');

insert into produto values('1201821392216', 'sumo', 'Fanta Laranja');
insert into produto values('5152819223835', 'sumo', 'Compal Manga-Laranja');
insert into produto values('5287325633878', 'sumo', 'Lipton Ice Tea');
insert into produto values('2556774466952', 'agua', 'Fastio');
insert into produto values('6562699851667', 'agua', 'Serra da Estrela');
insert into produto values('3732721435033', 'vinho', 'Pinta Negra Branco e Rose');
insert into produto values('7809934719770', 'vinho', 'Casal Garcia');
insert into produto values('1488650520207', 'bolacha', 'Oreo');
insert into produto values('3138219189152', 'goma', 'Haribo');
insert into produto values('3740292053352', 'bolo', 'Bolo Marmore');
insert into produto values('5200595106462', 'batata frita', 'Lays');
insert into produto values('8175736350725', 'batata frita', 'Pringles');
insert into produto values('5762073702004', 'caju', 'Caju com sal');
insert into produto values('2095984907096', 'cacahuete', 'Cacahuete sem sal');
insert into produto values('4161650412989', 'cacahuete', 'Cacahuete com sal e mel');

insert into tem_categoria values('1201821392216', 'sumo');
insert into tem_categoria values('5152819223835', 'sumo');
insert into tem_categoria values('5287325633878', 'sumo');
insert into tem_categoria values('2556774466952', 'agua');
insert into tem_categoria values('6562699851667', 'agua');
insert into tem_categoria values('3732721435033', 'vinho');
insert into tem_categoria values('7809934719770', 'vinho');
insert into tem_categoria values('1488650520207', 'bolacha');
insert into tem_categoria values('3138219189152', 'goma');
insert into tem_categoria values('3740292053352', 'bolo');
insert into tem_categoria values('5200595106462', 'batata frita');
insert into tem_categoria values('8175736350725', 'batata frita');
insert into tem_categoria values('5762073702004', 'caju');
insert into tem_categoria values('2095984907096', 'cacahuete');
insert into tem_categoria values('4161650412989', 'cacahuete');

insert into instalada_em values('12369420', 'Samsung', 'Galp - Oeiras');
insert into instalada_em values('65919299', 'Bosch', 'Pingo Doce - Cacem');
insert into instalada_em values('11101001', 'LG', 'Pingo Doce - Cacem');
insert into instalada_em values('37666112', 'Xiaomi', 'IST - TagusPark');
insert into instalada_em values('37516782', 'Smeg', 'IST - TagusPark');
insert into instalada_em values('23489076', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('85518143', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('61649892', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('32697485', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('51726430', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('41191412', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('22918743', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('36416958', 'Fuji', 'Casa do Chefe de Grupo');
insert into instalada_em values('22704098', 'Fuji', 'Casa do Chefe de Grupo');

insert into prateleira values(1, '12369420', 'Samsung', 0.25, 'agua');                                                                        
insert into prateleira values(1, '65919299', 'Bosch', 0.50, 'vinho');
insert into prateleira values(1, '11101001', 'LG', 0.30, 'cacahuete');
insert into prateleira values(1, '37666112', 'Xiaomi', 0.40, 'batata frita');
insert into prateleira values(1, '37516782', 'Smeg', 0.40, 'sumo');
insert into prateleira values(1, '23489076', 'Fuji', 0.20, 'agua');
insert into prateleira values(1, '85518143', 'Fuji', 0.20, 'sumo');
insert into prateleira values(1, '61649892', 'Fuji', 0.20, 'vinho');
insert into prateleira values(1, '32697485', 'Fuji', 0.20, 'bolacha');
insert into prateleira values(1, '51726430', 'Fuji', 0.20, 'goma');
insert into prateleira values(1, '41191412', 'Fuji', 0.20, 'bolo');
insert into prateleira values(1, '22918743', 'Fuji', 0.20, 'batata frita');
insert into prateleira values(1, '22704098', 'Fuji', 0.20, 'caju');
insert into prateleira values(1, '36416958', 'Fuji', 0.20, 'cacahuete');

insert into planograma values('2556774466952', 1, '12369420', 'Samsung', 3, 15, 'Galp - Oeiras');
insert into planograma values('6562699851667', 1, '12369420', 'Samsung', 3, 15, 'Galp - Oeiras');
insert into planograma values('3732721435033', 1, '65919299', 'Bosch', 2, 10, 'Pingo Doce - Cacem');
insert into planograma values('7809934719770', 1, '65919299', 'Bosch', 1, 5, 'Pingo Doce - Cacem');
insert into planograma values('4161650412989', 1, '11101001', 'LG', 2, 10, 'Pingo Doce - Cacem');
insert into planograma values('8175736350725', 1, '37666112', 'Xiaomi', 2, 10, 'IST - TagusPark');
insert into planograma values('5287325633878', 1, '37516782', 'Smeg', 3, 15, 'IST - TagusPark');
insert into planograma values('5152819223835', 1, '37516782', 'Smeg', 2, 8, 'IST - TagusPark');
insert into planograma values('2556774466952', 1, '23489076', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('1201821392216', 1, '85518143', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('3732721435033', 1, '61649892', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('1488650520207', 1, '32697485', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('3138219189152', 1, '51726430', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('3740292053352', 1, '41191412', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('5200595106462', 1, '22918743', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('5762073702004', 1, '22704098', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');
insert into planograma values('2095984907096', 1, '36416958', 'Fuji', 1, 5, 'Casa do Chefe de Grupo');

insert into retalhista values('123-456-789-69420', 'Pancracio Sousa');
insert into retalhista values('742-996-705-83541', 'Sr. Injinheiro Socas');
insert into retalhista values('649-563-375-77428', 'Sir Kazzio');
insert into retalhista values('959-571-645-75667', 'Cristiano Ronaldo');
insert into retalhista values('047-766-431-39371', 'Sr. Vitor');
insert into retalhista values('938-184-888-12345', 'Chefe de Grupo');

insert into responsavel_por values('agua', '123-456-789-69420', '12369420', 'Samsung');
insert into responsavel_por values('vinho', '649-563-375-77428', '65919299', 'Bosch');
insert into responsavel_por values('cacahuete', '959-571-645-75667', '11101001', 'LG');
insert into responsavel_por values('batata frita', '742-996-705-83541', '37666112', 'Xiaomi');
insert into responsavel_por values('sumo', '047-766-431-39371', '37516782', 'Smeg');
insert into responsavel_por values('agua', '938-184-888-12345', '23489076', 'Fuji');
insert into responsavel_por values('sumo', '938-184-888-12345', '85518143', 'Fuji');
insert into responsavel_por values('vinho', '938-184-888-12345', '61649892', 'Fuji');
insert into responsavel_por values('bolacha', '938-184-888-12345', '32697485', 'Fuji');
insert into responsavel_por values('goma', '938-184-888-12345', '51726430', 'Fuji');
insert into responsavel_por values('bolo', '938-184-888-12345', '41191412', 'Fuji');
insert into responsavel_por values('batata frita', '938-184-888-12345', '22918743', 'Fuji');
insert into responsavel_por values('caju', '938-184-888-12345', '22704098', 'Fuji');
insert into responsavel_por values('cacahuete', '938-184-888-12345', '36416958', 'Fuji');

insert into evento_reposicao values('2556774466952', 1, '12369420', 'Samsung', '12/3/2022', 5, '123-456-789-69420');
insert into evento_reposicao values('3732721435033', 1, '65919299', 'Bosch', '21/4/2022', 5, '649-563-375-77428');
insert into evento_reposicao values('8175736350725', 1, '37666112', 'Xiaomi', '17/2/2022', 5, '742-996-705-83541');
insert into evento_reposicao values('5287325633878', 1, '37516782', 'Smeg', '2/1/2022', 5, '047-766-431-39371');
insert into evento_reposicao values('2556774466952', 1, '23489076', 'Fuji', '11/2/2022', 5, '938-184-888-12345');
insert into evento_reposicao values('1201821392216', 1, '85518143', 'Fuji', '23/8/2022', 5, '938-184-888-12345');
insert into evento_reposicao values('3732721435033', 1, '61649892', 'Fuji', '19/3/2022', 5, '938-184-888-12345');
insert into evento_reposicao values('1201821392216', 1, '85518143', 'Fuji', '26/8/2022', 5, '938-184-888-12345');
insert into evento_reposicao values('1201821392216', 1, '85518143', 'Fuji', '27/8/2022', 5, '938-184-888-12345');
