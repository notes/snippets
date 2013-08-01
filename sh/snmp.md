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

    # snmpwalk -v2c -cpublic -M+~/.snmp/mibs -mALL -On localhost system

Or write configurations in `~/.snmp/snmp.conf`:

    defVersion 2c
    defCommunity public
    mibdirs +~/.snmp/mibs
    mibs ALL

### snmptranslate

Convert OID to name

    # snmptranslate 1.3.6.1.2.1.6.13
    TCP-MIB::tcpConnTable

Convert name to OID

    # snmptranslate -IR -On tcpConnTable
    .1.3.6.1.2.1.6.13

Dump object definition

    # snmptranslate -IR -Td ifTable
    RFC1213-MIB::ifTable
    ifTable OBJECT-TYPE
      -- FROM    RFC1213-MIB, IF-MIB
      MAX-ACCESS    not-accessible
      STATUS    mandatory
      DESCRIPTION    "A list of interface entries.  The number of
                entries is given by the value of ifNumber."
    ::= { iso(1) org(3) dod(6) internet(1) mgmt(2) mib-2(1) interfaces(2) 2 }

Dump MIB tree

    # snmptranslate -IR -Tp sysORTable
    +--sysORTable(9)
       |
       +--sysOREntry(1)
          |  Index: sysORIndex
          |
          +-- ---- INTEGER   sysORIndex(1)
          |        Range: 1..2147483647
          +-- -R-- ObjID     sysORID(2)
          +-- -R-- String    sysORDescr(3)
          |        Textual Convention: DisplayString
          |        Size: 0..255
          +-- -R-- TimeTicks sysORUpTime(4)
                   Textual Convention: TimeStamp

### snmptable

Search and pretty-print arbitrary table

    # snmptable localhost ipAddrTable
    SNMP table: RFC1213-MIB::ipAddrTable
    
      ipAdEntAddr ipAdEntIfIndex ipAdEntNetMask ipAdEntBcastAddr ipAdEntReasmMaxSize
        127.0.0.1              1      255.0.0.0                1                   ?
     192.168.11.2              5  255.255.255.0                1                   ?

### snmpdf

Search and pretty-print `HOST-RESOURCES-MIB::hrStorageTable`

    # snmpdf localhost
    Description              size (kB)            Used       Available Used%
    /                        155451296       116689596        38761700   75%
    /dev                           182             182               0  100%
    /net                             0               0               0    0%
    /home                            0               0               0    0%

### snmpnetstat

Search and pretty-print `TCP-MIB::tcpConnTable`

    # snmpnetstat -Cn -Cp tcp localhost 
    Active Internet (tcp) Connections
    Proto Local Address          Remote Address         (state)
    tcp   *.*                    *.*                   CLOSED
    tcp   127.0.0.1.26165        127.0.0.1.49172       ESTABLISHED
    tcp   127.0.0.1.49172        127.0.0.1.26165       ESTABLISHED
    tcp   192.168.11.2.55570     108.222.44.52.80      ESTABLISHED
    tcp   192.168.11.2.55579     74.126.32.99.443      ESTABLISHED
    tcp   192.168.11.2.56341     108.122.221.98.443    LASTACK

### snmptrapd

Write configurations in `snmptrapd.conf`:

    # v1/v2c authentication
    authCommunity log,execute,net public
    
    # RFC1157 Trap-PDU (v1) logging format
    format1 %B: SNMPv1, enterprise=%N, generic-trap=%w, specific-trap=%q
    
    # RFC3416 SNMPv2-Trap-PDU (v2/v3) logging format
    format2 %B: SNMPv2, %V, % %v
    
    # same as -On command line option
    outputOption n

