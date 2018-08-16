#!/bin/bash
while [ ! -f /data/completeness.flag ]; do 
sleep 30
done

OPTIND=1
while getopts "t:p:" opt; do
    case $opt in
        t) infile=$OPTARG
        ;;
        p) savedOut=$OPTARG
        ;;
    esac
done
shift "$((OPTIND-1))"

CPWD=$(pwd)

# outfile=$infile.out.vcf
outfilename=$(basename "$infile")
outname="${outfilename%.*}"

# annotate file
echo "################ Starting variant effect prediction ################"
vep -i $infile -o $outname.vcf --config /opt/vep/.vep/vep.ini && \
echo "################ $outfile is created. ################"

# create json
echo "################ Start to create json ################"
Rscript /opt/vep/reporting.R -f $outname.vcf -r $outname.json && \
echo "################ JSON is created  ################"
cp base.log /inout

if [[ $savedOut == *"j"* ]]; then
    cp $outname.json /inout
    echo "JSON is saved to the volume"
fi

echo "################ Start to create report ################"
nodejs /opt/vep/clinicalreporting_docxtemplater/main.js -d $outname.json -t /opt/vep/clinicalreporting_docxtemplater/data/template.docx -o $outname.docx && \
echo "################ Report is created  ################"
if [[ $savedOut == *"w"* ]]; then
    cp $outname.docx  /inout
    echo "Report is saved to the volume as DOCX file."
fi

    # convert it to pdf
if [[ $savedOut == *"p"* ]]; then
    echo "################ Start to create pdf ################"
    libreoffice --headless --convert-to pdf /inout/$outname.docx  && \
    echo "################ pdf is created  ################"
    cp $outname.pdf /inout && \
    echo "Report is saved to the volume as PDF file."
fi
