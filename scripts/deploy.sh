#!/bin/bash

entorno=$1
swVersion=$2

if [[ -z ${entorno} ]]; then

  echo "ERROR: Parametros de entrada necesarios"
  echo "1: Entorno (DES, CERT o PROD)"

  exit 1
fi

if [[ -z ${swVersion} ]]; then

  echo "ERROR: Parametros de entrada necesarios"
  echo "2: Version"
  exit 1
fi

chmod 777 ./software/algo.war

