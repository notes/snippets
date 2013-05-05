# cf) http://www.madboa.com/geek/openssl/

# generate 10-bytes random data in hex format
openssl rand -hex 10

# generate 10-bytes random data in base64 format
openssl rand -base64 10

# encrypt a 16-bytes block using AES-256-ECB algorithm
#   -a: output base64 encoded result
#   -nopad: error if input is not aligned with 128-bits block
#   -K: encryption key (256-bits data because of AES-256-ECB)
echo -n "testtesttesttest" | openssl enc -aes-256-ecb -a -nopad -K $(perl -e 'print "f" x 64')

# ditto using CBC algorithm
#   -iv: initial vector for CBC algorithm
echo -n "testtesttesttest" | \
  openssl enc -aes-256-cbc -a -nopad -K $(perl -e 'print "f" x 64') -iv $(perl -e 'print "f" x 32')

# ditto using password derived key and IV
# derived key is salted at random unless you specified -nosalt option
#   -pass: password for deriving key and IV
#          file:filename or fd:file_descriptor can be specified
echo -n "testtesttesttest" | openssl enc -aes-256-cbc -a -nopad -pass pass:password

# delete passphrase from encrypted RSA private key
openssl rsa -in encrypted_key.pem -out plain_key.pem

# create new CSR (certificate signing request)
#   -nodes: not encrypt private key
#   -days: 
openssl req -new -newkey rsa:1024 -out csr.pem -keyout key.pem -nodes -days 365 \
  -subj "/C=JP/ST=Tokyo/L=Chiyoda/O=My Company/OU=My Unit/CN=www.example.jp"

# create self-signed certificate
openssl req -new -newkey rsa:1024 -x509 -out cert.pem -keyout key.pem -nodes -days 365 \
  -subj "/C=JP/ST=Tokyo/L=Chiyoda/O=My Company/OU=My Unit/CN=www.example.jp"

# sign certificate privided within CSR
openssl ca -keyfile ca_key.pem -cert ca_cert.pem -in csr.pem -out cert.pem


