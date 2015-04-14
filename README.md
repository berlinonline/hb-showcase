# Honeybee CMF Project Template

This template should get you started with a new Honeybee based project.

## Installation on Host System

Prerequisites:

1. [VirtualBox](https://www.virtualbox.org/)
1. [Vagrant](http://www.vagrantup.com/)

Create a virtual machine for development:

1. ```git clone git@github.com:berlinonline/hb-showcase.git```
1. ```cd hb-showcase-cms```
1. ```git submodule update --init --recursive``` (to get puppet recipes)
1. ```cd dev/box```
1. ```vagrant up```

## Installation inside the Virtual Machine

1. ```vagrant ssh```
1. ```cd /srv/www/hb-showcase.local/```
1. ```git clone git clone git@github.com:berlinonline/hb-showcase.git .```
1. ```make install```
1. ```bin/cli core.migrate.run``` 

## First User Account

1. ```cd /srv/www/hb-showcase.local/``` (inside the vagrant box)
1. ```bin/cli user.create -username yourname -email youremail@example.com```
1. visit the given URL and set a password for that account

## Development

Either use `vim` in the box or mount the project's `cms` folder from the box to
your host system via `nfs` (nfs server is installed in the box).
