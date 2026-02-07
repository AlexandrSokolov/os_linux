Steps:
- [Determine specific ARM architecture](#determine-specific-arm-architecture)
- [Find the latest versions of the packages](#find-out-what-the-latest-version-of-each-package)
- [See which packages can be upgraded](#see-which-packages-can-be-upgraded)
- [Apply packages update](#apply-packages-update)
- [Remove the unnecessary packages](#remove-the-unnecessary-packages)
- [How to apply update and remove with a single command?](#how-to-apply-update-and-remove-with-a-single-command)

- [Reinstall `snap`]()
- [How to Upgrade to the Latest Version of Ubuntu](#how-to-upgrade-to-the-latest-version-of-ubuntu)

Issues:
- [Fix `W: Target Packages ... is configured multiple times in`](#fix-w-target-packages--is-configured-multiple-times-in)
- [Not all the packages get updated](#not-all-the-packages-get-updated)

FAQ:
- [What's the Difference Between `apt-get` and `apt`?](#whats-the-difference-between-apt-get-and-apt)

### Determine specific ARM architecture

```bash
dpkg --print-architecture
amd64
```
Alternative option:
```bash
$ arch
x86_64
```

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

# APT Upgrade Modes — Comparison Table

| Command                 | Installs New Dependencies | Removes Packages | Behavior Summary                                                                 | Best Use Case                                   |
|-------------------------|---------------------------|------------------|----------------------------------------------------------------------------------|-------------------------------------------------|
| `sudo apt-get upgrade`  | ❌ No                      | ❌ No             | Performs safe upgrades; skips packages that require adding/removing dependencies | Servers or minimal‑risk updates                 |
| `sudo apt full-upgrade` | ✔ Yes                     | ✔ Yes            | Resolves dependency changes, installs new deps, removes obsolete ones            | Desktops; complete system upgrade (recommended) |


Automatically answers `yes` to any prompts:
```bash
sudo apt-get upgrade --yes
```

It only upgrades what it can without removing anything.

### Remove the unnecessary packages

| Command                                               | What It Removes                                    | Removes Config Files? | Description                                                                                              |
|-------------------------------------------------------|----------------------------------------------------|-----------------------|----------------------------------------------------------------------------------------------------------|
| `sudo apt autoremove`                                 | Unused packages automatically installed as deps    | ❌ No                  | Cleans up orphaned libraries, old kernels, and dependencies no longer required by any installed package. |
| `sudo apt clean`                                      | Entire APT cache (`/var/cache/apt/archives`)       | —                     | Deletes all cached `.deb` files to free disk space. Does not affect installed packages.                  |
| `sudo apt autoclean`                                  | Obsolete cached packages that cannot be downloaded | —                     | Removes only outdated or superseded `.deb` files from cache. Safe partial cleanup.                       |
| `sudo apt purge $(dpkg -l \| awk '/^rc/ {print $2}')` | All leftover config files from removed packages    | ✔ Yes                 | Purges all system‑wide residual configs from previously removed packages.                                | 

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

### How to apply update and remove with a single command?

It updates and remove packages, if needed. 

```bash
sudo apt-get dist-upgrade
```
or:
```bash
sudo apt full-upgrade
```

### Reinstall `snap`

Check and fix any broken nap packages by performing in sequence:
```bash
sudo apt update --fix-missing
sudo apt install -f
sudo dpkg --configure -a
sudo apt clean
```

Install and list installed by `snap` packages:
```bash
sudo apt install snapd
snap list
```

### How to Upgrade to the Latest Version of Ubuntu

Make sure we have `update-manager-core` installed:
```bash
sudo apt install update-manager-core
```
check for the newest available version of Ubuntu:
```bash
sudo do-release-upgrade -c
```
if a new version is found and you want to upgrade to it:
```bash
sudo do-release-upgrade
```
Restart and verify Version Upgrade:
```bash
lsb_release -a
```

[How to Upgrade to the Latest Version of Ubuntu](https://www.baeldung.com/linux/ubuntu-upgrade-latest)