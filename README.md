OpenBankProject-Virtual machine
=============


##Status

Note: This VM is currently out of date!

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

Now we import the basebox we'd like to use:  
 `vagrant box add obps http://files.vagrantup.com/precise64.box` for a 64 bit machine 
 or  
 `vagrant box add obps http://files.vagrantup.com/precise32.box` for a 32 bit machine 

Finally we have to start the process by calling  
 `vagrant up`  
 (from the root directory)

Now go and grab some coffee, it could take a while :)

After finishing the OpenBankProject-Server should run at localhost:7070/OBPS  
There is a default user that has all access 
login : tesobe@tesobe.com 
password : 123tesobe456  
There is also by default a registered application to consume the API through the OAuth 1.0
Application key :  123
Application secret : 456

An example API endpoint can be found at: 
http://youripaddress:8080/OBPS/obp/v1.0/postbank/accounts/tesobe/transactions/anonymous

For the API documentation see: https://github.com/OpenBankProject/OBP-API/wiki/OBP-Public-Facing-REST-API-V1.0-DRAFT

For ssh access to the vagrant box, the username/password is vagrant/vagrant

##Further commands

Create new database  
`vagrant ssh -c "mongo localhost/OBP006 /vagrant/mktestdb.js"`

Restart jetty  
`vagrant ssh -c "/etc/init.d/jetty restart"`

...

##Future

-Some GUI at localhost:7070/OBPS/conf?  
-Place an up to date-warfile in the obps-gitrepo so there's no need to compile on creation of a vm

##ToDo

NOTICE in each file
more options for mkmongodb.js  
service { “jetty”: enable => true, ensure => running }  
 servicewatchdirbla

##Files

`/Vagrantfile`  
Vagrant config file; things like port forwarding and file access for the vm. In fact just  port forwarding and file access for the vm.

`/manifests/default.pp`  
THE puppet file; 

`/configs`  
other files needed like configs for jetty, maven and the mongodb-creation script

##Contact
