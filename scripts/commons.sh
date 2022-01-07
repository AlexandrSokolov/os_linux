function changePwd2ScriptsFolder() {
  echo "The script you are running located in `dirname "$0"`"
  echo "The present working directory is `pwd`"

  # change the present working directory to the folder, containing the script:
  cd "`dirname "$0"`"
  echo "The directory for running the script has been switched to `pwd`"
}

# Run this function from your script as:
# path=$1
# curr_script_name=`basename "$0"`
# validateNotEmptyPath $curr_script_name $path
function validateNotEmptyPath() {
  local running_script_name=$1;
  local expected_param=$2;
  if [ -z "$expected_param" ]; then
    echo "The path param is not specified. Run this script as: ./$running_script_name \${path}" && exit 1
  fi
}

# Run this function as:
# path=$1
# package_path=$(fullPath $path)
function fullPath() {
  local package_path=$1;
  if [[ $package_path == /* ]]
    then
      echo "Absolute path is specified: $package_path" >&2
    else
      echo "Relative path is specified: $package_path" >&2
      package_path=$(pwd)/$package_path
      echo "Package full path: $package_path" >&2
  fi
  echo "$package_path"
}