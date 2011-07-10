import xmlrpclib

x = xmlrpclib.ServerProxy("http://rpc.example.jp:9000/")
print x.method_name("call test")
