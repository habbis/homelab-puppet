# copy files from remote host
class roles::rsync_remote_server (
# @param remote sercer
# @param remote source
# @param local destination
  $remote_server = $roles::rsync_copy::remote_server,
  $remote_user = $roles::rsync_copy::remote_user,
  $run_as_user = $roles::rsync_copy::run_as_user,
  $remote_source = $roles::rsync_copy::remote_source,
  $local_destination = $roles::rsync_copy::local_destination,) {

  if $run_as_user == 'root' {
    exec { 'eval-ssh-agent':
      path    => ['/bin/', '/usr/bin/'],
      command => 'eval $(ssh-agent)',
      user    => 'root',
    }
    exec { 'add-ssh-agent':
      path    => ['/bin/', '/usr/bin/'],
      command => 'ssh-add',
      user    => 'root',
    }
    exec { 'rsync-remote-dir':
      path    => ['/bin/', '/usr/bin/'],
      command => 'rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" root@$remote_server:$remote_source $local_destination',
      user    => 'root',
    }
  } else {
    exec { 'eval-ssh-agent':
      path    => ['/bin/', '/usr/bin/'],
      command => 'eval $(ssh-agent)',
      user    => $run_as_user,
    }
    exec { 'add-ssh-agent':
      path    => ['/bin/', '/usr/bin/'],
      command => 'ssh-add',
      user    => $run_as_user,
    }
    exec { 'rsync-remote-dir':
      path    => ['/bin/', '/usr/bin/'],
      command => 'rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" $remote_user@$remote_server:$remote_source $local_destination',
      user    => $run_as_user,
    }
  }
}
