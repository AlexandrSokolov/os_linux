#!/usr/bin/env bash

script_path=$(pwd)

if [ ! -z "$(dirname "$0")" ]; then
  # this script is run as `./scripts/extendPath.sh`, but not as `./extendPath.sh`
  script_path=${script_path}/$(dirname "$0")
fi

script_path=${script_path//"/."} # remove `/.` from the path

echo "This script allows you to run any script located in:"
echo
echo "\`${script_path}\` from any other directory."
echo
echo "It does so by adding this folder to the \`PATH\` variable in \`~/.profile\` file"
echo

profile_file=~/.profile

if grep -q $script_path $profile_file
  then
    echo "Already added in the $script_path"
  else
    echo $'\n'PATH=\$PATH:"$script_path" >> $profile_file
fi

echo "Run manually to apply changes without bash session restart: "
echo ". ~/.profile"