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
if [ -f docker.flag ]; then
    vep -i $infile -o $outname.vcf --config /opt/vep/.vep/vep.ini # called by docker
else
    vep -i $infile -o $outname.vcf -d driver_db_dump.json --config /opt/vep/.vep/vep.ini # called by singularity
fi


# create json
echo "################ Start to create json ################"
Rscript /opt/vep/reporting.R -f $outname.vcf -r $outname.json && \
cp base.log /inout

if [[ $savedOut == *"j"* ]]; then
    cp $outname.json /inout
    echo "JSON is saved to the volume"
fi

echo "################ Start to create report ################"
nodejs /opt/vep/clinicalreporting_docxtemplater/main.js -d $outname.json -t /opt/vep/clinicalreporting_docxtemplater/data/template.docx -o $outname.docx
if [[ $savedOut == *"w"* ]]; then
    cp $outname.docx  /inout
fi

    # convert it to pdf
if [[ $savedOut == *"p"* ]]; then
    libreoffice --headless --convert-to pdf /inout/$outname.docx  && \
    cp $outname.pdf /inout
fi
done