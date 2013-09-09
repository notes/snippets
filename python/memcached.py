import memcache

mc = memcache.Client(["192.168.0.1:11211", "192.168.0.2:11211"])
mc.set("key1", "value1")
mc.set("key2", "value2")
value = mc.get("key1")

mc.set("num", "1")
mc.incr("num", 3)
mc.decr("num")

mc.append("key1", ".suffix")
mc.prepend("key1", "prefix.")

