Chef LAMP Recipes and Cookbooks
===================
A reusable and extensible collection of cookbooks for provisioning a LAMP server using Chef and Vagrant.

## Installation
Follow the installation instructions for [Chef](https://downloads.chef.io/) and [Vagrant](https://www.vagrantup.com/downloads.html) before following the setup instructions to tailor your server.
Once you have cloned the repository, be sure to run `librarian-chef install` to fetch and install the required dependencies.

## Setup
In order to work with Vagrant, a valid [VagrantFile](https://www.vagrantup.com/docs/vagrantfile/) must be created alongside the root of this repository, and a corresponding node such as the example in `nodes/vagrant.template.json`.
If you want to get quickly started, you can just clone this repository and run `vagrant up`.

### Creating a Node
Copy the template in `nodes` and make sure it is referenced in your VagrantFile. You can adjust app attributes, and adjust the runlist to add your own cookbooks, etc.

### Setting up Mariadb
The custom cookbook called `database` can be used to set up a default database and user. Just create a data bag named `database/mariadb.json` with the following attributes:
```
{
    "database": "database_name",
    "username": "database_user",
    "password": "database_password"
}
```

### Setting up Apache2
You can create your own virtualhost file in `site-cookbooks/webserver/templates/default`, adjusting your node file so that the attribute `app.vhost_filename` contains this new name.

### Using Source Control
You can add git configuration to autofetch from a repository if it doesn't exist yet in your vagrant mountpoint. Just create a new databag named `git/remote.json` with the following attributes
```
{
    "location": "https://giturl/example/test.git",
    "username": "username",
    "password": "password"
}
```

# Custom Cookbooks
You can create your custom cookbooks, and add them to your node runlist. These could include scrips to add environment variables (defined in custom data_bags), or to initialise composer for the project.