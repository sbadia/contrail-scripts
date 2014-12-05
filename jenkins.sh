#!/bin/bash
#

sand='sandbox'
here=$(pwd)

cd $here

if [[ -d $sand ]]; then
  echo remove $sand
  rm -rf $sand
fi

mkdir -p $sand ${here}/bin && cd $sand

# Build deps.
apt-get update
apt-get install -y patch scons flex bison make vim unzip libexpat-dev \
  libgettextpo0 libcurl4-openssl-dev python-dev autoconf automake \
  build-essential libtool libevent-dev libxml2-dev libxslt-dev \
  uml-utilities redis-server ant default-jdk liblog4j1.2-java \
  libhttpcore-java libcommons-codec-java javahelper quilt python-all \
  debhelper python-setuptools devscripts git curl python-lxml \
  libprotobuf-dev libxml2-utils protobuf-compiler python-sphinx ruby-ronn

if [ "$(lsb_release -cs)" = "trusty" ]; then
apt-get install -y libboost-dev libboost-chrono-dev libboost-date-time-dev \
  libboost-filesystem-dev libboost-program-options-dev libboost-python-dev \
  libboost-regex-dev libboost-system-dev libboost-thread-dev google-mock \
  libgoogle-perftools-dev liblog4cplus-dev libtbb-dev libhttp-parser-dev libicu-dev
fi

# Use google repo tool
if [[ ! -f ${here}/bin/repo ]]; then
  curl -s http://commondatastorage.googleapis.com/git-repo-downloads/repo > ${here}/bin/repo
 chmod a+x ${here}/bin/repo
fi

# GIT config
git config --global user.name 'OpenContrail Development'
git config --global user.email 'dev@lists.opencontrail.org'

# Init Repo config
${here}/bin/repo init -u https://github.com/Juniper/contrail-vnc.git
curl -s http://pub.sebian.fr/pub/noauth_R1.10.xml > .repo/manifests/noauth_R1.10.xml
${here}/bin/repo sync --no-clone-bundle -m noauth_R1.10.xml


# Fetch third_party
cd third_party
python fetch_packages.py
cd ..

# Build packages
make -f packages.make
