Options:
- [with `grep`](#search-with-grep)
- [with `find`](#search-with-find)
- [search tools for huge files](#search-tools-for-huge-files)

See also:
[Find all files containing a specific text (string) on Linux?](https://stackoverflow.com/questions/16956810/find-all-files-containing-a-specific-text-string-on-linux)

### search with `grep`

1. Search in the current directory among `java` and `cpp` files containing the whole word `ExcelReaderService`:
  ```bash
  $ grep --include=\*.{java,cpp} -Rnw . -e 'ExcelReaderService'
  ```
  
  In each line outputs path to the file name (per line), line number and the text, containing the word:
  ```bash
  ./path/to/project/in/current/directory/src/main/java/com/example/ExcelReaderService.java:30:public class ExcelReaderService {
  ```

2. to show only file names, without line number and text, use `l` option:
  ```bash
  $ grep --include=\*.{java,cpp} -Rlw . -e 'ExcelReaderService'
  ```

3. To exclude dirs use `--exclude-dir`:
  ```bash
  grep --exclude-dir={dir1,dir2,*.dst} -rnw /path/to/search -e "pattern"
  ```

### search with `find`

Find all the files, containing the text and display all such lines per file
```bash
find . -name '*.java' -exec grep -i 'ExcelReaderService' {} \; -print
```

Shows file path and then all lines, containing the text:
```bash
./path/to/file/src/com/example/ExcelReaderServiceTest.java
public class ExcelReaderService {
  private static final Logger logger = LogManager.getLogger(ExcelReaderService.class.getName());
  public static ExcelReaderService instance(Map<String, String> column2Attribute) {
    return new ExcelReaderService(column2Attribute);
```

### search tools for huge files

- [RipGrep](https://github.com/BurntSushi/ripgrep)
  ```bash
  rg 'text-to-find-here' / -l
  ```
- [The Silver Searcher](https://geoff.greer.fm/ag/)
  ```bash
  ag 'text-to-find-here' / -l
  ```
  


