#!/bin/bash

source keys.sh

./agr \
  -ldb_address $LDB_ADDRESS \
  -ldb_token $LDB_TOKEN \
  -transportapi_app_id $TRANSPORTAPI_APP_ID \
  -transportapi_api_key $TRANSPORTAPI_API_KEY
