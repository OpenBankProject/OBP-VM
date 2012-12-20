OpenBankProject-Virtual machine
=============

##ABOUT

This project is about

##GOALS

##LICENSE

##STATUS

Works fine with http://files.vagrantup.com/precise64.box, some tweaking and testing in progress

##SETUP

The project uses a Vagrant+Puppet to create/modify a virtualbox-machine,
so obvious you'll need Vagrant and VirtualBox installed.<br>
 `apt-get install vagrant virtualbox`

The next step would be to clone this git-repo, if not allready done:<br>
 `git clone https://github.com/OpenBankProject/OBP-VM`

Now we import the basebox we'd like to use:<br>
 `vagrant box add base http://files.vagrantup.com/precise64.box`<br>
 or<br>
 `vagrant box add base http://files.vagrantup.com/precise32.box`

Finally we have to start the process by calling<br>
 `vagrant up`<br>
 (from the directory this README is in)

Now go and grab some coffee, it could take a while :)

After finishing the OpenBankProject-Server should run at localhost:7070/OBPS

##FUTURE

-Some GUI at localhost:7070/OBPS/conf?<br>
-Place an up to date-warfile in the obps-gitrepo so there's no need to compile on creation of a vm

##TD

more options for mkmongodb.js<br>
service { “jetty”: enable => true, ensure => running }<br>
 servicewatchdirbla

##Files

`/Vagrantfile`<br>
bla

`/manifests/default.pp`<br>
blub

`/configs`<br>
peng

##CONTACT
