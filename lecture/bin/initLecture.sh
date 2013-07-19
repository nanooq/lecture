#!/bin/bash
##########################################################################
# A short script to copy the necessary files into the lecture directory.
# You may already provide title and term (aka the time interval) of the
# lecture
###########################################################################
#
# Open Tasks
# * Prepare (multiple) Authors
# * Interactive Installation (Ask for values)
# * Installation by Configuration (key=value)
# * Different templates/document structures
# * Preparation of lecture files
# * Check for libraries
###########################################################################





srcdir="${HOME}/share/latex/lecture"
dstdir=`pwd`
copyall=


title="Please insert title"
interval="Winter Term 2013/14"

declare -A bodyreplace=()
declare -A titlereplace=()

while getopts cs:d:t:m: name
do
    case $name in
    d)    dstdir="$OPTARG";;
    s)    srcdir="$OPTARG";;
    c)    copyall=true;;
    t)    title="$OPTARG"
    	  bodyreplace["!!!TITLE!!!"]="${OPTARG}" 
    	  titlereplace["!!!TITLE!!!"]="${OPTARG}" ;;
    i)    interval="$OPTARG"
    	  bodyreplace["!!!TERM!!!"]="${OPTARG}" 
    	  titlereplace["!!!TERM!!!"]="${OPTARG}" ;;
    ?)   printf "Usage: %s: [-c] [-t title] [-i time interval/semester] [-s srcdir] [-d dstdir] [lectures... (not yet functional)]\n" $0
          exit 2;;
    esac
done
echo "Install from ${srcdir}" >&2
echo "Install to ${dstdir}" >&2

shift $(($OPTIND - 1))
#printf "Remaining arguments are: %s\n" "$*"

askproceed() {
	echo -n "Proceed [y|N]? " 
	proceed="n"
	read proceed

	if [ "$proceed"  != "y" ]; then
		echo "exiting..." 
		exit 0
	fi
}

prepareFile() {
	file=$1
	replacements=$2
	echo "preparing ${file}"
	for i in ${!replacements[@]}; do
		echo -e "\treplacing ${i} with ${replacements[${i}]}"
		sed -i "/${i}/${replacements[${i}]}/" ${file}
	done
}

# files that should not be changed by the user
declare -a linkfiles=("Lecture_Notes.tex"  "Lecture_Slides.tex" "bin/Makefile" "bin/makedepend")
# template files to be copied to the directory to be changed
declare -a copyfiles=("body.tex" "title.tex" "introduction.tex") #"body.tex", "titlepage.tex" 

declare -A preparefiles=(["body.tex"]=${bodyreplace} ["title.tex"]=${titlereplace})

if [ -z "${copyall}" ] ; then
	echo "Now linking files ${linkfiles[@]}."
	echo "Now copying files ${copyfiles[@]}."
	askproceed

	for lf in ${linkfiles[@]}; do
		ln -s "${srcdir}/${lf}" "${dstdir}/`basename ${lf}`"
	done
else
	echo "Now copying files ${linkfiles} ${copyfiles}."
	askproceed
        for lf in ${linkfiles[@]}; do
                cp -i "${srcdir}/${lf}" "${dstdir}/${lf}"
        done
fi
for cf in ${copyfiles[@]}; do
	cp -i "${srcdir}/${cf}" "${dstdir}/${cf}"
done


for pf in ${preparefiles[@]}; do
	prepareFile "${dstdir}/${pf}" ${preparefiles[${pf}]}
done



