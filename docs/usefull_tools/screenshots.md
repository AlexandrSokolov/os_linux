
## GNOME Screenshot / GNOME Shell built‑in tool

A built‑in screenshot tool. It supports:
- full screen
- window selection
- area selection
- can copy directly to clipboard
- delay timer (removed from the GUI, but still exists )

```bash
sudo apt install gnome-screenshot
```


- `PrtSc`/`DRUCK` To run the app and choose what to do
- Ctrl + `PrtSc`/`DRUCK` Full screen → Copy to clipboard
- Ctrl + Alt + `PrtSc`/`DRUCK` - Current window → Copy to clipboard
- Shift + Ctrl + `PrtSc`/`DRUCK` Select area → Copy to clipboard

To run full screenshot with delay:
```bash
gnome-screenshot -d 5
```

## Flameshot

The most popular modern choice:
```bash
sudo apt install flameshot
```

GUI + configurable timer features

## Shutter

Old but powerful.

A classic Linux screenshot tool with annotation, editing, and upload options. 
Still available in most distros.
Shutter supports editing like text, pixelation, arrows, etc.

full GUI, delay supported

```bash
sudo apt install shutter
```

## Kazam

Don't use it.

1. Kazam only works reliably under Xorg
   Kazam officially states it only works on Xorg, not Wayland.
   Wayland is becoming the default on Ubuntu and many distros.
   If you're on Wayland, Kazam may not work or may behave inconsistently.
2. Kazam has known screenshot bugs
3. Kazam is primarily a screen recorder, not a screenshot tool
4. Maintenance and distribution issues
    - Kazam disappeared from many distro repositories for some time and must often be installed 
      through pip instead of native packages, which is messy.
    - The latest versions require manual pip-based installation and extra dependencies. [itsfoss.com]
