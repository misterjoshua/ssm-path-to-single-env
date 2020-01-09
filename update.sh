#!/bin/bash -e

log() {
  echo "$*" >&2;
}

die() {
  die "$*"
  exit 1
}

testCommands() {
  [ ! -z "$(command -v aws)" ] || die "Please install the AWS cli"
  [ ! -z "$(command -v jq)" ] || die "Please install JQ"
}

getParameters() {
  aws ssm get-parameters-by-path --path "$1"
}

putParameter() {
  NAME="$1"
  VALUE="$2"
  aws ssm put-parameter --name "$NAME" --type String --value "$VALUE"
}

convertToDotEnv() {
  jq '.Parameters[] | (.Name | sub(".*/"; ""))+"="+.Value | @text' --raw-output
}

######
# Start
######


SSM_PREFIX=$1
SSM_OUT=$2

testCommands

[ ! -z "$SSM_PREFIX" ] || die "Please specify an ssm path like /dev/next/env"
[ ! -z "$SSM_OUT" ] || die "Please specify an ssm path like /dev/next/env"

DOTENV=$(getParameters "$SSM_PREFIX" | convertToDotEnv)
putParameter "$SSM_OUT" "$DOTENV"
