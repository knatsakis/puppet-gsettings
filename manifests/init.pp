class gsettings {
  package {
    'libglib2.0-dev':
      ensure => installed;
    'libgirepository1.0-dev':
      ensure => installed;
  } ->
  package { 'gio2':
    ensure   => installed,
    provider => puppet_gem,
  }
}
