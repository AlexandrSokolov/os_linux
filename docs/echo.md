### redirecting of output of `cat` to `echo`

echo "$(cat my_file.txt)"

### newline vs `\n` literal

```bash

# does not work in all OSs:
echo -e "Hello\nworld"

echo $'hello\nworld'
```


### convert `\n` symbol in the text file into newline:

`$ echo -e "$(cat output.sql)" | tee result.sql`