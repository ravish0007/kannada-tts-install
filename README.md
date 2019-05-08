# Kannada-TTS-install-script

Author : T Shrinivasan <tshrinivasan@gmail.com>
git clone https://github.com/tshrinivasan/tamil-tts-install.git

This is a modified script of above authors code for Kannada


This is a script to install the Kannada text to Speech System provided by IIT Madras 
https://www.iitm.ac.in/donlab/tts/voices.php

## System requirements:
1. Ubuntu 16.04
2. Ubuntu 18.04

## Will it work on Windows?
No. 

## How to Install
```
git clone https://github.com/ravish0007/kannada-tts-install.git
cd kannada-tts-install
./kannada-tts.sh --clean --setup

```

## How to convert kannada text to .wav
```
cd kannada-tts-install
./kannada-tts.sh --run --source kannada-text.txt
```
This will generate 'kannada-text.wav' file

## How to convert kannada text to .mp3
```
cd kannada-tts-install
./kannada-tts.sh --run --gen-mp3 --source kannada-text.txt
```
This will generate 'kannada-text.mp3' file

## howto set your own HTKUSER and HTKPASSWORD in kannada-tts.sh
Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password, replace your
own username and passward in HTKUSER and HTKPASSWORD
