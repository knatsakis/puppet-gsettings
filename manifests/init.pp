class gsettings {
  package { [
    'libglib2.0-dev',
    'libgirepository1.0-dev',
  ]:
    ensure => installed,
  } ->
  package { 'gio2':
    ensure   => latest,
    provider => 'puppet_gem',
  }
}
