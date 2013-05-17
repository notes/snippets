SNMP Tools Usage
================

Options:

 * -v: protocol version
 * -c: community name (for v1 or v2)
 * -M: search directory for MIB definitions
 * -m: activate MIB module
 * -On: output OID numerically
 * -Of: output OID with full name

snmpwalk for the simplest case:

    snmpwalk -v2c -cpublic -M+~/.snmp/mibs -mALL -On localhost system

Or write configurations in ~/.snmp/snmp.conf file:

    defVersion 2c
    defCommunity public
    mibdirs +~/.snmp/mibs
    mibs ALL
