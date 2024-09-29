
### Find out what the latest version of each package

```bash
sudo apt-get update
```

`sudo apt-get update` fetches the latest version of the package list from your distro's software repository, 
and any third-party repositories you may have configured. 

In other words, it'll figure out what the latest version of each package and dependency is, 
but **will not actually download or install** any of those updates.

### Fix `W: Target Packages ... is configured multiple times in`

When you run: `sudo apt-get update` you see warning like:
> W: Target Packages (main/binary-amd64/Packages) is configured multiple times in /etc/apt/sources.list.d/dl_google_com_linux_chrome_deb.list:1 and /etc/apt/sources.list.d/google-chrome.list:3

Solution:

Go to: `System settings -> Software and Updates -> Other Software` and remove each duplicate entry from the list.

[How can I fix apt error "W: Target Packages ... is configured multiple times"?](https://askubuntu.com/questions/760896/how-can-i-fix-apt-error-w-target-packages-is-configured-multiple-times)

### See which packages can be upgraded

```bash
apt list --upgradable
```

### Apply packages update

```bash
sudo apt-get upgrade
```
or automatically answers `yes` to any prompts:
```bash
sudo apt-get upgrade --yes
```

It only upgrades what it can without removing anything.

### Remove the unnecessary packages

If an upgrade requires a new dependency, the `upgrade` command will download and install it, 
but it will not remove the old dependency. 

If you see a message similar to this after upgrading:
> The following packages were automatically installed and are no longer required:
>   g++-8 gir1.2-mutter-4 libapache2-mod-php7.2 libcrystalhd3
> Use 'sudo apt autoremove' to remove them.

You can remove those unnecessary packages:
```bash
sudo apt autoremove
```

### Not all the packages get updated

When you update the packages, you get: `The following upgrades have been deferred due to phasing` message 
with a list of packages that were not updated:
```bash
$ sudo apt-get dist-upgrade
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following upgrades have been deferred due to phasing
  gir1.2-mutter-14 libmutter-14-0 mutter-common mutter-common-bin python3-distupgrade ubuntu-release-upgrader-core ubuntu-release-upgrader-gtk
0 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.  
```

> If you've encountered times when an update broke your system in the past, 
> you shouldn't be as likely to experience that problem in the future. 
> Update phasing makes it so that breakage is more likely to be detected early on, 
> avoiding causing problems to users' desktops, servers, and other Ubuntu-powered devices. 
> This directly benefits Ubuntu users by increasing the stability and reliability of Ubuntu.

[What are phased updates, and why does Ubuntu use them?](https://askubuntu.com/a/1431941/458132)

### What's the Difference Between `apt-get` and `apt`?

`apt` is a more modern tool for installing and managing applications on Debian and Debian-based distros.

For the most part, `apt` and `apt-get` can be used interchangeably

### How to update your Linux release:

Updates and remove packages, if needed.

```bash
sudo apt-get dist-upgrade
```
or:
```bash
sudo apt full-upgrade
```