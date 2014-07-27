# == Class: ghost
#
# This class installs the Ghost Blogging Platform.
#
# It is automatically included when a ghost::blog resource is defined,
# but it can also accept a hash of blog resources to create.
#
# This module includes puppetlabs/nodejs to install node and npm;
# however, on operating systems with out-of-date packages, you may
# need to set nodejs::manage_repo to true.
#
# === Examples
#
# class { ghost:
#   blogs => {
#     # The name, url, and port must be different per instance!
#     'my_blog' => {
#       'url'  => 'http://my-first-ghost-blog.com',
#     }
#   }
# }
#
# === Copyright
#
# Copyright 2014 Andrew Schwartzmeyer
#
# === TODO
#
# - add database setup to template
# - support other operating systems

class ghost(
  $user          = 'ghost',
  $group         = 'ghost',
  $home          = '/home/ghost',
  $blogs         = {},   # Hash of blog resources to create
  $blog_defaults = {},   # Hash of defaults to apply to blog resources
  ) {

  validate_string($user)
  validate_string($group)
  validate_absolute_path($home)
  validate_hash($blogs)
  validate_hash($blog_defaults)

  create_resources(
    'ghost::blog',
    hiera_hash('ghost::blogs', {}),
    hiera_hash('ghost::blog_defaults', {})
  )

  include ghost::setup

  Exec {
    path    => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin',
    user    => $user,
  }

  File {
    owner   => $user,
    group   => $group,
    require => User[$user],
  }
}
