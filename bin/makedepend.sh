#!/bin/bash
# Small tool to create GNU compatible dependencies from a tex document. 
# It only recognizes the \input statement and recursing for included files.
#
#
#

-set u
-set e

function depend () {
	INPUT=$1
	JOB=$2
	TDEPS=""
	CDEPS=""
	for i in `cat "$INPUT" | grep -v ^[[:space:]]*% | grep "\(input{\|include{\)" | sed -e 's,.*{\(.*\)}.*,\1,g'`
	do
		TDEPS="$TDEPS $i"
		if [ -e "${i}.tex" ]; then
		    TDEPS="$TDEPS `${0} \"${i}.tex\"`"
		elif [ -e "${i}.tikz" ]; then
		    TDEPS="$TDEPS `${0} \"${i}.tikz\"`"
		fi
	done

	for i in `cat "$INPUT" | grep -v ^[[:space:]]*% | grep "lstinputlisting" | sed -e 's,.*{\([^}]*\)}.*,\1,g' `
	do
		CDEPS="$CDEPS $i"	
	done

	BDEPS=""
	for i in `cat "$INPUT" | grep -v ^[[:space:]]*% | grep "bibliography{" | sed -e 's,.*{\([^}]*\)}.*,\1,g'`
	do
		BDEPS="$BDEPS $i.bib"	
	done

	if [ "`dirname "$INPUT"`" == "." ]; then 
		DEP="$INPUT"
	else
		DEP=`dirname "$INPUT"`/`basename "$INPUT" .tex`.tex
	fi

	DEPS=""
	for i in $TDEPS 
	do
		if [ -e "$i.tex" ] ; then 
			DEPS="$DEPS $i.tex"
		fi
		if [ -e "$i.tikz" ] ; then 
			DEPS="$DEPS $i.tikz"
		fi
	done

	
	if [ "$JOB" == "ADD" ] ; then
		echo -n " $DEPS $CDEPS $BDEPS"
	else
		echo -n $DEP `basename $DEP .tex`.dep:  $DEPS $CDEPS $BDEPS
	fi
	
	if [ "X$DEPS" !=  "X" ]; then 
	         for i in $DEPS; do 
	                 depend "$i" "ADD"
	         done
	fi
}

depend "$1"
echo ""


