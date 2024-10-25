### java version update
### maven versoin update
### docker intallation, include tools into https://github.com/AlexandrSokolov/java_dev_environments
### appropriate drivers, update https://github.com/AlexandrSokolov/java_dev_environments

### google chrome extensions,document,save, update https://github.com/AlexandrSokolov/java_dev_environments

Adblock Plus - free ad blocker
chrome://extensions/?id=cfhdojbkjhnklbpkdaibdccddilifddb

AdBlock — block ads across the web
chrome://extensions/?id=gighmmpiobklfepjocnamgkkbiglidom

Dark Theme - Dark Reader for Chrome 1.0.9
chrome://extensions/?id=eckokfcjbjbgjifpcbdmengnabecdakp

Google Docs Offline 1.80.1
chrome://extensions/?id=ghbmnnjooekpmoecnnnilnnbdlolhkhi

Live Stream Downloader 0.4.8
chrome://extensions/?id=looepbdllpjgdmkpdcdffhdbmpbcfekj

Chameleon 1.8.7 ? savefrom.net
chrome://extensions/?id=dmpojjilddefgnhiicjcmhbkjgbbclob

CrossPilot
chrome://extensions/?id=migomhggnppjdijnfkiimcpjgnhmnale

Linguee Audio Download
chrome://extensions/?id=mldkoedmkpceicjeobmilbdeebdeljgc

Talend API Tester - Free Edition
chrome://extensions/?id=aejoelaoggembcahagimdiliamlcdmfm

Postman
chrome://extensions/?id=fhbjgbiflinjbdggehcddcbncdddomop

### react frontend instalation, update https://github.com/AlexandrSokolov/java_dev_environments

### openssl issue

10269  openssl pkcs12 -in Systemuser_VAM_BM_MDB_Dev_VWPKI\ 85B2147C5FE96ED7.p12 -nocerts -out VAM_BM_MDB_DEV_certificate.pem
10270  openssl pkcs12 -in Systemuser_VAM_BM_MDB_Dev_VWPKI_85B2147C5FE96ED7.p12 -nocerts -out VAM_BM_MDB_DEV_certificate.pem
12070  openssl pkcs12 -info -in ingka-commercial-planning-dev-9dd937d20ebb.p12 -nodes
12138  openssl pkcs12 -info -in ingka-commercial-planning-dev-9dd937d20ebb.p12 -nodes
12139  openssl pkcs12 -info -in ingka-commercial-camp-prod-e858d6649e9f.p12 -nodes
12730  openssl pkcs12 -in src/test/resources/volkswagen.p12 -nocerts -out VAM_CodeLtd_MDB_Prod_private.key
12733  openssl pkcs12 -in src/test/resources/volkswagen.p12 -clcerts -nokeys -out VAM_CodeLtd_MDB_Dev_certificate.pem
12800  openssl pkcs12 -export -out volkswagen.prod.p12 -in VAM_BM_MDB_PROD_certificate.pem -inkey VAM_BM_MDB_PROD_private.key
13263  find . -name '*.p12'
13264  history | grep p12


### sftp issue

### etckeeper

[How to Manage /etc with Version Control Using Etckeeper on Linux](https://www.tecmint.com/manage-etc-with-version-control-using-etckeeper/)

###
- 
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
