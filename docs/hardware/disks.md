- [Format disks](#format-disks)
- [Zero out a drive](#zero-out-a-drive)
- [General information via console](#general-information-via-console)

### Format disks

Run: `gparted`

`disks` does no support all the possible formats and pretty limited.

### General information via console

```bash
sudo lshw -C disk
  *-disk                    
       description: SCSI Disk
       product: Tech
       vendor: JMicron
       logical name: /dev/sda
       size: 931GiB (1TB)
  *-namespace:2
       description: NVMe disk
       bus info: nvme@0:1
       logical name: /dev/nvme0n1
       size: 953GiB (1024GB)
```

### Zero out a drive

The whole disk (takes several hours for disks with huge capacity)
```bash
sudo dd if=/dev/zero of=/dev/sda bs=16M status=progress && sync
```
Only a single partition:
```bash
sudo dd if=/dev/zero of=/dev/sda3 bs=16M status=progress && sync
```