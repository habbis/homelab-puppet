# copy files from remote host
class roles::rsync_copy (
# @param remote sercer
# @param remote source
# @param local destination
  String $remote_server,
  String $remote_user,
  String $run_as_user,
  Strng  $remote_source,
  String $local_destination,
) {
  include roles::rsync_copy::run
}

