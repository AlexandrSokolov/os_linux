- [Manage kernel with `mainline`](#install-kernel-with-mainline)
- [Verify the Version of the Current Kernel](#verify-the-version-of-the-current-kernel)
- [Update kernel with packages update](#update-kernel-with-packages-update)
- [Download and install kernel manually](#download-and-install-kernel-manually)
- [Load with one of the previously installed Kernel version](#load-with-one-of-the-previously-installed-kernel-version)
- [Rollback the changes and downgrade the Linux Kernel](#rollback-the-changes-and-downgrade-the-linux-kernel)


### Verify the Version of the Current Kernel

```bash
uname -s -r
```
or:
```bash
cat /proc/version_signature
```

### Update kernel with packages update

This option searches and installs the Kernel version, marked as last for the distro.
For instance, 

[Update packages](packages.update.md)

The commands will:
1. `update` - locate any updated kernel versions, marks them for download and installation.
2. `upgrade` - installs the most recent Linux kernel

Check if the version of Linux kernel has been updated.

**Note:** Ubuntu uses the latest stable LTS kernel instead of the latest stable kernel.

### Download and install kernel manually

Get current architecture:
```bash
dpkg --print-architecture
```
You'll get exact architecture like: `amd64`

Using `uname`:
```bash
uname -i
```
Give you result that looks as: `x86_64`. Still not clear whether it is `amd64`, `arm64` or anything else.
You need to know exact mapping for this output. (`x86_64` means `amd64`)

[Find the last kernel version for your architecture](https://kernel.ubuntu.com/mainline/)

Download 3 (maybe 4 or 5) debs to a folder somewhere:
```text
linux-headers-VERSION-NUMBER_all.deb
linux-headers-VERSION-NUMBER_amd64.deb
linux-image-VERSION-NUMBER_amd64.deb
linux-image-extra-VERSION-NUMBER_amd64.deb   # if available
linux-modules-VERSION-NUMBER_amd64.deb   # if available
```
Check checksums:
- Download the `CHECKSUMS` file. It contains checksums for all the deb files. Save it as `CHECKSUMS`
- Run `shasum -c CHECKSUMS.txt`

You must have `OK` for all the files in the list.

Install packages:
```bash
sudo dpkg -i *.deb
```

Restart the system

[How to update kernel to the latest mainline version without any Distro-upgrade?](https://askubuntu.com/a/142000/458132)

### Install kernel with `mainline`

```bash
sudo add-apt-repository ppa:cappelikan/ppa
sudo apt update && sudo apt upgrade -y
sudo apt install -y mainline
```

### Load with one of the previously installed Kernel version

In the GRUB loader choose `Advanced options for Ubuntu` and choose a kernel version you want.

### Rollback the changes and downgrade the Linux Kernel

- [Boot into an older kernel](#load-with-one-of-the-previously-installed-kernel-version)
- Remove the newer Linux kernel you don’t want: 
    ```bash
    sudo apt remove linux-headers-6.11.0*
    sudo apt remove linux-image-6.11.0*
    sudo apt remove linux-image-unsigned-6.11.0*
    sudo apt remove linux-modules-6.11.0*
    ```