# === Copyright
#
# Copyright 2014, Deutsche Telekom AG
# Licensed under the Apache License, Version 2.0 (the "License");
# http://www.apache.org/licenses/LICENSE-2.0
#

# == Class: nginx_hardening::jfryman
#
# Overlay provider for jfryman/nginx
#
# === Parameters
#
# none
#
class nginx_hardening::jfryman(
  $conf_dir = $nginx::params::nx_conf_dir
) {
  # finally we need to make sure our options are written to the config file
  class{'nginx_hardening::jfryman_override': }

  # additional configuration
  
  $keepalive_timeout = '5 5'

  $client_body_buffer_size = '1k'

  $client_max_body_size = '1k'

  $more_clear_headers = [
    '\'Server\'',
    '\'X-Powered-By\''
  ]

  $client_header_buffer_size = '1k'

  $large_client_header_buffers = '2 1k'

  $client_body_timeout = '10'

  $client_header_timeout = '10'

  $send_timeout = '10'

  $limit_conn_zone = '$binary_remote_addr zone=default:10m'
  $limit_conn = 'default 5'

  $add_headers = [
    # vvoid clickjacking
    'X-Frame-Options SAMEORIGIN',

    # disable content-type sniffing
    'X-Content-Type-Options nosniff',

    # XSS filter
    'X-XSS-Protection "1; mode=block"'
  ]

  # addhardening parameters
  file { "${conf_dir}/conf.d/90.hardening.conf":
    ensure => file,
    content => template('nginx_hardening/hardening.conf.erb'),
  }
}
