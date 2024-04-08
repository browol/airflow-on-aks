#!/bin/sh

CA_SUBJECT="${1:-/C=TH/CN=browol.io}"
OUTPUT_DIR="certs"

mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR

# Generate root ca key and certificate
openssl genrsa -out root.key 4096
openssl req -new -x509 -days 3650 -subj $CA_SUBJECT -key root.key -out root.crt

# Generate client key, signing key request, and certificate
openssl genrsa -out client.key 2048
openssl req -new -subj $CA_SUBJECT -key client.key -out client.csr
openssl x509 -req -days 365 -in client.csr -CA root.crt -CAkey root.key -CAcreateserial -out client.crt

# Verify client certificate with root certificate
openssl verify -CAfile root.crt client.crt

# Trim header and footer
cat root.crt | sed -e 's#-----.*-----##g' | sed '1d' | sed '$d' > stripped.crt
