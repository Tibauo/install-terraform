#!/bin/bash
docker run --rm test-terraform terraform --version
retour=$?

if [ $retour == 0 ]; then
  echo "[SUCCESS] terraform is installed"
else
  echo "[FAILED] terraform isn't installed"
  exit $retour
fi


res=`docker run --rm test-terraform /bin/bash -c 'path_scripts=/home/tibo/scripts && for folder in $(ls $path_scripts); do cd $path_scripts/$folder && terraform init && terraform validate ; done'`

if [[ "$res" =~ "error" ]] || [[ -z $res ]]; then
  echo "[FAILED] Scripts"
  echo $res
  exit 1
else
  echo "[SUCCESS] Scripts"
fi
