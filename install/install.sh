#!/bin/bash
set -x

PROGNAME=$0
user=${1:-root}
path_home_user=${2:-/root}
version=${3:-0.11.11}
terraformzip=terraform_${version}_linux_amd64.zip
terraformlink=https://releases.hashicorp.com/terraform/$version/$terraformzip

HOME_DIR=$PWD
echo "HOME_DIR=$HOME_DIR"

usage(){
cat <<EOF
Need to be sudoer or root

How to use
----------
sudo ./$PROGNAME $user $path_home_user $versionterraform

EOF
exit 1
}


requiredInstallYum(){
  yum update -y
  yum install -y epel-release unzip wget 
}

requiredInstallApt(){
  apt update -y
  apt install -y wget unzip vim
}

createUser(){
if [ -z $(id -u $user) ]; then
  echo "user $user doesn't exist"
  useradd -m $user -s /bin/bash
  echo "user $user created"
fi

if [ -f $path_home_user ]; then
  echo "home directory $path_home_directory for $user doesn't exist"
  usage
fi
}

installTerraform(){
wget $terraformlink -P /tmp/
unzip /tmp/$terraformzip -d /usr/local/bin
}

installScriptsTerraform(){
  cp -R ../scripts $path_home_user/
  chown -R $user $path_home_user/scripts
}


main(){

if [ -n "$(command -v yum)" ]; then
  echo "Yum"
  requiredInstallYum
elif [ -n "$(command -v apt-get)" ]; then
  echo "Apt"
  requiredInstallApt
else
  echo [ "don't know" ]
  usage
fi

createUser
installTerraform
installScriptsTerraform
}

while getopts ":h" option; do
    case "${option}" in
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  usage
fi

main
