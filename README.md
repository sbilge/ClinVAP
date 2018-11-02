# Clinical Reporting Pipeline

Clinical Reporting Pipeline creates a genetic report of somatic mutations from a variant call format (VCF) file. It supports reference genome build 37. 


## Usage with Docker

Requirements: Docker 
To tun the pipeline, please follow the steps given below. 

```
1. git clone https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git
```
Pelase note that the input VCF file(s) should be in ReportingApplication/inout folder.

```
2. cd ClinicalReportingPipeline/
3. docker-compose run --service-ports ClinicalReportR -t /inout -p jwp

```
* `-t`: folder name containing input data. This should be in the data volume of ClinicalReportR service (modify Docker compose file to change this).
* `-p`: output format to save the results.
	* `j` to save report in JSON format
	* `w` to save report in DOCX format
	* `p` to save report in PDF format

You should now have the report in ReportingApplication/inout folder.


## Usage with Singularity

Requirements: Singularity
To run the pipeline, please follow the steps given below. 

1. Pull reporting image from Singularity Hub.
 `singularity pull -n reporting_app.img  shub://XXX/ClinicalReportingPipeline:report` 
2. Pull dependency files image from Singularity Hub. 
`singularity pull -n file_deploy.img  shub://XXX/ClinicalReportingPipeline:filedeploy`
3. Run dependency files image first to transfer those file on your local  folder. 
 `singularity run -B /LOCAL/PATH/TO/FILES:/mnt file_deploy.img`
4. Run the reporting image to generate the clinical reports. 
`singularity run -B /LOCAL/PATH/TO/FILES:/data -B /PATH/TO/INPUT/DATA:/inout reporting_app.img -t /inout -p jwp`

You should now have the report in your /PATH/TO/INPUT/DATA folder.
