#!/bin/bash
user=${1:-test}
path_home_user=${2:-/home/test}

echo USER: $user
echo HOME_PATH: $path_home_user

docker run --user $user --rm test-terraform terraform --version
retour=$?

if [ $retour == 0 ]; then
  echo "[SUCCESS] terraform is installed"
else
  echo "[FAILED] terraform isn't installed"
  exit $retour
fi

res=`docker run --user $user -e path_scripts=$path_home_user/scripts --rm test-terraform /bin/bash -c 'for folder in $(ls $path_scripts); do cd $path_scripts/$folder && terraform init && terraform validate ; done'`

if [[ "$res" =~ "error" ]] || [[ -z $res ]]; then
  echo "[FAILED] Scripts"
  exit 1
else
  echo "[SUCCESS] Scripts"
fi
