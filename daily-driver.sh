#!/bin/bash

if [ -s ~/.profile ] ; then
        . ~/.profile
fi

# --- Usage ---

usage() {
	printf "\nUsage : %s [options]\n\n" $(basename $0)
	printf "Options : \n"
	printf "   -b <string>       Backfill period (valid date delta, e.g., '-30 days')\n"
	printf "   -c <filename>     Configuration file listing archive files to check\n"
	printf "   -d <date>         Date to check and update in the archive\n"
	printf "       or\n"
	printf "   -d <date1 date2>  Date range to check and update in the archive\n"
	printf "                     If -b option is also provided, the backfilling period\n"
	printf "                     will be set prior to date1\n"
	printf "   -h                Print this usage message and exit\n\n"
}

# --- Process input args ---

while getopts ":b:c:d:h" option; do
	case $option in
		b)
			back=("$OPTARG");;
		c)
			config=("$OPTARG");;
		d)
			dates+=("$OPTARG");;
		h)
			usage
			exit 0;;
		:)
			printf "Error: Option -%s requires a value\n" $OPTARG >&2
			usage >&2
			exit 1;;
		*)
			printf "Error: Invalid usage\n" >&2
			usage >&2
			exit 1;;
	esac
done

# --- Set dates to check and update ---

dstart=""
dstop=""

if [ ${#dates[@]} -eq 0 ] ; then
	dstart=$(date +%Y%m%d --date "today")
	dstop=$dstart
elif [ ${#dates[@]} -eq 1 ] ; then
	dstart=${dates[0]}
	dstop=$dstart
elif [ ${#dates[@]} -ge 2 ] ; then
	dstart=${dates[0]}
	dstop=${dates[1]}
fi

# --- Validate the dates ---

startdate=$(date +%Y%m%d --date $dstart)

if [ $? -ne 0 ] ; then
	printf "%s is an invalid date\n" $dstart >&2
	usage >&2
	exit 1
fi

stopdate=$(date +%Y%m%d --date $dstop)

if [ $? -ne 0 ] ; then
	printf "%s is an invalid date\n" $dstop >&2
	usage >&2
	exit 1
fi

if [ $startdate -gt $stopdate ] ; then
	tempdate=$enddate
	enddate=$startdate
	startdate=$tempdate
fi

# --- Add backfilling if provided ---

if ! [ -z "$back" ] ; then

	startdate=$(date +%Y%m%d --date "$startdate $back")

	if [ $? -ne 0 ] ; then
		printf "%s is an invalid value for option -b\n" $back >&2
		usage >&2
		exit 1
	fi

fi

# --- Get archive information from config file ---

alwaysupdate=0

if [ -z $config ] ; then    # Always update if no config file was supplied
	alwaysupdate=1
elif [ -s $config ] ; then  # Config file supplied

	# --- Execute the file as a bash script to pull in expected variables ---

	. $config

	if [ -z "$archive" ] ; then
		printf "No archive parameter found in %s\n" $config >&2
		alwaysupdate=1
	fi

	if [ -z "$files" ] ; then
		printf "No files parameter found in %s\n" $config >&2
		alwaysupdate=1
	fi

else
	printf "%s is an empty file or does not exist\n" $config >&2
	usage >&2
	exit 1
fi

# --- Loop through all days in the range defined by startdate and enddate ---

printf "Scanning and updating archive from %s to %s\n" $startdate $stopdate

cd $(dirname "$0")

failed=0
date=$startdate

until [ $date -gt $stopdate ] ; do
	update=0

	if [ $alwaysupdate -eq 1 ] ; then
		update=1
	else

		# --- Scan archive for missing files ---

		for fil in "${files[@]}" ; do
			filename="${archive}/${fil}"
			filename=$(date +"${filename}" --d "${date}")

			if ! [ -s $filename ] ; then
				update=1
			fi
			
		done

	fi

	if [ $update -eq 1 ] ; then
		printf "Updating archive for %s\n" $date

		# ********************************
		#                                *
		# Do your wonderful stuff here!  *
		#                                *
		# ********************************

		# Do something with $failed if things go wrong

	else
		printf "Archive complete for %s\n" $date
	fi

	date=$(date +%Y%m%d --date "$date+1day")
done

exit 0

