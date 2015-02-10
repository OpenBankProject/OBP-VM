class postgresql-obp {
  package { "postgresql":
    ensure => "present"
  }
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => 'localhost',
    ipv4acls                   => ['host obp obp_login 127.0.0.1/32 md5'],
    require => Package["postgresql"]
  }

  postgresql::server::role { 'obp_login':
    password_hash => postgresql_password('obp_login', 'obp_password'),
    require => Class["postgresql::server"]
  }

  postgresql::server::db { 'obp':
    user     => 'obp_login',
    password => postgresql_password('obp_login', 'obp_password'),
    require => Postgresql::Server::Role['obp_login']
  }

}