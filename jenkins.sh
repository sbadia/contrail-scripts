#!/bin/bash

sand='sandbox'
here=$(pwd)

cd $here

if [[ -d $sand ]]; then
  echo remove $sand
  rm -rf $sand
fi

mkdir -p $sand ${here}/bin && cd $sand

# Build deps.
apt-get install -y patch scons flex bison make vim unzip libexpat-dev \
  libgettextpo0 libcurl4-openssl-dev python-dev autoconf automake \
  build-essential libtool libevent-dev libxml2-dev libxslt-dev \
  uml-utilities redis-server ant default-jdk liblog4j1.2-java \
  libhttpcore-java libcommons-codec-java javahelper quilt python-all \
  debhelper python-setuptools devscripts git curl python-lxml

# Use google repo tool
if [[ ! -f ${here}/bin/repo ]]; then
  curl -s http://commondatastorage.googleapis.com/git-repo-downloads/repo > ${here}/bin/repo
 chmod a+x ${here}/bin/repo
fi

# GIT config
git config --global user.name 'OpenContrail Development'
git config --global user.email 'dev@lists.opencontrail.org'

# Init Repo config
${here}/bin/repo init -u git://github.com/Juniper/contrail-vnc.git
${here}/bin/repo sync -m noauth.xml -q

# Fetch third_party
cd third_party
python fetch_packages.py
cd ..

# Build packages
make -f packages.make