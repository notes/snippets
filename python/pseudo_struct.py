# similar to ruby's Struct class
# from Python Cookbook
class Struct:
    def __init__(self, **kwds):
        self.__dict__.update(kwds)

o = Struct(f1=1, f2=2, f3=3)
print o.f1, o.f2, o.f3

