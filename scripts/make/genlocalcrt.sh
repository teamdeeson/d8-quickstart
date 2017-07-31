#!/usr/bin/env bash

DIR=${1-.}
OPENSSL=`which openssl`

if [ -f ${DIR}/local.key ] && [ -f ${DIR}/local.crt ]; then
    echo 'Certificate exists';
    exit;
fi
$OPENSSL genrsa -des3 -passout pass:x -out ${DIR}/local.pass.key 2048
$OPENSSL rsa -passin pass:x -in ${DIR}/local.pass.key -out ${DIR}/local.key
rm ${DIR}/local.pass.key
$OPENSSL req -new -x509 -nodes -sha1 -days 3650 \
    -key ${DIR}/local.key -out ${DIR}/local.crt \
    -subj "/C=GB/ST=Local/L=Local/O=Local/CN=localhost"


