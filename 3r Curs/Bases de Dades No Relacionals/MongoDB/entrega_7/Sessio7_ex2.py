from pymongo import MongoClient
import json
from options import Options

Host = 'localhost'
Port = 27017

DSN = "mongodb://{}:{}".format(Host,Port)
conn = MongoClient(DSN)

bd = conn['habitatges']

if 'persona' in bd.list_collection_names():
    pers = bd['persona']
if 'caseta' in bd.list_collection_names():
    casa = bd['caseta']
print(pers.count_documents({}))
print(casa.count_documents({}))


res = casa.find({"$or": [{'Població':'Badalona'}, {'Població':'Santa Fe'}]})
for i in res:
    print(i)
print("-"*256)

res = casa.find_one({"Població":{"$eq" : "Santa Faustina de Vallcentelles"}})
for i in res:
    print(res[i])
