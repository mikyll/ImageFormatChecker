#!/bin/bash

# USAGE: ./img_checker.sh [OPTIONS...]

NAME="img_checker.sh"
DIR="."
m=-1
M=-1
r=0
s=0

usage() { echo "Usage: $0 [-d <dir_name>] [-l <log_file_path>] [-m <min_dim>] [-M <Max_dim>] [-r] [-s]" 1>&2; exit 1;}

while getopts ":d:hm:M:l:rs" opt; do
	case "${opt}" in
		d)	# option "directory"
			DIR="${OPTARG}"
			if [ ! -d "${DIR}" ]
			then
				echo "${DIR} is not a directory"
				exit 1
			fi
			;;
		h)	# option "help"
			echo "Usage: $NAME [OPTION...]"
			echo ""
			echo "	-d <dir_name>, specify the directory inside which the script will loop"
			echo "	-l <file_name>, the script will log the images that aren't correct into <file_name>."
			echo "	-m <min_dim>, the script will check if the dimension of the images are beyond the minimum <min_dim>"
			echo "	-M <max_dim>, the script will check if the dimension of the images are beyond the maximum <max_dim>"
			echo "	-s, the script will check if the images are squared (i.e. NxM with N == M)"
			echo "	-r, rename each file with the name of its parent folder, followed by its index inside the directory"
			echo "		example: /Pokémon/Voltorb/cbahf4kasdm3.jpg -> /Pokémon/Voltorb/Voltorb1.jpg"
			
			exit 0
			;;
		l)	# option "log"
			l="${OPTARG}"
			;;
		m)	# option "min dimension"
			if [ "${OPTARG}" -lt 100 ]
			then
				echo "Minimum dimension cannot be less than 100x100"
				exit 1
			fi
			m="${OPTARG}"
			;;
		M)	# option "Max dimension"
		if [ "${OPTARG}" -gt 2000 ] || [ "${OPTARG}" -lt $m ]
			then
				echo "Maximum dimension cannot be more than 1000x1000 and cannot be less than the specified minimum dimension"
				exit 1
			fi
			M="${OPTARG}"
			;;
		r)	# option "rename"
			r=1
			;;
		s)	# option "square"
			s=1
			;;
		\?)
			echo -e "Invalid option: $OPTARG\n" 1>&2
			usage
			;;
		:)	# invalid option
			echo -e "Invalid option: $OPTARG requires an argument\n" 1>&2
			usage
			;;
	esac
done
shift $((OPTIND-1))

tot_pkmn=0
current_correct=1
tot_wrong=0
i=1
old_name=""
for f in $(find "${DIR}" -name "*.jpg" -or -name "*.jpeg" -or -name "*.png")
do
	
	current_correct=1
	current_pkmn_name=$(echo "${f}" | cut -d '/' -f 2)
	if [ "${old_name}" != "${current_pkmn_name}" ]
	then
		old_name="${current_pkmn_name}"
		i=1
	fi
	
	# option -r
	if [ "$r" -eq 1 ]
	then
		filename="${f##*/}"
		extension="${filename##*.}"
		pokemon_name=$(echo "${f}" | cut -d '/' -f 2)
		
		mv -n "${f}" "${DIR}/${current_pkmn_name}/${current_pkmn_name}$i.${extension}"
		
		f="${DIR}/${current_pkmn_name}/${current_pkmn_name}$i.${extension}"
	fi
	
	ident=$(identify "${f}")
	dim=$(echo $ident | cut -d ' ' -f3)
	width=$(echo $dim | cut -d 'x' -f1)
	height=$(echo $dim | cut -d 'x' -f2)
	
	output="$f"
	
	# option -s
	if [ "$s" -eq 1 ]
	then
		# square check
		(($width == $height)) || output="$output: $(echo 'not squared,')"
		(($width == $height)) || current_correct=0
	fi
	
	# option -m
	if [ "$m" -ne -1 ]
	then
		(($width >= $m && $height >= $m)) || output="$output $(echo 'beyond the minimum size,')"
		(($width >= $m && $height >= $m)) || current_correct=0
	fi
	
	# option -M
	if [ "$M" -ne -1 ]
	then
		(($width <= $M && $height <= $M)) || output="$output $(echo 'beyond the maximum size')"
		(($width <= $M && $height <= $M)) || current_correct=0
	fi
	
	# option -l
	if [ "$l" ]
	then
		((current_correct == 1)) || echo "$output" >> "$l"
	else
		((current_correct == 1)) || echo "$output"
	fi
	
	((current_correct == 1)) || tot_wrong=$(expr $tot_wrong + 1)
	tot_pkmn=$(expr $tot_pkmn + 1)
	i=$(expr $i + 1)
	# echo "${f}" # test
done

echo "Tot pokémon: $tot_pkmn"
echo "Tot wrong: $tot_wrong"
