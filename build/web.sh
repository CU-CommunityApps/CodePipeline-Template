#!/bin/bash

API_ID=$(aws cloudformation describe-stacks \
  --stack-name "$APPLICATION-$ENVIRONMENT" \
  --query 'Stacks[0].Outputs[?OutputKey==`Api`].OutputValue' \
  --output text)

aws apigateway get-sdk \
  --rest-api-id "$API_ID" \
  --stage-name 'api' \
  --sdk-type javascript \
  $CODEBUILD_SRC_DIR/build/sdk.zip

unzip \
  $CODEBUILD_SRC_DIR/build/sdk.zip \
  -d $CODEBUILD_SRC_DIR/web/

WEB_BUCKET=$(aws cloudformation describe-stacks \
  --stack-name "$APPLICATION-$ENVIRONMENT" \
  --query 'Stacks[0].Outputs[?OutputKey==`WebBucket`].OutputValue' \
  --output text)

zip $CODEBUILD_SRC_DIR/build/web.zip -r $CODEBUILD_SRC_DIR/web/*
