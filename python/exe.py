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

mz_sig = read_string(m, 0, 2)
pe_base = read_dword(m, 0x3C)

pe_sig = read_binary(m, pe_base, 4)

coff_base = pe_base + 0x04
mach_type = read_word(m, coff_base)
nb_sections = read_word(m, coff_base + 0x02)
timestamp = read_dword(m, coff_base + 0x04)
symtab_base = read_dword(m, coff_base + 0x08)
coff_sz_opt = read_word(m, coff_base + 0x10)

opt_base = coff_base + 0x14
opt_magic = read_word(m, opt_base)
opt_sz_header = read_dword(m, opt_base + 60)

sec_base = opt_base + coff_sz_opt

print "MZ signature: %s" % mz_sig
print "PE base: 0x%08X" % pe_base
print "PE signature: %s" % pe_sig
print "Machine Type: 0x%04X" % mach_type
print "Sections base: 0x%08X" % sec_base
print "Num of sections: %d" % nb_sections
print "Symtab base: 0x%08X" % symtab_base
print "Option Header Size: %d" % coff_sz_opt

print "Option Magic: 0x%04X" % opt_magic
print "All Header Size: %d" % opt_sz_header

TABLE_NAME = {
	0: "Export",
	1: "Import",
	2: "Resource",
}

for table_no in range(16):
	base = opt_base + 96 + 8 * table_no
	va = read_dword(m, base)
	size = read_dword(m, base + 4)
	if va == 0:
		continue
	print "Table %d[%s]" % (table_no, TABLE_NAME.get(table_no))
	print "  Address: 0x%08X" % va
	print "  Size: %d" % size

sec_size = 0x28
for sec_no in range(nb_sections):
    print "Section %d" % sec_no
    base = sec_base + sec_size * sec_no
    sec_name = read_string(m,base,8)
    print "  Name: %s" % sec_name


