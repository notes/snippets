Net-SNMP Usage
==============

Client tools common options:

 * `-v`: protocol version
 * `-c`: community name (for v1 or v2)
 * `-M`: search directory for MIB definitions
 * `-m`: activate MIB module
 * `-On`: output OID numerically
 * `-Of`: output OID with full name

snmpwalk for the simplest case:

    snmpwalk -v2c -cpublic -M+~/.snmp/mibs -mALL -On localhost system

Or write configurations in `~/.snmp/snmp.conf` file:

    defVersion 2c
    defCommunity public
    mibdirs +~/.snmp/mibs
    mibs ALL

### snmptrapd

Write configurations in `snmptrapd.conf` file:

    # v1/v2c authentication
    authCommunity log,execute,net public
    
    # RFC1157 Trap-PDU (v1) logging format
    format1 %B: SNMPv1, enterprise=%N, generic-trap=%w, specific-trap=%q
    
    # RFC3416 SNMPv2-Trap-PDU (v2/v3) logging format
    format2 %B: SNMPv2, %V, % %v
    
    # same as -On command line option
    outputOption n

