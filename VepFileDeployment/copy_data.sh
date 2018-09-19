#!/bin/bash

if [ ! -e /mnt/homo_sapiens ]; then
    cp -r /opt/vep/homo_sapiens /mnt
fi

for file in human_ancestor.fa.rz human_ancestor.fa.rz.fai LoFtool_scores.txt phylocsf.sql; do
    if  [ ! -f /mnt/$file ]; then
        cp $file /mnt
    fi
done

wait
touch /mnt/completeness.flag
echo "Dependency files are now in the volume. Ready to start ClinicalReportR service" >> /mnt/complete.flag