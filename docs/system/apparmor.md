To re-install AppArmor on Ubuntu:

```bash
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo apt remove apparmor apparmor-utils
sudo apt install apparmor apparmor-utils
sudo systemctl start apparmor
sudo systemctl enable apparmor
sudo apparmor_status
```

In might break `snap`