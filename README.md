# Honeybee CMF Project Template

This template should get you started with a new Honeybee based project.

## Installation on Host System

Prerequisites:

1. [VirtualBox](https://www.virtualbox.org/)
1. [Vagrant](http://www.vagrantup.com/)
1. [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) - install via: ```vagrant plugin install vagrant-vbguest```
1. [Puppet](http://puppetlabs.com/puppet/puppet-open-source)

Create a virtual machine for development:

1. ```git clone git@github.com:berlinonline/hb-showcase.git hb-showcase-cms```
1. ```cd hb-showcase-cms```
1. ```git submodule update --init --recursive``` (to get puppet recipes)
1. ```cd development/project/boxes/hb-showcase```
1. ```vagrant up --provision```

## Installation inside the Virtual Machine

1. ```vagrant ssh```
1. ```./init_cms.sh``` (clones ```hb-showcase``` and runs ```make install```)
1. ...wait...
1. accept all the default settings
1. visit http://hb-showcase-cms.local/

## First User Account

1. ```vagrant ssh``` (on the host system in the ```development/project/boxes/hb-showcase``` folder)
1. ```cd ~/projects/hb-showcase-cms/applications/cms``` (in the box)
1. ```bin/cli core.common.queue_spinner``` (run it in the background in the box)
1. ```bin/cli user.create -username yourname -email youremail@example.com```
1. visit the given URL and set a password for that account

## Development

Either use `vim` in the box or mount the project's `cms` folder from the box to
your host system via `nfs` (nfs server is installed in the box).
