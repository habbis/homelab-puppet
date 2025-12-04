# homelab-puppet

### how to validate manifest files
```
puppet parser validate </path/to/manifest/file>
puppet-lint --no-2sp_soft_tabs-check --no-hard_tabs-check --no-80chars-check </path/to/manifest/file>
```
### Development

For debian based distro.
```bash
sudo apt install -y build-essential
sudo apt install -y ruby-dev
```

For rhel based distro.
```bash
sudo yum groupinstall 'Development Tools'
sudo yum install -y ruby-devel
```

### setup pre-commit

Install pre-commit for your os.

For debian based distro.
```bash
sudo dnf install -y pre-commit
```

For rhel based distro.
```bash
sudo apt install -y pre-commit
```

```bash
pre-commit install
```


### puppe environments 
To manage environment use [g10k](https://github.com/xorpaul/g10k?tab=readme-ov-file) or [r10k](https://github.com/puppetlabs/r10k) they work similar. 

First you need to create a ssh key for root use and it should not have passhrase and
its best to ensure that this ssh key only have read only access to git repo where puppet environments are stored.

```
ssh-keygen -t ed25519
```

In to manage external puppet modules Puppetfile.
`vim Puppetfile`

```
moduledir 'modules2'

mod 'puppetlabs-stdlib', '9.7.0'
mod 'puppetlabs-puppetdb', '8.1.0'
mod 'puppetlabs-firewall', '8.2.0'
mod 'puppetlabs-inifile', '6.2.0'
mod 'puppetlabs-postgresql', '10.5.0'
mod 'puppetlabs-concat', '9.1.0'
mod 'puppetlabs-patching_as_code', '2.0.1'
mod 'puppetlabs-apt', '11.1.0'
```

To setup g10k.
```
wget https://github.com/xorpaul/g10k/releases/download/v0.9.10/g10k-v0.9.10-linux-amd64.zip
unzip g10k-v0.9.10-linux-amd64.zip
rm g10k-v0.9.10-linux-amd64.zip
mkdir /var/cache/g10k /etc/puppetlabs/g10k
```

Config file for g10k.
`vim /etc/puppetlabs/g10k/g10k.yaml`

```yaml
---
:cachedir: '/var/cache/g10k'
use_cache_fallback: true

sources:
  homelab-puppet:
    remote:  'git@github.com:habbis/homelab-puppet.git'
    basedir: '/etc/puppetlabs/code/environments'
```

To run.
```bash
g10k -config /etc/puppetlabs/g10k/g10k.yaml
```

To setup r10k 

Install via puppet gem.
```
/opt/puppetlabs/puppet/bin/gem install r10k
```

Setup dir.
```bash
mkdir /etc/puppetlabs/r10k
```


Config file for r10k.
`vim /etc/puppetlabs/r10k/r10k.yaml`

```yaml
cachedir: '/var/cache/r10k'

sources:
  homelab-puppet:
    remote:  'git@github.com:habbis/homelab-puppet.git'
    basedir: '/etc/puppetlabs/code/environments'
```

To run.
```
r10k deploy environment
```



### use test branch when creating a class.
```
git checkout test
```

### how to test changes

Once you commit your changes and push them to the primary repository, you
can test your changes on a Debian machine using:

```
puppet agent --test --noop
```

### how to merge into production branch.

When ready merge into production branch dont delete test branch.

To merge into production.
```
git checkout production
git merge test
```

### how to configure vim

Alternately, use [gmarik/vundle][4] or [tpope/pathogen][5] to install
[rodjek/vim-puppet][6].


[1]: https://help.puppet.com/core/current/Content/PuppetCore/puppet_language.htm
[2]: https://help.puppet.com/core/current/Content/PuppetCore/lang_data_type_list.htm
[3]: https://help.puppet.com/core//current/Content/PuppetCore/Markdown/function.htm
[4]: https://github.com/gmarik/vundle
[5]: https://github.com/tpope/vim-pathogen
[6]: https://github.com/rodjek/vim-puppet

