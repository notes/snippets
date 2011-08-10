#!/usr/bin/python
# coding: utf-8

import sys
import struct
import mmap
import re
import os

if len(sys.argv) < 2:
    sys.exit("no filename specified")

f = open(sys.argv[1])
m = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
fsize = os.fstat(f.fileno()).st_size

def read_word(m, off):
    return struct.unpack("<H", m[off:off+2])[0]
def read_dword(m, off):
    return struct.unpack("<L", m[off:off+4])[0]
def read_binary(m, off, len):
    return repr(m[off:off+len])
def read_string(m, off, len):
    return re.sub(r"\x00+$", "", m[off:off+len])

# Read MZ header
mz_sig = read_string(m, 0, 2)
mz_last_page = read_word(m, 0x02)
mz_nb_pages = read_word(m, 0x04)
 
print "---MZ Header---"
print "MZ Signature: %s" % mz_sig
print "MZ Last Page Size: %d" % mz_last_page
print "MZ Num of Pages: %d" % mz_nb_pages

pe_base = read_dword(m, 0x3C)
if pe_base > fsize - 4:
    sys.exit("This is pure DOS Executable")
pe_sig = read_binary(m, pe_base, 4)

print "---PE Header---"
print "PE Base: 0x%08X" % pe_base
print "PE Signature: %s" % pe_sig

coff_base = pe_base + 0x04
coff_mach_type = read_word(m, coff_base)
coff_nb_sections = read_word(m, coff_base + 0x02)
coff_timestamp = read_dword(m, coff_base + 0x04)
coff_symtab_base = read_dword(m, coff_base + 0x08)
coff_sz_opt = read_word(m, coff_base + 0x10)

print "---COFF Header---"
print "COFF Machine Type: 0x%04X" % coff_mach_type
print "COFF Num of Sections: %d" % coff_nb_sections
print "COFF Symtab Base: 0x%08X" % coff_symtab_base
print "COFF Option Header Size: %d" % coff_sz_opt

opt_base = coff_base + 0x14
opt_magic = read_word(m, opt_base)
opt_sz_header = read_dword(m, opt_base + 60)

print "---Optional Header---"
print "Optional Magic: 0x%04X (should be 0x010B for PE)" % opt_magic
print "Optional Header Size: %d" % opt_sz_header

TABLE_NAME = {
	0: "Export",
	1: "Import",
	2: "Resource",
}

print "---Tables---"
for table_no in range(16):
	base = opt_base + 96 + 8 * table_no
	va = read_dword(m, base)
	size = read_dword(m, base + 4)
	if va == 0:
		continue
	print "Table %d[%s]" % (table_no, TABLE_NAME.get(table_no))
	print "  Address: 0x%08X" % va
	print "  Size: %d" % size

print "---Sections---"
sec_base = opt_base + coff_sz_opt
print "Sections Base: 0x%08X" % sec_base

sec_size = 0x28
for sec_no in range(coff_nb_sections):
    print "Section %d" % sec_no
    base = sec_base + sec_size * sec_no
    sec_name = read_string(m,base,8)
    print "  Name: %s" % sec_name


