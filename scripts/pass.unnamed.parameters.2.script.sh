#!/bin/bash

login="my-default-login"

source `dirname "$0"`/commons.sh
changePwd2ScriptsFolder

# Passing the 1st parameter is required (for instance database name)
# The 2nd parameter is optional (for instance login)

echo
if [ "$#" -eq 0 ]; then
  echo "ERROR: Wrong usage: no parameters are specified. " && \
  echo "At least database name parameter must be set: " && \
  echo && \
  echo "        $ `basename "$0"` your-db-name" && \
  echo && \
  echo "NOTE: Default \`${login}\` is used." && \
  echo && \
  echo "To overwrite the default login, run:" && \
  echo && \
  echo "        $ `basename "$0"` your-db-name custom-login" && \
  echo && \
  exit 1
elif [ "$#" -eq 1 ]; then
  db_name=$1
  echo "Default \`${login}\` login used."
elif [ "$#" -eq 2 ]; then
  db_name=$1
  login=$2
  echo "Login = \`${login}\`."
fi

echo "Database name = \`$db_name\`."