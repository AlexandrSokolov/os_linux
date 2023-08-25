* [Find laptop model](#finding-laptop-model-on-ubuntu-linux)


### Finding laptop model on Ubuntu Linux

```bash
for d in system-manufacturer system-product-name system-version bios-release-date bios-version
do    
      echo "${d^} : " $(sudo dmidecode -s $d); 
done
```
Output:
```text
System-manufacturer :  HP
System-product-name :  HP ProBook 450 G7
System-version : 
Bios-release-date :  04/26/2021
Bios-version :  S71 Ver. 01.09.00
```
