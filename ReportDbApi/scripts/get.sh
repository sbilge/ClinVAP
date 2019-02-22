#!/usr/bin/env bash

ENDPOINT=:5151/patient_report
ID="$1"
KEY="$2"

PROJ="projection=={\"$KEY\":1}"
URL="$ENDPOINT/$ID $PROJ"

http $URL | \
	jq ".$KEY" | \
	grep Gene | \
	sed "s/\"Gene\": //g" | \
	sed "s/\"//g" | \
	sed "s/,//g" | \
	sed "s/\s//g" | \
	uniq
