class gsettings {
  package { 'gio2':
    ensure   => installed,
    provider => 'puppet_gem',
  }
}
