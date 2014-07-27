# == Define: docker:build
#
# A define which build docker image
#
define docker::build(
  $docker_file,
  $force_rm = false,
  $no_cache = false,
  $rm = true,
  $image_tag = undef,
  $timeout = 0
) {
  validate_absolute_path($docker_file)
  validate_bool($force_rm)
  validate_bool($no_cache)
  validate_bool($rm)

  if $image_tag {
    validate_re($image_tag, '^[\S]*$')
  }

  unless is_integer($timeout) {
    fail('Invalid parameter timeout should be integer')
  }

  $build_base = "docker build \
    --force-rm=${force_rm} \
    --no-cache=${no_cache} \
    --rm=${rm}"

  $build_from_file = "- < ${docker_file}"

  if $image_tag {
    $build_image = "${build_base} --tag=${image_tag} ${build_from_file}"
  } else {
    $build_image = "${build_base} ${build_from_file}"
  }

  exec { $build_image:
    path => ['/bin', '/usr/bin'],
    timeout => $timeout
  }
}

