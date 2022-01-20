# Reboot all nodes
# On Node 1
mongosh
> rs.initiate()
# Add member
> rs.add(glmongo01:27017)
> rs.add(glmongo02:27017)
# To view replica set
> rs.conf()
# Connect to replica set
mongo --host glrs/glmongo01,glmongo02,glmongo03
# Some of mongo command
use examples
db.users.insertOne( { name: "David Tio", age: 41, status: "Married" } )
db.users.insertOne( { name: "Truman Tan", age: 45, status: "Single" } )
db.users.insertOne( { name: "Ashley Kim", age: 35, status: "Single" } )
db.users.insertOne( { name: "Jordan Kim", age: 28, status: "Married" } )
db.users.find( {"age": 41} )
db.users.find( { "age": {$lt: 42} } )
db.users.find( { "name": {$regex: "Kim"} } )
db.products.insertMany( [
      { item: "card", qty: 15 },
      { item: "envelope", qty: 20 },
      { item: "stamps" , qty: 30 }
   ] );
// Remove collections
db.users.drop()
// Remove whole database
db.dropDatabase()
