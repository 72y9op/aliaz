#!/bin/bash

# COLOOOOOOR ;)

cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[0;33m'
BlueF='\e[1;34m' #Biru
RESET="\033[00m" #normal
orange='\e[38;5;166m'
grey='\e[1;90m'


dir="$HOME"

###################################################################
# MENU
###################################################################


menu() {

if ! which zenity > /dev/null; then
      sudo apt-get install zenity >/dev/null
      echo "installation of zenity : successful"
fi

if ! which yad > /dev/null; then
      sudo apt-get install yad >/dev/null
      echo "installation of yad : successful"
fi

if [ -e /usr/lib/lib_aliazLang ]; then
	sudo mv /usr/lib/lib_aliazLang $PWD/backup/lib_aliazLang_b
	sudo cp lib_aliazLang /usr/lib/lib_aliazLang
else
	sudo cp lib_aliazLang /usr/lib/lib_aliazLang
fi

sudo chmod +x mkalias && sudo cp mkalias /usr/local/bin/ 

restPres=$(awk '/alias rest/' $dir/.bash_aliases | awk '{print $0}')

if [ -z "$restPres" ]; then
	echo "alias rest='cd $HOME && clear'" >> $HOME/.bash_aliases
fi

echo "Installation successful !"
}

menu
