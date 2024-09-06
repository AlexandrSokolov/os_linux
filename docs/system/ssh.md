
SSH Key-Based Authentication

* [Authenticating to the server using SSH keys](#authenticating-to-the-server-using-ssh-keys)
* [SSH key pairs generation](#generating-ssh-private-and-public-keys-with-a-comment)
* [Copying an SSH public key to the server](#copying-an-ssh-public-key-to-the-server)
* [Copying an SSH public key to the server that supports only SSH key-based authentication](#copying-an-ssh-public-key-to-the-server-that-supports-only-ssh-key-based-authentication)
* [What names are used for the generated keys?](#naming-the-generated-keys)
* [What and where is stored on a remote server for ssh key-based user authentication?](#what-and-where-is-stored-on-a-remote-server-for-ssh-key-based-user-authentication)
* [What and where is stored on a user host for ssh key-based user authentication?](#what-and-where-is-stored-on-a-user-host-for-ssh-key-based-user-authentication)

* [Disabling password authentication on the server](#disabling-password-authentication-on-the-server)
* [SSH key-based login authentication that requires both key AND password](#ssh-key-based-login-authentication-that-requires-both-key-and-password)

* [How Do SSH Keys Work?](#how-do-ssh-keys-work)
* [What happens if the private key is shared with someone else?](#what-happens-if-the-private-key-is-shared-with-someone-else)
* [What happens if the public key is shared with someone else?](#what-happens-if-the-public-key-is-shared-with-someone-else)
* [Generation SSH key pairs per host](#generation-ssh-key-pairs-per-host)

* [todo](#todo)

### How Do SSH Keys Work?

SSH key pairs are two cryptographically secure keys that can be used to authenticate a client to an SSH server.
Each key pair consists of a public key and a private key.

The private key is retained by the client and should be kept absolutely secret.
As an additional precaution, the key can be encrypted on disk with a passphrase.

The public key can be used to encrypt messages that only the private key can decrypt.

When a client attempts to authenticate using SSH keys, the server can test the client on
whether they are in possession of the private key.
If the client can prove that it owns the private key, a shell session is spawned or the requested command is executed.

### What happens if the private key is shared with someone else?

It means the private key is compromised.

Any compromise of the private key will allow the attacker to log into servers
that are configured with the associated public key without additional authentication.

### What happens if the public key is shared with someone else?

The associated public key can be shared freely without any negative consequences.

### Generation SSH key pairs per host

It is not necessary. The public key can be shared on different systems. The private key is kept absolutely secret.

On the other side key contain comments, usually `user@host` pair or email address.
You might want to use different comments on different systems (for instance private and non-private emails).

### What and where is stored on a remote server for ssh key-based user authentication?

The public key is uploaded to a remote server that you want to be able to log into with SSH.
The key is added to `~/.ssh/authorized_keys`

It is configured in `/etc/ssh/sshd_config` via `AuthorizedKeysFile`


### What and where is stored on a user host for ssh key-based user authentication?

Both the private and the public keys are stored on the user host.
By default, in: `~/.ssh` folder

### Naming the generated keys

`~/.ssh/id_${algorithm}` for private keys. Examples: `id_rsa`, `id_ed25519`

`~/.ssh/id_${algorithm}.pub` for public keys. Examples: `id_rsa.pub`, `id_ed25519.pub`

If you generate different key pairs for different hosts, you could include host name into the key name:
```bash
$ ls -1 ~/.ssh
id_rsa_github
id_rsa_github.pub
id_rsa_gitlab
id_rsa_gitlab.pub
```

Note: actually to generate different key pairs for different systems is not necessary.

### Generating ssh private and public keys with a comment

Recommended:
```bash
ssh-keygen -t ed25519 -C "my comment"
```
If you do not set the comment explicitly, your current `user@host` will be used by default

On legacy systems that do not support `ed25519`, run:
```bash
 ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Copying an SSH public key to the server

1. With `ssh-copy-id`
    ```bash
    ssh-copy-id username@remote_host
    ssh-copy-id -i my_custom_key.pub username@remote_host
    ssh-copy-id -f -i hostkey.rsa.pub username@remote_host
    ```
    The key will be added into `~/.ssh/authorized_keys`

    With `-i` option you choose which exact key to copy.
    With `-f` (must be passed before `-i`):
    > Forced mode: doesn't check if the keys are present on the remote server. 
   > This means that it does not need the private key.  
   > Of course, this can result in more than one copy of the key being installed on the remote system.

2. Using `ssh`
    ```bash
    cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
    ```

3. Manually.
   Add the contents of your public key to the end of the authorized_keys:
    ```bash
    echo public_key_string >> ~/.ssh/authorized_keys
    ```

### Copying an SSH public key to the server that supports only SSH key-based authentication

For instance, you already have key-based auth configured. But you want to add additional public keys for the users.
```bash
ssh-copy-id -i new_public_key_you_want_to_add -o 'IdentityFile ~/.ssh/your_existing_private_key' username@remote_host
```

### Authenticating to the server using SSH keys

```bash
ssh username@remote_host
```

If this is your first time connecting to this host (if you used the last method above), you may see something like this:

> The authenticity of host '203.0.113.1 (203.0.113.1)' can't be established.
> ECDSA key fingerprint is fd:fd:d4:f9:77:fe:73:84:e1:55:00:ad:d6:6d:22:fe.
> Are you sure you want to continue connecting (yes/no)? yes

This means that your local computer does not recognize the remote host. Type `yes`` and then press ENTER to continue.

If you did not supply a passphrase for your private key, you will be logged in immediately. 
If you supplied a passphrase for the private key when you created the key, you will be required to enter it now.

If the private key you're using does not have the default name, or is not stored in the default path, you have 2 options:
1. `ssh -i ~/.ssh/old_keys/host2_key username@remote_host`
2. specify which private key should be used for connections to a particular remote host with `IdentityFile` parameter.
    - in `~/.ssh/config`:
    ```bash
    Host host2.somewhere.edu
    IdentityFile ~/.ssh/old_keys/host2_key
    ```
    - in `/etc/ssh/ssh_config` 
    ```bash
    Host host2.somewhere.edu
    IdentityFile ~/.ssh/old_keys/host2_key
    
    Host host4.somewhere.edu
    IdentityFile ~/.ssh/old_keys/host4_key
   
    Host *.somewhere.edu
    IdentityFile ~/.ssh/old_keys/all_hosts_key
    ```

### Disabling password authentication on the server

In `/etc/ssh/sshd_config` set:
```properties
PasswordAuthentication no
PubkeyAuthentication yes
```
And then restart:
```bash
sudo systemctl restart sshd
```
or:
```bash
sudo systemctl restart ssh
```

### SSH key-based login authentication that requires both key AND password

1. Using a public key and a password.

    The password in this context is the password assigned to the user.
    
    **Step 1** Remove the existing passphrase for each public-private key pair: 
    ```bash
    ssh-keygen -p
    ```
    or generate new key pair without passphrase.

    **Step 2** Copy the public key to the server only if the key is new. Password based login must be enabled for this to work.
    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@board_ip
    ```

    **Step 3** Test if public keys are being used
    ```bash
    ssh user@board_ip 
    ```
    **You will not be prompted to enter any password or passphrase**

    **Step 4** Setup for both public key and password. Login to the ssh server. In `/etc/ssh/sshd_config` set:
    ```properties
    AuthenticationMethods "publickey,password"
    #PasswordAuthentication yes
    ```
    Restart:
    ```bash
    sudo service ssh restart
    ```

   **Step 5** Test form client box:
    ```bash
    ssh user@board_ip
    ```
    
    If you can login with just the password, then it did not work. Anyone who has the password or can guess it, can login to the board. They do not need the key.
    
    If you get a permission denied and login fails, then the double authentication of public key and password works.

2. Using a public key and a passphrase

    The passphrase is linked to the private key in the client (local) computer, not to the remote server (board) computer. 
    Thus, if you use two different client computers of devices to ssh from, 
    then you will have to create a passphrases for the private keys stored in each local computer. 
    
    Similarly, if two different users need to ssh to the server (board) from their own respective local computers, 
    they will need their own private-public key pairs and own passphrase to unlock their respective private keys.

    **Step 1.** If you already have a key-pair, add a passphrase to the existing public-private pair.
    ```bash
    ssh-keygen -p
    ```
    You will be prompted to enter a new passphrase. **Do not hit Enter!** 
    Enter a long and difficult to guess passphrase that is easy to remember. 
    You will be asked to re-enter the passphrase.

    If you don't have an existing public-private key pair, generate new one with a passphrase.

    Every time you try to login to the ssh server, you will be asked to enter this passphrase.

    **Step 2** Copy the public key to the server only if the key is new. Password based login must be enabled for this to work:
    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@board_ip
    ```
    **Step 3** Try to login:
    ```bash
    ssh user@board_ip
    ```
   
    If all goes well, you will be prompted to enter the passphrase. This is not the user password.

    **Step 4** Disable password based login (optional)
    
    In `/etc/ssh/sshd_config` change `#PasswordAuthentication yes` to `PasswordAuthentication no`

    Restart ssh:
    ```bash
    sudo service ssh restart
    ```

    [See also: `Key based SSH login that requires both key AND password`](https://askubuntu.com/questions/1019999/key-based-ssh-login-that-requires-both-key-and-password)

### todo

Consider some other IT tasks:
- disable root login: `PermitRootLogin no`
- disable rsa algorithm: `RSAAuthentification no`
- what is it: `ChallengeResponseAuthentication no`
[SSH_Key_Login](https://www.thomas-krenn.com/de/wiki/SSH_Key_Login)
