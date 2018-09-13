
# freepbx-install
Automate install asterisk 14 with FreePBX 14  

### Requirements
System: Centos 7  
Script must be run from root user  
SElinux disabled

For install FreePBX run in terminal next command
```
bash <(curl -s -L https://raw.githubusercontent.com/Hirukami/freepbx-install/master/install.sh)
```
Asterisk will be installed with next futures:
 -  SRTP 
 - MP3 MOH 
 - pjproject
 - res_config_mysql (MySQL RealTime Configuration Driver)  

Additional codecs:  
 - codec_opus
 - codec_silk
 - codec_siren7
 - codec_siren14
 - codec_g729a
