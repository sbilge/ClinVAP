#!/bin/bash

if [ -f docker.flag ]; then
    if [ ! -e /mnt/homo_sapiens ]; then
        cp -r /opt/vep/.vep/homo_sapiens /mnt
    fi

    for file in human_ancestor.fa.rz human_ancestor.fa.rz.fai LoFtool_scores.txt phylocsf.sql; do
        if  [ ! -f /mnt/$file ]; then
            cp $file /mnt
        fi
    done
else
    cd /mnt
#    perl /opt/vep/src/ensembl-vep/INSTALL.pl -n -c /mnt -d /mnt --CACHE_VERSION 93 --VERSION 93 -a acf -s homo_sapiens -y GRCh37 &&\
    cp /opt/vep/.vep/homo_sapiens /mnt
    wget http://www.broadinstitute.org/~konradk/loftee/human_ancestor.fa.rz
    wget http://www.broadinstitute.org/~konradk/loftee/human_ancestor.fa.rz.fai
    wget https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/90/LoFtool_scores.txt
    wget https://www.broadinstitute.org/%7Ekonradk/loftee/phylocsf.sql.gz && \
    gunzip phylocsf.sql.gz
fi
wait
touch /mnt/completeness.flag
echo "Dependency files are now in the volume. Ready to start ClinicalReportR service" >> /mnt/complete.flag