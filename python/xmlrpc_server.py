from SocketServer import ForkingMixIn
from SimpleXMLRPCServer import SimpleXMLRPCServer

class MyApiHandler:
    def _dispatch(self, name, params):
        return "ok"

# the order of inheritance is important
class ForkingXMLRPCServer(ForkingMixIn, SimpleXMLRPCServer):
    pass

if __name__ == "__main__":
    endpoint = ("0.0.0.0", 9000)
    handler = MyApiHandler()
    x = ForkingXMLRPCServer(endpoint)
    x.register_instance(handler)
    x.allow_reuse_address = True
    x.serve_forever()
