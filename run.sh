#!/bin/bash

source keys.sh

build=0
DATABASE_PATH="dev.db"

while getopts ":bd:" opt
do
  case $opt in
    b)
      BUILD=1
      ;;
    d)
      DATABASE_PATH=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [[ "$BUILD" -eq "1" ]]
then
  echo "Building.. "
  go build || exit 1
fi

./agr \
  -database_path "$DATABASE_PATH" \
  -ldb_address "$LDB_ADDRESS" \
  -ldb_token "$LDB_TOKEN" \
  -transportapi_app_id "$TRANSPORTAPI_APP_ID" \
  -transportapi_api_key "$TRANSPORTAPI_API_KEY"
