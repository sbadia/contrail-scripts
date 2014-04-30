#!/bin/bash

mkdir -p apt

distro='apt/precise apt/trusty'

for package in $(cat opencontrail-backports.list); do
  wget -q $package
done

for deb in $(ls *.deb); do
  freight add $deb $distro
done
