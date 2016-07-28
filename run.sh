#!/usr/bin/env bash

# script to run the BDE event detection pipeline
# first argument specified scheduled vs single run
echo "Running BDE Event detection driver script."

tabpath="/root/bdetab"
function usage {
	echo "Usage:"
	echo "$0 [scheduled]"
}

bash $EXECDIR/setClassPath.sh
JARCLASSPATH="$(cat $CLASSPATHFILE)"

singleRunModes="newscrawl twittercrawl location cluster"
runscripts=(runNewsCrawling.sh runTwitterCrawling.sh runEventClustering.sh runLocationExtraction.sh  runPipeline.sh)

if [ $# -eq  1 ] ; then
	# provided an argument
	if [ ! $1 == "scheduled" ] ; then
		# single run of a single component
		index=0
		for mode in $singleRunModes; do
			echo "Checking mode $mode vs $1"
			if [ "$mode" == "$1" ] ; then 
				echo "script match: "
				echo "$EXECDIR/${runscripts[$index]}"
				bash "$EXECDIR/${runscripts[$index]}"
				echo "Completed."
				exit 0
			else
				echo "arg $1 is not # $index :  $mode"
				index=$((index+1))
			fi
		done
		>&2 echo "Undefined argument [$1]."
		usage
		exit 1

	else
		# add the script call to a crontab
		echo "Scheduling job according to [$tabpath] :"
		if  [ ! -f $tabpath ] ; then
			>&2 echo "No crontab at $tabpath."
			exit 1
		fi
		cat $tabpath
		crontab $tabpath
	fi
elif [ $# -gt 1 ] ; then
	>&2 echo "$0 needs at most 1 argument."
	usage
	exit 1
else
	# no arguments provided : run whole pipeline once
	echo "Running an one-time instance."
	bash $EXECDIR/runPipeline.sh
	echo "Completed."
fi
