- [Information on disks and their partitions](#information-on-disks-and-their-partitions)
- [Fix `mount: wrong fs type, bad option, bad superblock` for ntfs partition](#fix-mount-wrong-fs-type-bad-option-bad-superblock-for-ntfs-partition)
- [Disks Format](#disks-format)
- [Zero out a drive](#zero-out-a-drive)

### Information on disks and their partitions

To apply CLI disks-related utilities, we need to know the partition (device) path.

1. Best option to get a partition path - via `fdisk`, gives a full partition path, for instance `/dev/nvme0n1p6`:
    ```bash
    sudo fdisk -l
    ```
    Filtered output:
    ```text
    Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
    Disk model: SAMSUNG MZVL21T0HDLU-00BH1              
    ...
    Device              Start        End    Sectors   Size Type
    /dev/nvme0n1p1       2048     534527     532480   260M EFI System
    /dev/nvme0n1p2     534528     567295      32768    16M Microsoft reserved
    /dev/nvme0n1p3     567296  357820415  357253120 170.4G Microsoft basic data
    /dev/nvme0n1p4 1998215168 2000398335    2183168     1G Windows recovery environment
    /dev/nvme0n1p5  357820416  945481727  587661312 280.2G Linux filesystem
    /dev/nvme0n1p6  945481728 1998215167 1052733440   502G Microsoft basic data
    ...
    Disk /dev/sda: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
    Disk model: Tech          
    ...  
    Device     Start        End    Sectors   Size Type
    /dev/sda1   2048 1953523711 1953521664 931.5G Microsoft basic data
    ```
    As we can see there are 2 disks: `/dev/nvme0n1` with 6 partitions and `/dev/sda` with a single partition

2. To see on which partitions which folder paths are mounted - via `lsblk`
    ```bash
    lsblk
    ```
    Filtered output:
    ```text
    sda           8:0    0 931.5G  0 disk 
    └─sda1        8:1    0 931.5G  0 part 
    nvme0n1     259:0    0 953.9G  0 disk 
    ├─nvme0n1p1 259:1    0   260M  0 part /boot/efi
    ├─nvme0n1p2 259:2    0    16M  0 part 
    ├─nvme0n1p3 259:3    0 170.4G  0 part 
    ├─nvme0n1p4 259:4    0     1G  0 part 
    ├─nvme0n1p5 259:5    0 280.2G  0 part /var/snap/firefox/common/host-hunspell
    │                                     /
    └─nvme0n1p6 259:6    0   502G  0 part /media/alex/1EE11A06103C8072
    ```
    As we can see `/media/alex/1EE11A06103C8072` folder mounted to `nvme0n1p6` partition

3. Via `lshw` - does not include information on partitions, pretty limited:
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

### Fix `mount: wrong fs type, bad option, bad superblock` for ntfs partition

When you try to click on the disk or on the partition, you get this error.

1. Find the partition path [via `fdisk`](#information-on-disks-and-their-partitions)
2. To fix ntfs partition (for instance `/dev/sda1` partition path), run:
    ```bash
    sudo ntfsfix /dev/sda1
    Mounting volume... OK
    Processing of $MFT and $MFTMirr completed successfully.
    Checking the alternate boot sector... OK
    NTFS volume version is 3.1.
    NTFS partition /dev/sda1 was processed successfully.
    ```
    and same command with `-d` option:
    ```bash
    sudo ntfsfix -d /dev/sda1
    Mounting volume... OK
    Processing of $MFT and $MFTMirr completed successfully.
    Checking the alternate boot sector... OK
    NTFS volume version is 3.1.
    NTFS partition /dev/sda1 was processed successfully.
    ```
    
    To fix `/dev/nvme0n1p6` run:
    ```bash
    sudo ntfsfix /dev/nvme0n1p6
    sudo ntfsfix -d /dev/nvme0n1p6
    ```

### Disks format

- `gparted` - GUI application
- `disks` - CLI utility - does no support all the possible formats and is pretty limited.

### Zero out a drive

The whole disk (takes several hours for disks with huge capacity)
```bash
sudo dd if=/dev/zero of=/dev/sda bs=16M status=progress && sync
```
Only a single partition:
```bash
sudo dd if=/dev/zero of=/dev/sda3 bs=16M status=progress && sync
```