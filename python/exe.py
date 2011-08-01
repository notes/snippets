#!/usr/bin/python
# coding: utf-8

import sys
import struct
import mmap
import re

if len(sys.argv) < 2:
    sys.exit("no filename specified")

f = open(sys.argv[1])
m = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)

def read_word(m, off):
    return struct.unpack("<H", m[off:off+2])[0]
def read_dword(m, off):
    return struct.unpack("<L", m[off:off+4])[0]
def read_binary(m, off, len):
    return repr(m[off:off+len])
def read_string(m, off, len):
    return re.sub(r"\x00+$", "", m[off:off+len])

mz_sig = m[0:2]
pe_base = read_dword(m,0x3C)
sec_base = pe_base+0xF8
pe_sig = read_binary(m,pe_base,4)
nb_sections = read_word(m,pe_base+0x04+0x02)
symtab_base = read_dword(m,pe_base+0x04+0x08)

print "MZ signature: %s" % mz_sig
print "PE base: 0x%08X" % pe_base
print "PE signature: %s" % pe_sig
print "Sections base: 0x%08X" % sec_base
print "Num of sections: %d" % nb_sections
print "Symtab base: 0x%08X" % symtab_base

sec_size = 0x28
for sec_no in range(nb_sections):
    print "Section %d" % sec_no
    base = sec_base + sec_size * sec_no
    sec_name = read_string(m,base,8)
    print "  Name: %s" % sec_name


