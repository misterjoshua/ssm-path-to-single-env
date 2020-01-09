#!/bin/bash -e

log() {
  echo "$*" >&2;
}

usage() {
  log "Usage: ${SCRIPT_NAME} <ssm-path-prefix> [ssm-output-path]"
  log "$*"
  exit 1
}

die() {
  die "$*"
  exit 1
}

getParameters() {
  aws ssm get-parameters-by-path --path "$1"
}

putParameter() {
  NAME="$1"
  VALUE="$2"
  aws ssm put-parameter --name "$NAME" --type String --overwrite --value "$VALUE"
}

convertToDotEnv() {
  jq '.Parameters[] | (.Name | sub(".*/"; ""))+"="+.Value | @text' --raw-output | sort
}

######
# Start
######

[ ! -z "$(command -v aws)" ] || die "Please install the AWS cli"
[ ! -z "$(command -v jq)" ] || die "Please install jq"

SCRIPT_NAME=$0
SSM_PREFIX=$1
SSM_OUT=$2

[ ! -z "$SSM_PREFIX" ] || usage "Please specify an ssm path prefix like /dev/system-name/env"

DOTENV=$(getParameters "$SSM_PREFIX" | convertToDotEnv)
if [ ! -z "$SSM_OUT" ]; then
  log "Putting the .env into $SSM_OUT"
  putParameter "$SSM_OUT" "$DOTENV"
else
  cat <<<$DOTENV
fi
