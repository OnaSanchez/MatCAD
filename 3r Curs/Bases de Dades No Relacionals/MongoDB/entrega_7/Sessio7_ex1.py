from pymongo import MongoClient
import json
from options import Options

Host = 'localhost'
Port = 27017

DSN = "mongodb://{}:{}".format(Host,Port)
conn = MongoClient(DSN)

bd = conn['sessiooo7']

if 'products' in bd.list_collection_names():
    coll = bd['products']

print(coll.count_documents({}))


res = coll.find({"category":"pantalones"})
for i in res:
    print(i)
print("-"*256)
res = coll.find({"price":{"$gte" : 20}})
for i in res:
    print(i)