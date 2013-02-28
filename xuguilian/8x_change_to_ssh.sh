#!/bin/bash

cd .repo/manifests
git checkout .
git pull
origin_string='git:\/\/192.168.10.91'
new_string='ssh:\/\/git@192.168.10.91\/home\/git\/server'

sed -i "s/$origin_string/$new_string/g" default.xml
repo sync -j4
