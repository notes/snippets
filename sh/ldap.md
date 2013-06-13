OpenLDAP Usage
==============

ldapsearch for the simplest case

    ldapsearch -H ldap://server:port/ -D cn=admin -w password -x \
      -b cn=base -s sub "(objectclass=user)"

where options mean:

 * -H: server URL
 * -D: bind DN
 * -w: bind password
 * -x: simple authentication (instead of SASL)
 * -b: search base
 * -s: search scope (base, one, sub)

### Client Configuration

In ldap.conf or ~/.ldaprc:

    URI ldap://server:port/
    BINDDN cn=admin


