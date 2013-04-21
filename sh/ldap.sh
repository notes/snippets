# ldapsearch for the simplest case
#   -H: server URL
#   -D: bind DN
#   -w: bind password
#   -x: simple authentication (instead of SASL)
#   -b: search base
#   -s: search scope
ldapsearch -H ldap://server:port/ -D cn=admin -w password -x -b cn=base -s sub "(objectclass=user)"

# or write configurations in ~/.ldaprc file
cat >~/.ldaprc <<__LDAPRC__
URI ldap://server:port/
BINDDN cn=admin
__LDAPRC__

