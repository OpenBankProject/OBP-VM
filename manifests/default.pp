$config_path = "/vagrant/configs"
$vagrant_base_path = "/home/vagrant"
$maven3_version= "3.2.5"

Exec { path => "/bin:/usr/bin:/usr/local/bin" }

Exec["apt-get-update"] -> Package <| |>

exec { "apt-get-update":
  command => "apt-get update"
}

######
#installing the required packages
######
class packages {
  package { ["mongodb", "git-core", "curl", "wget", "jetty", "openjdk-7-jdk"]:
    ensure => present
  }
  file { ["/OBPS"]:
    ensure => directory,
    before => Exec["gitclone"],
    owner => "vagrant"
  }
  exec { "maven-download":
    command => "wget http://www.eu.apache.org/dist/maven/maven-3/${maven3_version}/binaries/apache-maven-${maven3_version}-bin.tar.gz",
    cwd => "${vagrant_base_path}",
    user => "vagrant",
    creates => "${vagrant_base_path}/apache-maven-${maven3_version}-bin.tar.gz",
    require => Package["wget"]
  }
  exec { "maven-unpack":
    command => "tar -xzf apache-maven-${maven3_version}-bin.tar.gz",
    user => "vagrant",
    creates => "${vagrant_base_path}/apache-maven-${maven3_version}",
    require => Exec["maven-download"]
  }
}

######
#Configure packages
######
class packages-config {
  file { ["/home/vagrant/.m2"]:
    ensure => directory,
    before => File["/home/vagrant/.m2/settings.xml"],
    owner => "vagrant"
  }
  file { "/home/vagrant/.m2/settings.xml":
    ensure => file,
    source => "${config_path}/settings.xml",
    owner => "vagrant"
  }
  file { "/etc/default/jetty": 
    ensure => file,
    source => "${config_path}/jetty",
    owner => "root",
    group => "root",
    mode => "0444"
  }
}

######
#Checking out the source code
######
class source {
  exec { "gitclone":
    command => "git clone -b master https://github.com/OpenBankProject/OBP-API.git",
    user => "vagrant",
    cwd => "/OBPS",
    creates => "/OBPS/OBP-API/.git",
    require => Package["git-core"]
  }
}

######
#Copying the required source config files
######
class source-config {
  file { "/OBPS/OBP-API/src/main/webapp/WEB-INF/jetty.xml": 
    ensure => file,
    source => "${config_path}/jetty-web.xml",
    owner => "vagrant",
    require => Exec["gitclone"]
  }
  file { "/OBPS/OBP-API/src/main/resources":
    ensure => directory,
    owner => "vagrant",
    require => Exec["gitclone"]
  }
  file { "/OBPS/OBP-API/src/main/resources/props":
    ensure => directory,
    owner => "vagrant",
    require => File["/OBPS/OBP-API/src/main/resources"]
  }
  file { "props": 
    path => "/OBPS/OBP-API/src/main/resources/props/default.props", 
    source => "${config_path}/default.props", 
    owner => "vagrant",
    require => File["/OBPS/OBP-API/src/main/resources/props"]
  }
}

######
#Compiling OBPS
######
class compile {
  exec { "mvn":
    command => "${vagrant_base_path}/apache-maven-${maven3_version}/bin/mvn -DskipTests clean dependency:copy-dependencies package",
    cwd => "/OBPS/OBP-API",
    logoutput => true,
    user => "vagrant",
    timeout => 0,
    creates => "/OBPS/OBP-API/target/OBP-API-1.0.war"
 }
}

######
#Configure data stores
######
class datastore-config {
  exec { "mongoimport":
    command => "mongo localhost/OBP006 ${config_path}/mktestdb.js",
    user => vagrant
  }
  # Make use of postgresql
  class { "postgresql-obp":}
}

######
#Deploying war-file and start jetty
######
class deploy {
  exec { "cpwar": command => "cp -f /OBPS/OBP-API/target/OBP-API-1.0.war /usr/share/jetty/webapps/OBPS.war", require => Exec["mvn"] }
  exec { "restartjetty": command => "/etc/init.d/jetty restart", require => Exec["cpwar"] }
}

stage { ['packages', 'source', 'compile', 'datastore-config','deploy']: }

class {
  "packages": stage => packages;
  "packages-config": stage => packages;
  "source": stage => source;
  "source-config": stage => source;
  "compile": stage => compile;
  "datastore-config": stage => datastore-config;
  "deploy": stage => deploy
}

Stage['packages'] -> Stage['source'] -> Stage['compile'] -> Stage['datastore-config'] -> Stage['deploy']
