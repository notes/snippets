OpenSSL Usage
=============

### Random number

Generate 10-bytes random data in hex format

    openssl rand -hex 10

Generate 10-bytes random data in base64 format

    openssl rand -base64 10

### Encryption

Encrypt a 16-bytes block using AES-256-ECB algorithm

    echo -n "testtesttesttest" | \
      openssl enc -aes-256-ecb -a -nopad -K $(perl -e 'print "f" x 64')

where options mean:

 * `-a`: output base64 encoded result
 * `-nopad`: error if input is not aligned with 128-bits block
 * `-K`: encryption key (256-bits data because of AES-256-ECB)

---

Encrypt a 16-bytes block using CBC algorithm

    echo -n "testtesttesttest" | \
      openssl enc -aes-256-cbc -a -nopad -K $(perl -e 'print "f" x 64') \
        -iv $(perl -e 'print "f" x 32')

where options mean:

 * `-iv`: initial vector for CBC algorithm

---

Encrypt a 16-bytes block using password-derived key and IV.
Derived key is salted at random unless you specified `-nosalt` option

    echo -n "testtesttesttest" | \
      openssl enc -aes-256-cbc -a -nopad -pass pass:password

where options mean:

 * `-pass`: password for deriving key and IV
   * `file:filename`: read a password from the file
   * `fd:file_descriptor`: read a password from the file descriptor
   * `pass:password`: use the password as is

### PKI

Delete passphrase from an encrypted RSA private key:

    openssl rsa -in encrypted_key.pem -out plain_key.pem

Create new CSR (certificate signing request):

    openssl req -new -newkey rsa:1024 -out csr.pem -keyout key.pem -nodes -days 365 \
      -subj "/C=JP/ST=Tokyo/L=Chiyoda/O=My Company/OU=My Unit/CN=www.example.jp"

where options mean:

 * `-nodes`: do not encrypt private key
 * `-days`: period of validity in days

---

Create a self-signed certificate:

    openssl req -new -newkey rsa:1024 -x509 -out cert.pem -keyout key.pem -nodes -days 365 \
      -subj "/C=JP/ST=Tokyo/L=Chiyoda/O=My Company/OU=My Unit/CN=www.example.jp"

Sign a certificate privided within CSR:

    openssl ca -keyfile ca_key.pem -cert ca_cert.pem -in csr.pem -out cert.pem


References
----------

 * http://www.madboa.com/geek/openssl/
