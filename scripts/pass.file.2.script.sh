#!/bin/bash

source `dirname "$0"`/commons.sh
#changePwd2ScriptsFolder

echo
path=$1
curr_script_name=`basename "$0"`
validateNotEmptyPath $curr_script_name $path

file_path=$(fullPath $path)
file_name=$(basename $file_path)
echo "File basename: ${file_name}"
echo

#change pwd, only after getting $package_path
changePwd2ScriptsFolder