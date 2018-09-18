1. `singularity pull -n reporting_app.img  shub://sbilge/ClinicalReportingPipeline:report`
2. `singularity pull -n file_deploy.img  shub://sbilge/ClinicalReportingPipeline:filedeploy`
3. `singularity run -B /beegfs/work/iissu01/icgc_vcfs/files:/mnt file_deploy.img`
4. `singularity run -B /beegfs/work/iissu01/icgc_vcfs/files:/data -B /beegfs/work/iissu01/icgc_vcfs/icgc_somatic_vcf:/inout reporting_app.img -t /inout -p jwp`
5. `singularity shell -B /beegfs/work/iissu01/icgc_vcfs/files:/data -B /beegfs/work/iissu01/icgc_vcfs/icgc_somatic_vcf:/inout reporting_app.img`