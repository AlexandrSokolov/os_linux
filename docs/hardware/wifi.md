## Commands that help to check speed and apply changes without restart
- [Restart NetworkManager](#restart-networkmanager)
- [Speed test](#speed-test)

## Wi-Fi Performance Boost
- [(the most important) Make sure Wi-Fi adapter uses 5MGz frequency](#make-sure-wi-fi-adapter-uses-5mgz-frequency)
- [Change to preferring IPv4 over IPv6](#change-to-preferring-ipv4-over-ipv6)
- [Disable Power Management](#disable-power-management)
- [Disable Wi-Fi Power Saving](#disable-wi-fi-power-saving)
- [Change `11n_disable` parameter](#change-11n_disable-parameter)

#### What might help, but ideally should not be touched:
- [Remove `backport-iwlwifi-dkms`](#remove-backport-iwlwifi-dkms)
- [**Do not do that**! Disable Active-State Power Management (ASPM)](#disable-active-state-power-management-aspm)

## Current information on Wi-Fi devices and drivers
- [Open network manager connection editor (Wi-Fi settings editor)](#network-manager-connection-editor)
- [Network configuration files location](#network-configuration-files-location)
- [Get info on the current Wi-Fi controller](#get-info-on-the-current-wi-fi-controller)
- [Wi-Fi module configuration](#wi-fi-module-configuration)
- [Wi-Fi adapter scan (to get `BSSID`)](#wi-fi-adapter-scan)
- [Wi-Fi adapter supported frequencies](#wi-fi-adapter-supported-frequencies)
- [`iwlwifi` modules info, including list of possible parameters](#iwlwifi-modules-info-including-list-of-possible-parameters)
- [List of loaded/current parameters](#list-of-loadedcurrent-parameters)
- [Module parameters setting](#module-parameters-setting)

## [System logs from network devices](#system-logs-from-network-devices) 

### Restart NetworkManager

Helps to avoid rebooting after each change applied

```bash
sudo systemctl restart NetworkManager
```

### Speed test

Note: the range of results with the same configuration might be high. 
Run this test several times to get the reasonable value.

It also means that if you change something and speed is higher, it might be not changed actually, because the checks have ranges.

```bash
sudo apt  install speedtest-cli
speedtest-cli --secure --simple
Ping: 18.127 ms
Download: 1.23 Mbit/s
Upload: 33.15 Mbit/s
```
Alternative (and preferably) `speedtest` from `Ookla` (it shows range of speed changes during the test execution):

[`Download for Linux` from the official page](https://www.speedtest.net/ru/apps/cli)

Extract the tgz file.
In the extracted folder you'll find the `speedtest` file. 

Run it:
```bash
./speedtest

   Speedtest by Ookla

      Server: Pfalzkom GMBH - Ludwigshafen (id: 28818)
         ISP: Vodafone Germany
Idle Latency:    14.48 ms   (jitter: 0.69ms, low: 14.09ms, high: 15.29ms)
    Download:     3.89 Mbps (data used: 6.6 MB)                                                   
                591.75 ms   (jitter: 84.49ms, low: 104.86ms, high: 2927.72ms)
      Upload:    35.56 Mbps (data used: 42.8 MB)                                                   
                 50.40 ms   (jitter: 30.30ms, low: 17.51ms, high: 588.17ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/93259aa5-9cc9-45c4-bcb9-ced630e67fd5
```

[Direct link to download the tgz file](https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz)

### Network manager connection editor
```bash
sudo nm-connection-editor
```

### Network configuration files location

On Ubuntu 23.10 and future releases the network configuration is located under `/etc/netplan` in yaml files.

The previous config files location: `/etc/NetworkManager/system-connections`

Use network manager connection editor `sudo nm-connection-editor` instead of editing the config files manually.

Additional info:
- [NetworkManager](https://help.ubuntu.com/community/NetworkManager)
- [Netplan - the network configuration](https://netplan.io/)

### Get info on the current Wi-Fi controller

```bash
lspci | grep Wireless
55:00.0 Wireless controller [0d40]: Intel Corporation XMM7360 LTE Advanced Modem (rev 01)
```

Driver info (`driver=iwlwifi driverversion=6.8.0-45-generic`:
```bash
lshw -C network
  *-network                 
       description: Wireless interface
       product: Wi-Fi 6 AX201
       vendor: Intel Corporation
       physical id: 14.3
       bus info: pci@0000:00:14.3
       logical name: wlp0s20f3
       version: 20
       serial: 7c:21:4a:aa:ba:68
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress msix bus_master cap_list ethernet physical wireless
       configuration: broadcast=yes driver=iwlwifi driverversion=6.8.0-45-generic firmware=77.ad46c98b.0 QuZ-a0-hr-b0-77.u ip=192.168.2.110 latency=0 link=yes multicast=yes wireless=IEEE 802.11
       resources: iomemory:600-5ff irq:16 memory:603f29c000-603f29ffff
```

### Wi-Fi module configuration

```bash
iwconfig
```
Result:
```text
wlp0s20f3  IEEE 802.11  ESSID:"EasyBox-033576"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: 78:94:B4:38:76:D8   
          Bit Rate=54 Mb/s   Tx-Power=22 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=41/70  Signal level=-69 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:10   Missed beacon:0
```

Get detailed wireless information from a wireless interface
```bash
iwlist wlp0s20f3 scan
```

### Wi-Fi adapter scan

```bash
iwlist wlp0s20f3 scan | grep -C7 EasyBox-033576
wlp0s20f3  Scan completed :
          Cell 01 - Address: 78:94:B4:38:76:D8
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=32/70  Signal level=-78 dBm  
                    Encryption key:on
                    ESSID:"EasyBox-033576"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=0000000037adcd5a
                    Extra: Last beacon: 167ms ago
                    IE: Unknown: 000E45617379426F782D303333353736
```

### Wi-Fi adapter supported frequencies

```bash
iwlist wlp0s20f3 frequency
```

### `iwlwifi` modules info, including list of possible parameters:

```bash
modinfo iwlwifi
...
filename:       /lib/modules/6.8.0-45-generic/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko.zst
license:        GPL
description:    Intel(R) Wireless WiFi driver for Linux
name:           iwlwifi
vermagic:       6.8.0-45-generic SMP preempt mod_unload modversions
parm:           swcrypto:using crypto in software (default 0 [hardware]) (int)
parm:           11n_disable:disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX (uint)
parm:           amsdu_size:amsdu size 0: 12K for multi Rx queue devices, 2K for AX210 devices, 4K for other devices 1:4K 2:8K 3:12K (16K buffers) 4: 2K (default 0) (int)
parm:           fw_restart:restart firmware in case of error (default true) (bool)
parm:           nvm_file:NVM file name (charp)
parm:           uapsd_disable:disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3) (uint)
parm:           enable_ini:0:disable, 1-15:FW_DBG_PRESET Values, 16:enabled without preset value defined,Debug INI TLV FW debug infrastructure (default: 16) (uint)
parm:           bt_coex_active:enable wifi/bt co-exist (default: enable) (bool)
parm:           led_mode:0=system default, 1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0) (int)
parm:           power_save:enable WiFi power management (default: disable) (bool)
parm:           power_level:default power save level (range from 1 - 5, default: 1) (int)
parm:           disable_11ac:Disable VHT capabilities (default: false) (bool)
parm:           remove_when_gone:Remove dev from PCIe bus if it is deemed inaccessible (default: false) (bool)
parm:           disable_11ax:Disable HE capabilities (default: false) (bool)
parm:           disable_11be:Disable EHT capabilities (default: false) (bool)
```

### List of loaded/current parameters

```bash
sudo apt install sysfsutils
systool -vm iwlwifi
```
Output:
```text
Module = "iwlwifi"

  Attributes:
    coresize            = "598016"
    initsize            = "0"
    initstate           = "live"
    refcnt              = "1"
    srcversion          = "2553DA4DACB6342A2AD9180"
    taint               = ""
    uevent              = <store method only>

  Parameters:
    11n_disable         = "0"
    amsdu_size          = "0"
    bt_coex_active      = "Y"
    disable_11ac        = "N"
    disable_11ax        = "N"
    disable_11be        = "N"
    enable_ini          = "16"
    fw_restart          = "Y"
    led_mode            = "0"
    nvm_file            = "(null)"
    power_level         = "0"
    power_save          = "N"
    remove_when_gone    = "N"
    swcrypto            = "0"
    uapsd_disable       = "3"
```

### Module parameters setting

For instance, to set `11n_disable` and `power_save` parameters:
```bash
sudo modprobe iwlwifi 11n_disable=1
sudo modprobe iwlwifi power_save=disable
```

Permanently in `/etc/modprobe.d/iwlwifi.conf` file as:
```bash
echo "options iwlwifi swcrypto=0 11n_disable=1 power_save=disable" >> /etc/modprobe.d/iwlwifi.conf
```

### System logs from network devices

```bash
sudo dmesg -T | grep "wlp0s20f3\|iwlwifi"
```
Note: `wlp0s20f3` - name from `iwconfig`

### Make sure Wi-Fi adapter uses 5MGz frequency

This change was the most important to speed the internet connection up.

Note: somehow opening Wi-Fi configuration via the system settings causes the 2nd Wi-Fi connection creation. 
I cannot explain it, but during the following configuration do not open Wi-Fi settings via the system settings!

Here is an example of the wrong value: `Frequency:2.412 GHz`. 
```bash
$ iwconfig
wlp0s20f3  IEEE 802.11  ESSID:"EasyBox-033576"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: 78:94:B4:38:76:D8   
          Bit Rate=130 Mb/s   Tx-Power=22 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=44/70  Signal level=-66 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:37   Missed beacon:0
```
You cannot change Wi-Fi frequency via the system settings. Run network connection editor for NetworkManager: 
```bash
sudo nm-connection-editor
```
- Make sure only a single Wi-Fi connection with the same name exists. 
    The must be no connections with names that differ slightly like: `EasyBox-033576`, `EasyBox-033576 1`, `EasyBox-033576 2`. 
    If you have more than a single, remove all the others and leave only the original `EasyBox-033576` 
- Restart network if you deleted any Wi-Fi connections: `sudo systemctl restart NetworkManager`
- Run network connection editor again, make sure only a single Wi-Fi connection exists, select it.
- Select `Wi-Fi` tab (the 2nd tab after the `General`)
- Select in the `Band` selector: `A (5 GHz)`
- Restart network: `sudo systemctl restart NetworkManager`
- Open network connection editor, make sure you still have the single connection with a chosen `A (5 GHz)` Band. 
    Sometimes the 2nd connection appears with a generated name like `EasyBox-033576 1` and the Band set with `Automatic`.
    I cannot explain it. Actually the system gets connected using this 2nd connection and always `2.412 GHz` is used.
    In my case, it happened every single time, I changed the `Band` of the original connection to: `A (5 GHz)`
    But suddenly on the next day it started working (no 2nd Wi-Fi connection appeared).
- Run:
    ```bash
    iwlist wlp0s20f3 scan | grep -C7 EasyBox-033576
    wlp0s20f3  Scan completed :
              Cell 01 - Address: 78:94:B4:38:76:DA
                        Channel:116
                        Frequency:5.58 GHz (Channel 116)
                        Quality=32/70  Signal level=-78 dBm  
                        Encryption key:on
                        ESSID:"EasyBox-033576"
                        Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                                  36 Mb/s; 48 Mb/s; 54 Mb/s
                        Mode:Master
                        Extra:tsf=000000094b69dd45
                        Extra: Last beacon: 677142ms ago
                        IE: Unknown: 000E45617379426F782D303333353736
                        IE: Unknown: 01088C129824B048606C
    ```
- You must get at least 1 Cell with `Frequency:5.58 GHz`. Now you have `Address: 78:94:B4:38:76:DA` of this cell.
- Open network connection editor, make sure you have a single connection, open the connection
- In the Wi-Fi tab set `BSSID` explicitly to `78:94:B4:38:76:DA`
- Restart network: `sudo systemctl restart NetworkManager`
- make sure the right `Frequency:5.58 GHz` is used for the Wi-Fi adapter:
```bash
iwconfig
wlp0s20f3  IEEE 802.11  ESSID:"EasyBox-033576"  
          Mode:Managed  Frequency:5.58 GHz  Access Point: 78:94:B4:38:76:DA   
          Bit Rate=26 Mb/s   Tx-Power=22 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=34/70  Signal level=-76 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:38   Missed beacon:0
```
- Check the speed: `speedtest-cli --secure`
- Restart the system, make sure the frequency is not changed and still the single Wi-Fi connection is used.


### Change to preferring IPv4 over IPv6

System preferring IPv6 over IPv4. To change to preferring IPv4 over IPv6:

```bash
sudo subl /etc/gai.conf
```
Uncomment the last line to:
```text
#
#    For sites which prefer IPv4 connections change the last line to
#
precedence ::ffff:0:0/96  100
```

[Change to preferring IPv4 over IPv6](https://askubuntu.com/a/1232022/458132)

Additionally, you could disable IPv6 Support entirely.

Chech the current configuration:
```bash
sudo sysctl -a | grep disable_ipv6
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
```
Run:
```bash
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
```
If the temporary disablement works, make the changes permanent by running the following commands:

TODO (after restart the parameters must be saved and ipv6 must be disabled!): 
> Remove custom net.* parameters from /etc/sysctl.conf and place in /etc/ufw/sysctl.conf
```text
#disable ipv6
net/ipv6/conf/all/disable_ipv6=1
net/ipv6/conf/default/disable_ipv6=1
net/ipv6/conf/lo/disable_ipv6=1
```
But it did not help!

[test and finish after rebooting](https://askubuntu.com/questions/1053997/etc-sysctl-conf-settings-do-not-last-after-reboot)
```bash
echo "#disable ipv6"  | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
```

### Disable Power Management:

```bash
iwconfig
```
Result:
```text
wlp0s20f3  IEEE 802.11  ESSID:"EasyBox-033576"  
          ...
          Power Management:on
```

Disable:
```bash
sudo iwconfig wlp0s20f3 power off
```
or:
```bash
sudo modprobe iwlwifi power_save=disable
```

Restarting the Network Manager Service:
```bash
sudo systemctl restart NetworkManager.service
```

Check that the changes are applied:
```bash
iwconfig
```
Result:
```text
wlp0s20f3  IEEE 802.11  ESSID:"EasyBox-033576"  
          ...
          Power Management:off
```

Check if this setting helped.

### Disable Wi-Fi Power Saving

Note: It is not the same as `Power Management`!

Disable Wi-Fi Power Saving  via file configuration:
```bash
sudo subl /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```
Change:
```text
[connection]
wifi.powersave = 3
```
to:
```text
[connection]
wifi.powersave = 2
```
Restarting the Network Manager Service:
```bash
sudo systemctl restart NetworkManager.service
```

[Extremely slow wifi between Ubuntu 24.04 LTS laptop and Deco M5 mesh access points](https://superuser.com/questions/1843548/extremely-slow-wifi-between-ubuntu-24-04-lts-laptop-and-deco-m5-mesh-access-poin)

### Change `11n_disable` parameter

Note: do not set it to `1`:

> In newer kernels, inspected as of 5.3.7, setting 11n_disable=1 (or masked with 0x01) 
> will result in 802.11ac being disabled. 
> This will limit the device to a maximum of 54Mbit throughput.

[See disabling 802.11n](https://wiki.gentoo.org/wiki/Iwlwifi)

Different sources recommend different values as a solution. Possible values for changes:

```bash
modinfo iwlwifi
...
name:           iwlwifi
parm:           11n_disable:disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX (uint)
```
Possible values for changes:
```bash
sudo modprobe iwlwifi 11n_disable=8
sudo modprobe iwlwifi 11n_disable=4
sudo modprobe iwlwifi 11n_disable=2
sudo modprobe iwlwifi 11n_disable=1
sudo modprobe iwlwifi 11n_disable=disable
```
In my case `11n_disable=disable` showed the best result

### Remove `backport-iwlwifi-dkms`

It was a reason in certain cases. 
```bash
sudo apt remove backport-iwlwifi-dkms
```
I don't have this package installed

[Remove `backport-iwlwifi-dkms` for performance](https://askubuntu.com/a/1231662/458132)


### Disable Active-State Power Management (ASPM)

Note: do not do that ever! It affects all hardware. Your dock station might start working incorrectly.

```bash
sudo subl /etc/default/grub
```
add `pcie_aspm=off` in:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm=off"
```
and run:
```bash
sudo update-grub
```

To enable ASPM back, change it to:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm=force"
```
and run:
```bash
sudo update-grub
```
then restart.

Then remove it again to the default value without having `pcie_aspm` parameter:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```
and run:
```bash
sudo update-grub
```
then restart.

Check `ASPM` logs:
```bash
sudo dmesg | grep ASPM
```

[Ubuntu 20.04 slow download speed (wired network)](https://askubuntu.com/a/1347459/458132)