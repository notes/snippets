# snmpwalk for the simplest case
#   -v: protocol version
#   -c: community name (for v1 or v2)
#   -M: search directory for MIB definitions
#   -m: activate MIB module
#   -On: output OID numerically
#   -Of: output OID with full name
snmpwalk -v2c -cpublic -M+~/.snmp/mibs -mALL -On localhost system

# or write configurations in ~/.snmp/snmp.conf file
cat >~/.snmp/snmp.conf <<__SNMPCONF__
defVersion 2c
defCommunity public
mibdirs +~/.snmp/mibs
mibs ALL
__SNMPCONF__

