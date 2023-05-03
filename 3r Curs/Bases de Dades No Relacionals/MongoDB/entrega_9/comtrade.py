import csv
from pymongo import MongoClient

# En execució remota
Host = 'localhost' # localhost per connexions a la màquina main
Port = 27017

###################################### CONNEXIÓ ##############################################

DSN = "mongodb://{}:{}".format(Host,Port)

conn = MongoClient(DSN)
bd = conn['comtrade']

#Lectura del csv
comtrade = {}
with open('comtrade.csv', mode='r') as f:  # r for read, U for unicode
    reader = csv.reader(f, delimiter=';')
    for n, row in enumerate(reader):
        if not n:
            # Skip header row (n = 0).
            continue
        year, flow, reporter, reporter_iso, partner, partner_iso, commodity, unit, wty, value = row
        if partner not in comtrade:  # si encara no l'hem afegit, creem la llista
            comtrade[partner] = list()

        # aquí ja sabem que la entrada per riu existeix, afegim la resta de dades
        comtrade[partner].append({"year":year, "flow": flow, "reporter": reporter, "reporter_iso": reporter_iso,
                                  "partner_iso": partner_iso, "commodity": commodity, "unit": unit, "wty": wty, "value": value})
    print(comtrade)

if 'comtrade' not in bd.list_collection_names():
    coll = bd.create_collection('comtrade')
else:
    coll = bd['comtrade']

for i in comtrade:
    coll.insert_one({'Partner':i, "info": comtrade[i]})

