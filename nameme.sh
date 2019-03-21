#! /bin/bash

DICT_DIR="/usr/share/dict/words"
DEFAULT_WORD_COUNT=2
DEFAULT_CASING="LOWER_CAMEL"
VALID_CASING=( 
	"LOWER_CAMEL" 
	"UPPER_CAMEL"
	"LOWER_SNAKE" 
	"UPPER_SNAKE" 
	"LOWER_CASE"
	"UPPER_CASE"
	"SENTENCE" 
)

echo_ansi_text() {
	if [[ -n $1 && -n $2 ]]; then
		echo -e "$1$2\e[0m"
	fi
}

word_count=$DEFAULT_WORD_COUNT
casing=$DEFAULT_CASING

if [[ -z $1 ]]; then
	echo_ansi_text "\e[31m" "No arguments were supplied. Using defaults."
else
	word_count=$1

	if [[ -n $2 ]]; then
		for i in "${VALID_CASING[@]}"; do
			if [[ $i = $2 ]]; then
				casing=$2
			fi
		done 
	fi
fi

echo_ansi_text "\e[33m" "word_count\t| casing\n================================\n$word_count\t\t| $casing"

outcome=""
max_lines=$(wc -l $DICT_DIR | awk $'{print $1}')

i=1
while [[ $i -le "$word_count" ]]; do
	delimiter=""
	if [[ $outcome != "" ]]; then
		if [[ $casing = "LOWER_SNAKE" || $casing = "UPPER_SNAKE" ]]; then
			delimiter="_"
		elif [[ $casing = "SENT" ]]; then
			delimiter=" "
		fi	
	fi

	random_line=$(shuf -i "1-$max_lines" -n 1)
	line=$(awk NR=="$random_line" $DICT_DIR)
	append=""
	
	case $casing in
		"LOWER_CAMEL") 
			if [[ $i = 1 ]]; then
				append=${line,,}
			else
				append=${line^}
			fi
		;;
		"UPPER_CAMEL")
			append=${line^}
		;;
		"LOWER_SNAKE" | "LOWER_CASE")
			append=${line,,}
		;;
		"UPPER_SNAKE" | "UPPER_CASE")
			append=${line^^}
		;;
		"SENT")
			if [[ $i = 1 ]]; then
				append=${line^}
			else
				append=${line,}
			fi
		;;
	esac

	outcome="$outcome$delimiter$append"
	i="$i + 1"
done

echo_ansi_text "\e[32m" "Randomly generated name: $outcome"

