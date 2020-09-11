#/bin/bash

## Coded by 72y9op https://github.com/72y9op

## COLORS
cyan='\e[0;36m' 
green='\e[0;34m'
okegreen='\033[1;92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[0;33m'
BlueF='\e[1;34m' 
RESET="\033[00m" 
orange='\e[38;5;166m'
grey='\e[1;90m'
purple='\e[0;35m'

## SETUP
dir="$PWD"
error="0"
errorBk="0"
errorCp="0"
apps=('zenity' 'yad')
restPres=$(awk '/alias rest/' $HOME/.bash_aliases | awk '{print $0}')
bashUpdate=$(awk '/.bash_aliases/' $HOME/.bashrc | awk '{print $0}')

information(){

	# information {type} {text} {whatIs}
	# type : error, success, good, none
	type=$1
	text=$2
	whatIs=$3
	errorNumber=$3
	
	if [ $type == "error" ]; then
		tput rc; tput ed
		if [ $errorNumber == 1 ]; then
			echo -e "$RESET[\e[1;31mx$RESET] $text :$red fail$RESET"
		else
			echo -e "$RESET[\e[1;31mx$RESET] $text :$red fail ($errorNumber)$RESET"
		fi
	elif [ $type == "success" ];then
		tput rc; tput ed
		echo -e "$RESET[\033[92m✓$RESET] $text :$okegreen successful$RESET"
	elif [ $type == "good" ];then
		tput rc; tput ed
		echo -e "$RESET[\e[0;36m*$RESET] $text :$cyan already $whatIs$RESET"	
	elif [ $type == "add" ];then
		tput rc; tput ed
		echo -en "$RESET[\e[0;35m+$RESET] $text..."	
	elif [ $type == "none" ];then
		tput sc
		printf "$RESET[\e[1;90m-$RESET] $text..."
		
	fi
}

menu() {
	
	echo "Aliaz by 72y9op - Installation"
	echo "----------------------------------------------------"
	
	for SingleApp in ${apps[*]}
	do
		information "none" "Installation of $SingleApp"
		if [ "$SPEED" == "false" ]; then sleep 1; fi
		
		if ! which $SingleApp > /dev/null; then
			sudo apt-get install $SingleApp > /dev/null 2>&1  || ((error=error+1))
			if [ $error > "0" ]; then
				information "error" "Installation of $SingleApp" "$error"
			else
				information "success" "Installation of $SingleApp"
			fi  
		else
			information "good" "Installation of $SingleApp" "installed"
		fi

		if [ "$SPEED" == "false" ]; then sleep 1; fi
	done
		
	information "none" "Check if backup folder exist"
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	
	if [ -z $PWD/backup/ ]; then
		
		information "add" "Make backup folder in $PWD"
		sudo mkdir backup >/dev/null 2>&1  || ((errorBk=errorBk+1))
		if [ "$SPEED" == "false" ]; then sleep 1; fi
		if [ ! $errorBk == "0" ]; then
			information "error" "Creation of Backup folder" "$errorBk"
		else
			information "success" "Creation of Backup folder"
		fi
	else
		information "good" "Creation of Backup folder" "created"
	fi
	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	information "none" "Replace and backup the old language file..."	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	if [ -e /usr/lib/lib_aliazLang ]; then
		sudo mv /usr/lib/lib_aliazLang $PWD/backup/lib_aliazLang_b >/dev/null 2>&1 || ((errorLang=errorLang+1))
		sudo cp lib_aliazLang /usr/lib/lib_aliazLang >/dev/null 2>&1 || ((errorLang=errorLang+1))
	else
		sudo cp lib_aliazLang /usr/lib/lib_aliazLang >/dev/null 2>&1 || ((errorLang=errorLang+1))
	fi
	if [ ! $errorLang == "0" ]; then
		information "error" "Replace and backup the old language file" "$errorLang"
	else
		information "success" "Replace and backup the old language file"
	fi
	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	information "none" "Move the file mkalias in$BlueF /usr/local/bin/$RESET"	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	sudo chmod +x mkalias && sudo cp mkalias /usr/local/bin/ >/dev/null 2>&1 || ((errorCp=errorCp+1))
	if [ ! $errorCp == "0" ]; then
		information "error" "Move the file mkalias" "$errorCp"
	else
		information "success" "Move the file mkalias"
	fi
	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	information "none" "Get the localisation of aliaz folder..."	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	echo $PWD | sed -i "s|DIR=|DIR=\"$dir\"|g" /usr/local/bin/mkalias >/dev/null 2>&1 || ((errorSed=errorSed+1))
	if [ ! $errorSed == "0" ]; then
		information "error" "Insert localisation in mkalias" "$errorSed"
	else
		information "success" "Insert localisation in mkalias"
	fi
	
	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	information "none" "Create a configuration command in$BlueF .bash_aliases$RESET"
	if [ -z "$restPres" ]; then
		echo "alias rest='cd $HOME && clear'" >> $HOME/.bash_aliases >/dev/null 2>&1 || ((errorRest=errorRest+1))
		if [ ! $errorRest == "0" ]; then
			information "error" "Create a configuration command" "$errorRest"
		else
			information "success" "Create a configuration command"
		fi
	fi
	
	information "good" "Command$BlueF rest$RESET" "created"
	
		# NEXTUP LIGNE 25
	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	information "none" "Check if the update of $BlueF .bash_aliases$RESET in $BlueF .bashrc$RESET exist"	
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	
	if [ -z "$bashUpdate" ]; then
		echo "# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi" >> $HOME/.bashrc 
		if [ ! $errorAlias == "0" ]; then
			information "error" "Update of$BlueF .bash_aliases$RESET in$BlueF .bashrc$RESET" "$errorAlias"
		else
			information "success" "Update of$BlueF .bash_aliases$RESET in$BlueF .bashrc$RESET"
		fi
	else
		information "good" "Update of$BlueF .bash_aliases$RESET in$BlueF .bashrc$RESET" "registered"
	fi
	if [ "$SPEED" == "false" ]; then sleep 1; fi
	
	((error=errorBk+errorCp+errorRest+errorSed+errorLang+errorAlias+errorRest+error))
	
	if [ $error == "0" ]; then
		echo    "----------------------------------------------------"
		echo -e "Installation$okegreen successful$RESET !"
		echo    "----------------------------------------------------"
	else
		echo    "----------------------------------------------------"
		echo -e "Installation$red failed$RESET ! Errors : $error"
		echo    "----------------------------------------------------"

	fi
}

SPEED=false

for i in "$@"
do
case $i in
    -s|--speed)
    SPEED=true 
    shift
    ;;
esac
done

menu
