#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect
import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199092"
DB_DATABASE = DB_USER
DB_PASSWORD = "beanos1904"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)

@app.route("/")
def main_menu():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)
        
@app.route("/categorias")
def list_categorias_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT nome FROM categoria;"
        cursor.execute(query)
        return render_template("categorias.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/ivms")
def list_all_ivms():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT num_serie, fabricante from IVM;"
        cursor.execute(query)
        return render_template("ivms.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/evento_reposicao", methods=["POST"])
def evento_reposicao():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT nome as Categoria, sum(unidades) as Unidades_Repostas from\
        (select * from evento_reposicao where num_serie = %s and fabricante = %s) a\
        natural join tem_categoria group by nome;"
        data = (request.form["num_serie"], request.form["fabricante"])
        cursor.execute(query, data)
        return render_template("evento_reposicao.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/remover")
def remover_categoria():
    try:
        return render_template("remover.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route("/remover_update", methods=["POST"])
def remover_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        nome_cat = request.form["nome_cat"]
        query = "delete from tem_outra where categoria = %s or super_categoria = %s;\
                    delete from super_categoria where nome = %s;\
                    delete from categoria_simples where nome = %s;\
                    delete from evento_reposicao where ean in (select ean from produto where cat = %s);\
                    delete from responsavel_por where nome_cat = %s;\
                    delete from planograma where (nro, num_serie, fabricante) in (select nro, num_serie, fabricante from prateleira where nome = %s);\
                    delete from prateleira where nome = %s;\
                    delete from tem_categoria where nome = %s;\
                    delete from produto where cat = %s;\
                    delete from categoria where nome = %s"
        data = (nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat,nome_cat)
        cursor.execute(query, data)
        return render_template("op_success.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/adicionar_sub")
def adicionar_sub():
    try:
        return render_template("adicionar_sub.html", params=request.args)
    except Exception as e:
        return str(e)
    
@app.route("/adicionar_sub_update", methods=["POST"])
def adicionar_sub_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        super_cat = request.form["super_cat"]
        sub_cat = request.form["sub_cat"]
        query = "insert into tem_outra values(%s,%s)"
        data = (super_cat, sub_cat)
        cursor.execute(query, data)
        return render_template("op_success.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/adicionar_categoria", methods=["POST"])
def adicionar_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tipo_categoria = request.form["tipo_categoria"]
        nome_cat = request.form["nome_cat"]
        query = None
        if tipo_categoria == "Super":
            query = "insert into categoria values(%s);insert into super_categoria values(%s);"
        if tipo_categoria == "Simples":
            query = "insert into categoria values(%s);insert into categoria_simples values(%s);"
        data = (nome_cat, nome_cat)
        cursor.execute(query, data)
        return render_template("op_success.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
        
@app.route("/return_menu", methods = ["POST"])
def voltar_menu():
    try:
        return main_menu()
    except Exception as e:
        return str(e)
    
@app.route("/gestao_retalhistas")
def list_retalhistas_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retalhista;"
        cursor.execute(query)
        return render_template("gestao_retalhistas.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
        
@app.route("/remover_retalhista")
def remover_retalhista():
    try:
        return render_template("remover_retalhista.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route("/remover_retalhista_update", methods=["POST"])
def remover_retalhista_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        query = "delete from evento_reposicao where tin = %s;\
            delete from responsavel_por where tin = %s;\
            delete from retalhista where tin = %s;"
        data = (tin,tin,tin)
        cursor.execute(query, data)
        return render_template("op_success.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/adicionar_retalhista", methods=["POST"])
def adicionar_retalhista():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin_novo = request.form["tin_novo"]
        nome_novo = request.form["nome_novo"]
        query = "insert into retalhista values(%s, %s);"
        data = (tin_novo, nome_novo)
        cursor.execute(query, data)
        return render_template("op_success.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
        
@app.route("/sub_categorias")
def list_super_categorias():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT nome FROM super_categoria;"
        cursor.execute(query)
        return render_template("sub_categorias.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
        
@app.route("/listar", methods=["POST"])
def list_sub_categorias():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        super_cat = request.form["nome_cat"]
        query = "with recursive sub_categorias as (\
                    select categoria\
                        from tem_outra\
                        where super_categoria = %s\
                    union ALL\
                    select b.categoria\
                        from tem_outra b\
                        inner join sub_categorias c on b.super_categoria = c.categoria\
                    ) select * from sub_categorias;"
        data = (super_cat,)
        cursor.execute(query, data)
        return render_template("listar.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
        
CGIHandler().run(app)
