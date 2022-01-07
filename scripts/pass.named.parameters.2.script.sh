#!/bin/bash

login="my-default-login"

source `dirname "$0"`/commons.sh
changePwd2ScriptsFolder

ARGUMENT_LIST=(
  "db-name"
  "db-login"
)

echo
if [ "$#" -eq 0 ]; then
  echo "ERROR: Wrong usage: no parameters are specified. " && \
  echo && \
  echo "$ `basename "$0"` \\" && \
  echo "         --db-name some-db-name \\" && \
  echo "         --db-login some-db-login" && \
  echo && \
  exit 1
fi

# read arguments
opts=$(
  getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --$opts

#Note:
# db-name and db-login - are parameters in the command line
# db_name and db_login - are variables in this script
while [[ $# -gt 0 ]]; do
  case "$1" in
  --db-name)
    db_name="$2"
    shift 2
    ;;

  --db-login)
    db_login="$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

echo "Login name = \`${db_login}\`."
echo "Database name = \`${db_name}\`."