#!/bin/bash

cd ../..
git submodule update --init --recursive
cd applications/cms/honeybee
git checkout master .
make install
echo ''
echo 'You may now create your master admin account via:'
echo ''
echo 'bin/cli user.create -username admin -email admin@example.com'
echo ''

