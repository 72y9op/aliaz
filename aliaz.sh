#!/bin/bash

vers="2.1.0"
dir="$HOME"
dir_lang="/usr/lib"
temp="/tmp/aliases.mkalias"

if [ -f $temp ]
then
	rm $temp
fi

touch $temp
sudo chmod +x $temp


function lang () {

	defLang="en_EN"
	r_lang=$(echo "$LANG" | awk '{{gsub(".UTF-8","")} print}')
	varLang=$(grep $r_lang /usr/lib/lib_aliazLang | awk -F '=' '{print $2}' | awk -F '§' '{print $'$1'}' )

	if [ -z "$varLang" ]; then
		varLang=$(grep $defLang /usr/lib/lib_aliazLang | awk -F '=' '{print $2}' | awk -F '§' '{print $'$1'}' )
		actLang=$defLang
		echo "$varLang"
	else	
		actLang=$r_lang
		echo "$varLang"
	fi
}

function lng() {
	defLang="en_EN"
	r_lang=$(echo "$LANG" | awk '{{gsub(".UTF-8","")} print}')
	varLang=$(grep $r_lang $dir_lang/lib_aliazLang | awk -F '=' '{print $2}' )

	if [ -z "$varLang" ]; then
		actLang=$defLang
	else	
		actLang=$r_lang
	fi
}
export -f lang

while getopts ":i:" option; do 
    case "$option" in 
        i) interf=$OPTARG;; 
        :) error ;; # il manque une valeur ($option = 'b' ici) 
    esac 
done


if [ $interf = "CLI" ]; then 


	clear
	lng
	echo -e "+--------------------------------------------------------+"
	echo -e "|   Aliaz "$vers" CLI vers. ### Lang "$actLang" ### by 72y9op   |"
	echo -e "+--------------------------------------------------------+ \n"
	echo -e "`lang 3` \c"
	read 'name'
	echo -e "`lang 4` \c"
	read 'command'
	echo -e "`lang 5` (y/n) \c"
	read 'clear'

	if [ ${#name} = '0' ] && [ ${#command} = '0' ]
		then
			exit 0
	else
			if  [ $clear = "y" ]; then
				echo alias "$name"="'""rest && $command""'" >> $dir/.bash_aliases
			elif [ $clear = "n" ]; then
				echo alias "$name"="'""$command""'" >> $dir/.bash_aliases
			fi	
			source $dir/.bash_aliases
			notify-send "mkalias" "Command $name created !"
	fi
elif [ $interf="GUI" ]; then
	
	if ! which zenity > /dev/null; then
	      sudo apt-get install zenity >/dev/null
	fi

	if ! which yad > /dev/null; then
	      sudo apt-get install yad >/dev/null
	fi

	awk '/alias/' $dir/.bash_aliases | awk -F '§' '{{gsub("alias ","")} {gsub(/[\47]/,"")} {gsub("=","\n")} print $0}' > $temp

	function func_list () 
	{ 	
		m_list=$(yad --title="`lang 1`" \
			     --borders=10 \
			     --listen \
			     --no-markup \
			     --width=500 \
			     --height=500 \
			     --no-escape \
			     --center \
			     --window-icon=gtk-preferences \
			     --fixed \
			     --separator="§" \
			     --list \
			     --column="`lang 7`":text \
			     --column="`lang 8`":text \
			     --button="`lang 9`"!go-jump:1 < /tmp/aliases.mkalias)
	}
		   
	export -f func_list 

	com=$(yad --title="`lang 1`"\
		  --form \
		  --no-escape \
		  --center \
		  --window-icon=gtk-preferences \
		  --borders=10 \
		  --fixed  \
		  --text="`lang 2`" --text-align=center \
		  --field=:LBL "" \
		  --field="`lang 3`" \
		  --field="`lang 4`"\
		  --field="`lang 5`:CHK" "" "" FALSE \
		  --button="`lang 6`!format-justify-fill:bash -c func_list && echo $func_list"  \
		  --button="`lang 11`"!gtk-quit:1 \
		  --button="`lang 10`"!gtk-ok:0)

	ret_com=$?
	[[ $ret_com -eq 1 ]] && exit 0

	name=$(echo $com | awk 'BEGIN {FS="|" } { print $2 }')
	command=$(echo $com | awk 'BEGIN {FS="|" } { print $3 }')
	clear=$(echo $com | awk 'BEGIN {FS="|" } { print $4 }')

	if [[ $ret_com -eq 0 ]]; then
		if [ ${#name} = '0' ] && [ ${#command} = '0' ]
		then
			exit 0
		else
			if  [ $clear = 'TRUE' ] 
			then
				echo alias "$name"="'""rest && $command""'" >> $dir/.bash_aliases
			else
				echo alias "$name"="'""$command""'" >> $dir/.bash_aliases
			fi	
			source $dir/.bash_aliases
			notify-send "mkalias" "Command $name created !"
		fi
	fi
fi
