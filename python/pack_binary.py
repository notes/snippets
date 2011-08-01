import struct

# pack 8/16/32/64bit integer in little endian
foo = struct.pack("<BHLQ", 100, 10000, 1000000, 100000000)
# pack 8/16/32/64bit integer in big endian
bar = struct.pack(">BHLQ", 100, 10000, 1000000, 100000000)
# pack with specified count
baz = struct.pack(">5s3H1B", "Hello!", 2**16, 2**15, 2**14, 255)

# unpack little endian
print struct.unpack("<BHLQ", foo)
# unpack big endian
print struct.unpack(">BHLQ", bar)
# unpack with specified count
print struct.unpack(">5s3H1B", baz)

