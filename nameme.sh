#! /bin/bash

DICT_DIR="/usr/share/dict/words"
DEFAULT_WORD_COUNT=2
DEFAULT_CASING="LOWER_CAMEL"
VALID_CASING=( 
	"camel" 
	"CAMEL"
	"snake" 
	"SNAKE" 
	"case"
	"CASE"
	"sentence"
	"SENTENCE" 
)

echo_ansi_text() {
	if [[ -n $1 && -n $2 ]]; then
		echo -e "$1$2\e[0m"
	fi
}

is_valid_casing() {
	for i in "${VALID_CASING[@]}"; do
		if [[ $i = $1 ]]; then
			echo "valid"
		fi
	done
}

word_count=$DEFAULT_WORD_COUNT
casing=$DEFAULT_CASING

if [[ -z $1 ]]; then
	echo_ansi_text "\e[31m" "No arguments were supplied. Using defaults."
else
	is_casing_type=$(is_valid_casing $1)
	if [[ $is_casing_type = "valid" ]]; then
		casing=$1
	else
		word_count=$1
	fi

	if [[ -n $2 ]]; then
		is_casing_type=$(is_valid_casing $2)
		if [[ $is_casing_type = "valid" ]]; then
			casing=$2
		else
			word_count=$2
		fi
	fi
fi

echo_ansi_text "\e[34m" "\e[33mword_count\t\e[34m| \e[33mcasing\n\e[34m================================\n\e[33m$word_count\t\t\e[34m| \e[33m$casing\n"

outcome=""
max_lines=$(wc -l $DICT_DIR | awk $'{print $1}')

i=1
while [[ $i -le "$word_count" ]]; do
	random_line=$(shuf -i "1-$max_lines" -n 1)
	line=$(awk NR=="$random_line" $DICT_DIR)
	
	append=""
	delimiter=""	
	case $casing in
		"camel") 
			if [[ $i = 1 ]]; then
				append=${line,,}
			else
				append=${line^}
			fi
		;;
		"CAMEL")
			append=${line^}
		;;
		"snake" | "case")
			append=${line,,}
			if [[ $casing = "snake" ]]; then
				if [[ $i -ne $word_count ]]; then
					delimiter="_"
				fi
			fi
		;;
		"SNAKE" | "CASE")
			append=${line^^}
			if [[ $casing = "SNAKE" ]]; then
				if [[ $i -ne $word_count ]]; then
					delimiter="_"
				fi
			fi
		;;
		"sentence" | "SENTENCE")
			delimiter=" "
			if [[ $casing = "sentence" ]]; then
				if [[ $i = 1 ]]; then
					append=${line^}
				else
					append=${line,}
					if [[ $i -eq $word_count ]]; then
						delimiter="."
					fi
				fi
			else
				append=${line^^}
				if [[ $i -eq $word_count ]]; then
					delimiter="!"
				fi
			fi
		;;
	esac

	outcome="$outcome$append$delimiter"
	i="$i + 1"
done

echo_ansi_text "\e[32m" "Randomly generated name: \e[36m$outcome" | tr -d \'

