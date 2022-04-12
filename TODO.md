- read file lines into array
```bash
mapfile -t projects < projects.conf
echo $projects
```
  
- [Colored and formatted messages](docs/bash_tip_colors_and_formatting.pdf)

Make it in the same way, as is used by Maven.

Prefix is bold and colored.

The message itself is just a bit changed.

Provide different methods for: INFO, WARNING, ERROR

[See also](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)

- [split string](https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in)
- [Loop through array of strings](https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash)
```bash
declare -a projects=(

)

mapfile -t projects < projects.conf

for project_2_folder in "${projects[@]}"
do
  array=($project_2_folder)
  project_url=${array[0]}
  project_folder=$(basename ${project_url}) # remove `.git` from the path
  project_folder=${project_folder//".git"} # remove `.git` from the path
  branch=${array[1]}
  
done
```
- [Loop through list of strings](https://linuxhint.com/bash_loop_list_strings/)
