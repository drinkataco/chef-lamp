Chef LAMP Recipes for Twilio-Text
===================
Automatically download and configure [twilio-text](https://github.com/drinkataco/twilio-text) for your local virtual machine.

## Installation
Follow the installation instructions for [Chef](https://downloads.chef.io/) and [Vagrant](https://www.vagrantup.com/downloads.html) before following the setup instructions to tailor your server.
Once you have cloned the repository, be sure to run `librarian-chef install` to fetch and install the required dependencies.

## Credentials
For this branch, the database is automatically configured with test credentials.
All you need to do, before build, is add one credential file - `api.json`location in `data_bags/twilio/`.
You need to add this object, with your specific credentials:
```
{
    "sid": "",
    "token": "",
    "from_number": ""
}
```