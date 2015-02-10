OpenBankProject-Virtual machine
=============


##About

Vagrant and Puppet scripts to create a Virtual Box VM running the Open Bank Project Server / API

##Goals

Make it easy for a developer to start running a local instance of the OBP Server / API

##License

Apache 2 

##Status

Works fine with http://files.vagrantup.com/precise64.box, some tweaking and testing in progress

##Setup

The project uses a Vagrant+Puppet to create/modify a virtualbox-machine, so obviously you'll need Vagrant and VirtualBox installed.  
 `apt-get install vagrant virtualbox`

The next step would be to clone this git-repo, if not allready done:  
 `git clone https://github.com/OpenBankProject/OBP-VM`

Finally we have to start the process by calling  
 `vagrant up`  
 (from the root directory)

Now go and grab some coffee, it could take a while :)

After finishing the OpenBankProject-Server should run at [http://127.0.0.1:7070/OBPS](http://127.0.0.1:7070/OBPS)

The entry to the API is
[http://127.0.0.1:8080/OBPS/obp/v1.0](http://127.0.0.1:8080/OBPS/obp/v1.0)

And an example call: [http://127.0.0.1:8080/OBPS/obp/v1.0/banks](http://127.0.0.1:8080/OBPS/obp/v1.0/banks)

For the API documentation see: https://github.com/OpenBankProject/OBP-API/wiki/OBP-Public-Facing-REST-API-V1.0-DRAFT

For ssh access to the vagrant box, the username/password is vagrant/vagrant

##Further commands

Open Postgres shell (password is "obp_password")
(Postgres is used for storing OBP website accounts and oauth accounts)
`vagrant ssh -c "psql -U obp_login -d obp -h localhost"`

Open MongoDB shell
`vagrant ssh -c "mongo localhost/OBP006"`

Create new MongoDB banking database  
`vagrant ssh -c "mongo localhost/OBP006 /vagrant/configs/mktestdb.js"`

Restart jetty  
`vagrant ssh -c "service jetty restart"`

##Future
 - Some GUI at http://127.0.0.1:8080/OBPS/conf?  
 - Place an up to date-warfile in the obps-gitrepo so there's no need to compile on creation of a vm

##Files

`/Vagrantfile`  
Vagrant config file; things like port forwarding and file access for the vm. In fact just  port forwarding and file access for the vm.

`/manifests/default.pp`  
THE puppet file; 

`/configs`  
other files needed like configs for jetty, maven and the mongodb-creation script
