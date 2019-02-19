#!/bin/bash -x

while getopts "e:c:i:p:v:" arg; do
  case $arg in
    e)
      env=$OPTARG
      ;;
    c)
      chart=$OPTARG
      ;;
    i)
      image=$OPTARG
      ;;
    p)
      password=$OPTARG
      ;;
    v)
      version=$OPTARG
      ;;
  esac
done

mkdir ~/.gnupg
chmod 700 ~/.gnupg

gpg --version
sops --version
helm version

echo ${password} | gpg2 --batch --import secret.asc
echo ${password} > key.txt
touch dummy.txt
gpg --batch --yes --passphrase-file key.txt --pinentry-mode=loopback -s dummy.txt # sign dummy file to unlock agent

helm init --client-only
helm plugin install https://github.com/futuresimple/helm-secrets

[ -z "$env" ] && env="prod"

[ -z "$version" ] || options="$options --version=${version} "

export IMAGE=${image}

sh /usr/local/bin/helmfile repos
sh /usr/local/bin/helmfile -f ${chart}/${env}/helmfile.yaml
