### Running bash script, options
For instance, we have `some.smart.sh` script, located in `~/projects/a/scripts` folder.

By default, you have 2 options to run it:
1. By changing the pwd to `~/projects/a/scripts` and running it from that folder`:
```bash
cd ~/projects/a/scripts
./some.smart.sh
```
2. By specifying the path to the script. It could be absolute, or relative path. Examples:
```bash
# via absolute path:
/home/projects/a/scripts/some.smart.sh
# via relative path:
cd ~/projects/a
./scripts/some.smart.sh
```

### Ability to run script from any path location

To be able to run any script from any path location,
that location must be included into the `PATH` variable.

To automate process:
1. Copy `commons.sh` and `extendPath` files into the `scripts` folder of your project:
2. Run: `./scripts/extendPath.sh`
3. Restart the system.

Run: `. ~/.profile` To get the functionality for the current session without restart.

4. Create your custom bash script in the `scripts` folder of your project,
   for instance `some.smart.sh`
5. Add the following header into the `some.smart.sh`
```bash
#!/bin/bash

source `dirname "$0"`/commons.sh
changePwd2ScriptsFolder

echo "My great script"
```
6. Add execution rights to the script: `chmod +x scripts/some.smart.sh`
7. Now you could run the script from any path location as `some.smart.sh`

### Passing file path to the script

File path could be absolute, relative or just a file name in the current folder.

You could validate the path and extract from it the file basename, or the path location.

[Passing file path example](../scripts/pass.file.2.script.sh)

### Passing named parameters:

You might want to [add some required and optional named parameters](../scripts/pass.named.parameters.2.script.sh),
look like: `a.sh --name1 value1 --name2 value2`

### Passing unnamed parameters

You might want to [add some required and optional unnamed parameters](../scripts/pass.unnamed.parameters.2.script.sh), 
look like: `a.sh param1 param2`

