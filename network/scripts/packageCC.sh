#!/usr/bin/env bash

. scripts/envVar.sh
export FABRIC_CFG_PATH="$PWD/../config"

CC_NAME=basic
CC_SRC_PATH=../config/asset-transfer-basic/chaincode-go/
CC_RUNTIME_LANGUAGE=golang
CC_VERSION=1.0

peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

peer lifecycle chaincode calculatepackageid ${CC_NAME}.tar.gz