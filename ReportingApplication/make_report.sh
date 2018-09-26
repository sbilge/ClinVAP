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

for file in ${inputFolder}/*.vcf;
do
outfilename=$(basename "$file")
outname="${outfilename%.*}"

# annotate file
echo "################ Starting variant effect prediction ################"
vep -i $file -o $outname.vcf --config /opt/vep/.vep/vep.ini 

# create report as json
echo "################ Start to create json ################"
if [ -f docker.flag ]; then # called by docker
    Rscript /opt/vep/reporting.R -f $outname.vcf -r $outname.json
else
    Rscript /opt/vep/reporting.R -f $outname.vcf -r $outname.json -d /opt/vep/driver_db_dump.json
fi

if [[ $savedOut == *"j"* ]]; then
    cp $outname.json /inout/results
    echo "JSON is saved to the volume"
fi

echo "################ Start to create report ################"
nodejs /opt/vep/clinicalreporting_docxtemplater/main.js -d $outname.json -t /opt/vep/clinicalreporting_docxtemplater/data/template.docx -o $outname.docx
if [[ $savedOut == *"w"* ]]; then
    cp $outname.docx  /inout/results
fi

    # convert it to pdf
if [[ $savedOut == *"p"* ]]; then
    libreoffice --headless --convert-to pdf /inout/$outname.docx  && \
    cp $outname.pdf /inout/results
fi
done
mkdir -p /inout/results/logs
cp *.log /inout/results/logs