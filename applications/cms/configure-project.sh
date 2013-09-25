
#!/bin/bash

cd ../..
git submodule update --init --recursive
cd applications/cms/honeybee
git checkout master .
make install
make link-project-app
echo ''
bin/cli user.create -username admin -email admin@example.com
echo ''
cd ..

