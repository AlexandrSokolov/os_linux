
* [How to update `known_hosts`](#how-to-update-known_hosts)
* [Ignore `known_hosts` checks](#ignore-known_hosts-checks)
* [Generating ssh private and public keys with a comment](ssh.md/#generating-ssh-private-and-public-keys-with-a-comment)


* [ssh host keys location](#ssh-host-keys-location) 
* [SSH key pair location on the client host](#ssh-key-pair-location-on-the-client-host)
* [`known_hosts` location](#known_hosts-location)
* [Compare the public key on the host with a saved line in `known_hosts`](#compare-the-public-key-on-the-host-with-a-saved-line-in-known_hosts)
* 
* [What happens when the public key the host has changes? Solution](#what-happens-when-the-public-key-the-host-has-changes-solution)
* [What data does `known_hosts` contain?](#what-data-does-known_hosts-contain)
* [he purpose of having host keys in `known_hosts`](#the-purpose-of-having-host-keys-in-known_hosts)

### The purpose of having host keys in `known_hosts`

`known_hosts` contains a mapping between a server as identified by its characteristics and its key.
Its purpose is for the client to authenticate the server they are connecting to via SSH.

If you remove known_host entries, you are vulnerable to a man-in-the-middle attack.

### `known_hosts` location

By default, it is: `$HOME/.ssh/known_hosts`

You can control behaviour by: `UserKnownHostsFile` and/or `GlobalKnownHostsFile` options in `/etc/ssh/ssh_config`

### What data does `known_hosts` contain?

```bash
cat $HOME/.ssh/known_hosts
|1|b5fsiYN[...]6eTbrpE=|U3VYg[...]6rbGs+l3U= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyN[...]KhcRXB3zj/eIdk+kO7CYQy+u6Kc=
```
Each such file contains a list with several columns, separated by whitespace:

1. Identifying host data (ip or dns name). 
  Data can be hashed or cleartext, controlled by `HashKnownHosts` in `/etc/ssh/ssh_config`
2. Host key type (ssh key algorithms, like: `ssh-ed25519`, `ssh-rsa`, etc.)
3. Host key value (host public key). 
For instance for the public key `id_ed25519.pub`:
```txt
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge user@host
```
`known_hosts` contains:
```txt
|1|eMWseT2nmAUCxkzKGEKEI+ROo2k=|nbh1UMuvWEUtlHFNLeWaT5zvAR8= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge
```
4. Optional comment

### What happens when the public key the host has changes? Solution.

```bash
ssh 192.168.6.66
```
You get a warning:

```txt
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:q0liAwJ8kwnc[...]ai7et9iz56+5A.
Please contact your system administrator.
Add correct host key in /home/alex/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/alex/.ssh/known_hosts:1
remove with:
ssh-keygen -f "/home/alex/.ssh/known_hosts" -R "192.168.66.6"
ECDSA host key for 192.168.6.66 has changed and you have requested strict checking.
Host key verification failed.
```

If you know that host changed its public key, you need to:
- remove the previous record from `known_hosts` for that host. The exact command in the warning above:
    ```bash
    ssh-keygen -f "/home/alex/.ssh/known_hosts" -R "192.168.66.6"
    ```
- and then add a new key. See the next section 

### How to update `known_hosts`
1. Get the current configuration for specific host if exists
    ```bash
    ssh-keygen -F localhost
    # Host localhost found: line 1 
    |1|IxkYm4agAqFwE7zsKgy4kZ7sBDY=|2ZdcQIvOD2IP43u5t5lPiXuFTRE= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge
    ```
2. Remove the configuration
    ```bash
    ssh-keygen -f "/home/alex/.ssh/known_hosts" -R "192.168.66.6"
    ```
3. Add new configuration. Just try to connect:
    ```bash
    ssh -p 2222 user@host
    ```
   You'll get a prompt with `Are you sure you want to continue connecting (yes/no/[fingerprint])?` text.
    Type `yes` and the host key will be added for the host.

    Alternatively, you could run, it adds all host public keys:
    ```bash
    ssh-keyscan -H -p 2222 host >> ~/.ssh/known_hosts
    ```
4. Add new configuration from the existing public key file.
    
    This option was needed for docker container with ssh and unit tests. 
    Looks as it is a challenge. 

### Ignore `known_hosts` checks

1. Per host permanently. Configure in `/etc/ssh/ssh_config` for specific `MISIDENTIFIED_HOST` host:
    ```text
    Host MISIDENTIFIED_HOST
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      GlobalKnownHostsFile /dev/null
    ```
2. With `jsch` sftp library:
    
    Globally per library (useful option for test purpose):
    ```java
    import com.jcraft.jsch.JSch;
    JSch.setConfig("StrictHostKeyChecking", "no");
    ```
    Per session:
    ```java
    jschSession.setConfig("StrictHostKeyChecking", "no");
    ```
3. Per ssh connection:
    ```bash
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null 192.168.6.66
    ```

### ssh host keys location

Both private and public ssh host keys usually are located under `/etc/ssh`. Examples:
- `/etc/ssh/ssh_host_ed25519_key`
- `/etc/ssh/ssh_host_ed25519_key.pub`
- `/etc/ssh/ssh_host_ed25519_key`
- `/etc/ssh/ssh_host_ed25519_key.pub`

### SSH key pair location on the client host

The client after the first connection, will save only the public host key in its `known_hosts` file.

### Compare the public key on the host with a saved line in `known_hosts`

1. The original content of `id_ed25519.pub` public key:
    ```bash
    cat id_ed25519.pub
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge user@host
    ```
2. To scan and get all public keys of the host with ssh (the `id_ed25519.pub` is configured for the host):
    ```bash
    ssh-keyscan -p 22 localhost
    # localhost:22 SSH-2.0-OpenSSH_7.5
    localhost ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge
    ```
3. To get `localhost` host as hashed value by connecting to ssh:
    ```bash
    ssh-keyscan -H -p 22 localhost
    # localhost:22 SSH-2.0-OpenSSH_7.5
    |1|HiOf82q72ut/52Kp+OpqndxFYHo=|+D5O0x0ySMoxlL/mzI32SN+VCuo= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge
    ```
4. Now you can check, that is saved in `known_hosts` for `localhost` host:
    ```bash
    ssh-keygen -F localhost
    # Host localhost found: line 1 
    |1|IxkYm4agAqFwE7zsKgy4kZ7sBDY=|2ZdcQIvOD2IP43u5t5lPiXuFTRE= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG5pmg72Ms7ILS3PCQnlqQ9Fm2ac+kA8cgfQKKnijge
    ```
    The output of this and previous commands must be the same. 
    **Note:** the hashed value of the host/ip is different! It is generated with unique value each time.
5. If the value of key is different, and you have a confirmation that server updated its public key, you remove the old record:
    ```bash
    ssh-keygen -f "/home/alex/.ssh/known_hosts" -R localhost
    ```
    And add a new key via:
    ```bash
    ssh-keyscan -H -p 22 localhost >> ~/.ssh/known_hosts
    ```
