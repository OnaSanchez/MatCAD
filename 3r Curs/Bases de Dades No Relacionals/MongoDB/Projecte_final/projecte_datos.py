from pymongo import MongoClient
import pymongo
import numpy as np
import pandas as pd


################################## FUNCIONS AUXILIARS ##################################

# Funció destinada a corretgir els formats incompatibles
def corregir_errors(colleccio):
    n = {}
    for k, v in colleccio.items():
        if isinstance(v, np.int64):
            v = int(v)
        if isinstance(v, np.bool_):
            v = bool(v)

        n[k] = v
    return n

# Funció que extreu l'informació del Dataframe discriminant casos especials de les nostres dades
def extreure_informacio(df, i, atribut, fila, tractament_especial = []):
    if (atribut in tractament_especial):
        info = df[i][atribut][fila][1:-1].split(",") # Separem l'string i eliminem els elements dels extrems: "[,]"
    else:
        info = df[i][atribut][fila]
    return info


################################## PARAMETRES ADICIONALS ###################################

# Paràmetres d'execució del codi
comprova_columnes = False
coll_name = "Editorial"
DataBase = "test"
sheets = ["Artistes", "Personatges", "Colleccions-Publicacions"]
atributs_llistes = ["genere", "guionistes", "dibuixants"]


# En execució remota
Host = 'dcccluster.uab.es'
Port = 8230


###################################### CONNEXIÓ ##############################################

DSN = "mongodb://{}:{}".format(Host, Port)

conn = MongoClient(DSN)


############################# TRANSFERÈNCIA DE DADES AMB MONGO ##############################

# Selecciona la base de dades a utilitzar
bd = conn[DataBase]

# Creació de les col·leccions /si hi son creades les elimenem i les creem de nou per no afegir informació redundant
for coll_name in sheets:
    if coll_name in bd.list_collection_names():
        coll = bd[coll_name]
        coll.drop()
    coll = bd.create_collection(coll_name)

df = {}

# Creació dels diferents dataframes --> un per cada pàgina de l'arxiu excel
for i in sheets:
    df[i] = pd.read_excel(open("Dades.xlsx", "rb"), sheet_name = i)

# Comprovació de l'extracció de dades
if(comprova_columnes):
    for i in sheets:
        print(df[i].columns.values)
        print()

# Introducció de les dades a la base de dades
for i in df:
    coll = bd[i]
    atributs = df[i].columns.values

    for fila in range(df[i].shape[0]):
        colleccio = {}
        for atribut in atributs:
            info = extreure_informacio(df, i, atribut, fila, atributs_llistes)
            colleccio[atribut] = info

        try:
            coll.insert_one(colleccio)

        # En cas d'existir algun element amb un format no compatible el cambiem per un compatible
        except pymongo.errors.InvalidDocument:
            n = corregir_errors(colleccio)
            coll.insert_one(n)

# Tancament de la conecció
conn.close()


