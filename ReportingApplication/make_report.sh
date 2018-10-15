#!/bin/bash
while [ ! -f /data/completeness.flag ]; do 
sleep 30
done


OPTIND=1
while getopts "t:p:" opt; do
    case $opt in
        t) inputFolder=$OPTARG
        ;;
        p) savedOut=$OPTARG
        ;;
    esac
done
shift "$((OPTIND-1))"

CPWD=$(pwd)
RESULTS="${inputFolder}/results"
LOGS="${inputFolder}/results/logs"

for file in ${inputFolder}/*.vcf;
do
outfilename=$(basename "$file")
outname="${outfilename%.*}"

mkdir -p $LOGS

# annotate file
echo "################ Starting variant effect prediction ################"
vep -i $file -o /tmp/$outname.vcf --config /opt/vep/.vep/vep.ini 

# check if there are any metadata for patient info
metadata=$(basename "$file")_metadata.json

# create report as json
echo "################ Start to create json ################"
if [ -f docker.flag ]; then # called by docker
    if [ ! -f $metadata ]; then
        Rscript /opt/vep/reporting.R -f /tmp/$outname.vcf -r /tmp/$outname.json
    else
        Rscript /opt/vep/reporting.R -f /tmp/$outname.vcf -r /tmp/$outname.json -m $metadata
    fi
else
    if [ ! -f $metadata ]; then
        Rscript /opt/vep/reporting.R -f /tmp/$outname.vcf -r /tmp/$outname.json -d /opt/vep/driver_db_dump.json
    else
        Rscript /opt/vep/reporting.R -f /tmp/$outname.vcf -r /tmp/$outname.json -d /opt/vep/driver_db_dump.json -m $metadata
    fi
fi

if [[ $savedOut == *"j"* ]]; then
    cp /tmp/$outname.json $RESULTS
    echo "JSON is saved to the volume"
fi

cp /tmp/*.log $LOGS

echo "################ Start to create report ################"
nodejs /opt/vep/clinicalreporting_docxtemplater/main.js -d /tmp/$outname.json -t /opt/vep/clinicalreporting_docxtemplater/data/template.docx -o /tmp/$outname.docx
if [[ $savedOut == *"w"* ]]; then
    cp /tmp/$outname.docx  $RESULTS
fi

    # convert it to pdf
if [[ $savedOut == *"p"* ]]; then
    libreoffice --headless --convert-to pdf /tmp/$outname.docx  --outdir  $RESULTS
fi
done
