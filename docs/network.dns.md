
### Check dns

```bash
sudo resolvectl statistics
systemctl status systemd-resolved
```

### To flush and reset dns

Run [`fix_network_stack_resolvectl.sh`](../scripts/fix_network_stack_resolvectl.sh):
```bash
./fix_network_stack_resolvectl.sh
```
- Flushes DNS cache with resolvectl
- Restarts systemd-resolved and NetworkManager
- Resets routing tables

