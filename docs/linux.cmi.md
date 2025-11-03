
## Enrich Linux Command Line

### Set commandline history unlimited

Change in `~/.bashrc`:
```bash
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1
```
For old bash versions:
```bash
HISTSIZE= 
HISTFILESIZE=
```

### Enable additional hotkeys

Copy [`inputrc`](files/inputrc) file under `~/.inputrc`

### `inputrc` file purpose

[`inputrc`](files/inputrc) deals with the mapping of the keyboard for certain situations.
This file is the start-up file used by readline, the input related library used by bash and most other shells.

- global values are set in `/etc/inputrc`.
- user values are set in `~/.inputrc`. User file overrides the global settings file.

### Using Ctrl-left-arrow and Ctrl-right-arrow for word moving

```bash
# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
"\e[1;5C": forward-word
"\e[1;5D": backward-word
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word


```

### Incremental history searching

Default search - press `Ctrl+R`.

For Sane incremental history search:
1. type the first few letters of the command
2. click the up arrow/down arrow to search the subset of the history

Add into [`inputrc`](files/inputrc):
```bash
"\e[C": forward-char
"\e[D": backward-char

"\e[A": history-search-backward
"\e[B": history-search-forward
```
['From now on, and many agree this is the most useful terminal tool, it saves you a lot of writing/memorizing...'](https://help.ubuntu.com/community/UsingTheTerminal)



