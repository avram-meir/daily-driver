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

# --- Add backfilling if provided ---

if ! [ -z "$back" ] ; then
	echo "Backdating provided!"
	startdate=$(date +%Y%m%d --date "$startdate $back")

	if [ $? -ne 0 ] ; then
		printf "%s is an invalid value for option -b\n" $back >&2
		usage >&2
		exit 1
	fi

fi

echo "${back}"
echo "${startdate}"
echo "${stopdate}"
echo "${config}"

printf "Hello world!\n"

exit 0

