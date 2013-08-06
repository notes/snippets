CouchDB
=======

Install:

    $ sudo yum install couchdb
    
Startup:

    $ sudo /etc/init.d/couchdb start
    
Check if it's running:

    $ curl http://localhost:5984/
    {"couchdb":"Welcome","version":"1.0.4"}

Browse Web interface:

    $ firefox http://localhost:5984/_utils

List all databases:

    $ curl http://localhost:5984/_all_dbs
    ["_users"]
    
Check database info:

    $ curl http://localhost:5984/_users
    {"db_name":"_users","doc_count":1,"doc_del_count":0,"update_seq":1,"purge_seq":0,"compact_running":false,"disk_size":4185,"instance_start_time":"1375796833411142","disk_format_version":5,"committed_update_seq":1}

Create a database:

    $ curl -X PUT http://localhost:5984/curldb
    {"ok":true}
    $ curl http://localhost:5984/curldb
    {"db_name":"curldb","doc_count":0,"doc_del_count":0,"update_seq":0,"purge_seq":0,"compact_running":false,"disk_size":79,"instance_start_time":"1375798332797169","disk_format_version":5,"committed_update_seq":0}

Delete a database:

    $ curl -X DELETE http://localhost:5984/curldb
    {"ok":true}
    $ curl http://localhost:5984/curldb
    {"error":"not_found","reason":"no_db_file"}

Create and get a record:

    $ curl -X PUT http://localhost:5984/example/hello --data '{"message":"Hello, World!"}'
    {"ok":true,"id":"hello","rev":"1-8d474d5880503237d1e3747a072a7138"}
    $ curl http://localhost:5984/example/hello 
    {"_id":"hello","_rev":"1-8d474d5880503237d1e3747a072a7138","message":"Hello, World!"}

Update a record (pay attention to the "_rev" key):

    $ curl -X PUT http://localhost:5984/example/hello --data '{"_rev":"1-8d474d5880503237d1e3747a072a7138","message":"Hello, CouchDB!"}'
    {"ok":true,"id":"hello","rev":"2-e0f44e0097f297ee7b7f6d0868b1f59f"}
    $ curl http://localhost:5984/example/hello {"_id":"hello","_rev":"2-e0f44e0097f297ee7b7f6d0868b1f59f","message":"Hello, CouchDB!"}


Create a view (sort of stored procedure) and use it:

    $ curl -X PUT http://localhost:5984/example/_design/render --data '{"shows": {"salute": "function(doc, req) {return {body: doc.message }}"}}'
    {"ok":true,"id":"_design/render","rev":"1-ffae7d6820765a76a31014a903b07493"}
    $ curl http://localhost:5984/example/_design/render/_show/salute/hello
    Hello, World!

