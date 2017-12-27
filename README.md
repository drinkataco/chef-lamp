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

### Creating a Node
<Node chef explanation>

<Just use node.template and adjust name, but you can override default attributes here>

### Setting up Mariadb
data_bags/database/mariadb

### Setting up Apache2
vhost set up

### Using Source Control
You can add git configuration to autofetch from a repository, although the preferred way is to clone directly to your local machines folder which is shared with vagrant.

## Tailoring chef-lamp for your needs
Other than their template counterparts; data bags, nodes, custom cookbooks, and the VagrantFile, have been added to the .gitignore file, so that these will persist and you can still keep in line with the repository remote.
However, I recommend that any configuration (except for sensitive data in the databags) be committed to your own repo – and the sections noted in the gitignore file removed, especially if your configurations and custom cookbooks really should be tracked. This way, you'll also be able to manage the Cheffile more appropriatly without it possible being over written by the remote.

# Custom Cookbooks