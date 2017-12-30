Chef LAMP Recipes and Cookbooks
===================
A reusable and extensible collection of cookbooks for provisioning a LAMP server using Chef and Vagrant.

## Installation
Follow the installation instructions for [Chef](https://downloads.chef.io/) and [Vagrant](https://www.vagrantup.com/downloads.html) before following the setup instructions to tailor your server.
Once you have cloned the repository, be sure to run `librarian-chef install` to fetch and install the required dependencies.

## Setup
In order to work with Vagrant, a valid [VagrantFile](https://www.vagrantup.com/docs/vagrantfile/) must be created alongside the root of this repository, and a corresponding node such as the example in `nodes/vagrant.template.json`.
If you want to get quickly started, you can copy the contents for this file from the file named `VagrantFile.template`, and use the example node template.
You can then, run `vagrant up` to initialise your virtual machine. This will install all the default packages.
