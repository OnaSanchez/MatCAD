
import csv
from pymongo import MongoClient

# En execució remota
Host = 'localhost' # localhost per connexions a la màquina main
Port = 27017

###################################### CONNEXIÓ ##############################################

DSN = "mongodb://{}:{}".format(Host,Port)

conn = MongoClient(DSN)
bd = conn['comtrades']

#Lectura del csv
comtrade = {}
coll = bd.create_collection('comtrades')

with open('comtrade.csv', mode='r') as f:  # r for read, U for unicode
   # reader = csv.reader(f, delimiter=',')
    csv_reader = csv.DictReader(f,delimiter=";")
    # Pass reader object to list() to get a list of lists
    mylist = list(csv_reader)
    x = coll.insert_many(mylist)

