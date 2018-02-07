# Securing SSH / Hardening SSH

![Securing ssh](logo.png "Securing ssh Logo")

----

[SSH][1] (Secure Shell) is an open source network protocol that is used to connect local or remote Linux servers to transfer files, make remote backups, remote command execution and other network related tasks via scp or sftp between two servers that connects on secure channel over the network.  
> However, a default installation of ssh isn't perfect, and when running an ssh server there are a few simple steps that can dramatically harden an installation.

----

## Usage

### Configuration

#### Default

> PermitEmptyPasswords no  
> TCPKeepAlive yes  
> ClientAliveInterval 300  
> ClientAliveCountMax 0

#### Optional

> PermitRootLogin (yes/no)  
> PasswordAuthentication (yes/no)  
> UsePAM (yes/no)  
> X11Forwarding (yes/no)

|  Environment   | Value  |         Detail         |
| :------------: | :----: | :--------------------: |
|   ROOT_LOGIN   | yes/no |   Disable root login   |
| PASSWORD_LOGIN | yes/no | Disable password login |
| X11_FORWARDING | yes/no | Disable X11 Forwarding |


### Run script

Default

```bash
curl -fsSL https://raw.githubusercontent.com/c18s/LinuxScripts/master/securing-ssh/securing-ssh.sh | sh
```

Optional

```bash
curl -fsSL https://raw.githubusercontent.com/c18s/LinuxScripts/master/securing-ssh/securing-ssh.sh | ROOT_LOGIN=no PASSWORD_LOGIN=no X11_FORWARDING=no sh
```

### Restore from backup

```bash
curl -fsSL https://raw.githubusercontent.com/c18s/LinuxScripts/master/securing-ssh/securing-ssh.sh | RESET=yes sh
```

## Reference

- :octocat: <https://github.com/c18s/LinuxScripts/tree/master/securing-ssh>

[1]: https://wiki.centos.org/HowTos/Network/SecuringSSH
