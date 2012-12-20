$config_path = "/configs"
$vagrant_base_path = "/home/vagrant"
Exec { path => "/bin:/usr/bin:/usr/local/bin" }
group { "puppet": ensure => present }
exec { "update": command => "apt-get update" }

######
#installing the required packages
######
class packages {
 package { ["vim", "mongodb", "git-core", "scala", "puppet", "curl", "maven2", "jetty", "openjdk-6-jdk"]: ensure => present, require => Exec["update"] }
 file { ["/OBPS"]: ensure => directory, before => Exec["gitclone"], owner => "vagrant" }
  exec { "gitclone":
  command => "git clone -b master https://github.com/OpenBankProject/OpenBankProject-Server.git /OBPS",
  user => "vagrant",
  require => Package["git-core"],
  creates => "/OBPS/.git"
 }
}

######
#Copying the required files
######
class files {
 file { ["/home/vagrant/.m2"]: ensure => directory, before => File["/home/vagrant/.m2/settings.xml"], owner => "vagrant" }
 file { "/home/vagrant/.m2/settings.xml": ensure => file, source => "${config_path}/settings.xml", owner => "vagrant" }
 file { "props": path => "/OBPS/MavLift/src/main/resources/props", source => "${config_path}/props", recurse => true, owner => "vagrant" }
 file { "/etc/default/jetty": ensure => file, source => "${config_path}/jetty" }
 file { "/OBPS/MavLift/src/main/webapp/WEB-INF/jetty.xml": ensure => file, source => "${config_path}/jetty-web.xml" }
}

######
#compile OBPS
######
class compile {
 exec { "mvn":
  command => "mvn -DskipTests clean dependency:copy-dependencies package",
#vorher schaun, ob schon da, manuell anstossen?
  cwd => "/OBPS/MavLift",
  logoutput => true,
  user => "vagrant",
  timeout => 0,
  creates => "/OBPS/MavLift/target/opan_bank-1.0.war"
 }

######
#Deploying war-file and start jetty
######
 exec { "cpwar": command => "cp -f /OBPS/MavLift/target/opan_bank-1.0.war /usr/share/jetty/webapps/OBPS.war", require => Exec["mvn"] }
 exec { "restartjetty": command => "/etc/init.d/jetty restart", require => Exec["cpwar"] }

#file { "h2db":
#  path => '/OBPS/MavLift/lift_proto.db.h2.db',
#  ensure => 'present',
#  audit  => 'all',
#}
# exec { "createOauthKey": command => "", require => File["h2db"] }
#////insert consumer
#NAME  	KEY_C  	ID  	ISACTIVE  	DESCRIPTION  		UPDATEDATE  	SECRET  	INSERTDATE  	APPTYPE  	DEVELOPEREMAIL  
#app	123				app to test oauth			456

 exec { "mongoimport":
  command => "mongo localhost/OBP006 /vagrant/configs/mktestdb.js",
  user => vagrant
#manuell?
 }
}

stage { ['packages', 'files', 'compile']: }
class {
 "compile": stage => compile;
 "packages": stage => packages;
 "files": stage => files;
}

Stage['packages'] -> Stage['files'] -> Stage['compile']
include packages
include files
include compile
