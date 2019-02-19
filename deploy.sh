#!/bin/bash -x

while getopts "e:c:i:p:v:" arg; do
  case $arg in
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

[ -z "$version" ] || options="$options --version=${version} "

export IMAGE=${image}

mkdir ~/.gnupg
chmod 700 ~/.gnupg

echo ${password} | gpg2 --batch --import secret.asc
echo ${password} > key.txt
touch dummy.txt
gpg --batch --yes --passphrase-file key.txt --pinentry-mode=loopback -s dummy.txt # sign dummy file to unlock agent

gpg --version
sops --version
helm version
helmfile -v

helm init --client-only
helm plugin install https://github.com/futuresimple/helm-secrets

cd ${chart}

helmfile repos
helmfile charts
