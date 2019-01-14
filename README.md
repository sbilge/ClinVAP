# Clinical Reporting Pipeline

Clinical Reporting Pipeline creates a genetic report of somatic mutations from a variant call format (VCF) file. Details of the pipeline is available at [Wiki page](https://github.com/PersonalizedOncology/ClinicalReportingPipeline/wiki). 

## Usage with Singularity

Requirements: Singularity 2.4+  
Please make sure that you have 12 GB of empty space on your home directory, and ports 5000 and 27021 are not being used by another application.
To run the pipeline, please follow the steps given below. 

1. Pull reporting image from Singularity Hub.
 `singularity pull -n reporting_app.img  shub://sbilge/ClinicalReportingPipeline:report` 
2. Pull dependency files image from Singularity Hub. 
`singularity pull -n file_deploy.img  shub://sbilge/ClinicalReportingPipeline:filedeploy`
3. Run dependency files image first to transfer those file on your local folder. 
 `singularity run -B /LOCAL/PATH/TO/FILES:/mnt file_deploy.img`
4. Run the reporting image to generate the clinical reports. 
`singularity run -B /LOCAL/PATH/TO/FILES:/data -B /PATH/TO/INPUT/DATA:/inout reporting_app.img -t /inout -p jwp`

You should now have the report in your /PATH/TO/INPUT/DATA folder.

## Usage with Docker

### For Mac and Ubuntu Users

Requirements: Docker Engine release 1.13.0+, Compose release 1.10.0+.  
Please make sure that you have 34 GB of physical empty space on your Docker Disk Image, and ports 5000 and 27017 are not being used by another application.

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

### Running with Docker Toolbox For Windows Users 

Requirements: Docker Engine release 1.13.0+, Compose release 1.10.0+.  
Please make sure that you have 34 GB of physical empty space on your Docker Disk Image, and ports 5000 and 27017 are not being used by another application.

To tun the pipeline, please follow the steps given below. 

```
1. git clone https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git
```
Pelase note that the input VCF file(s) should be in ReportingApplication/inout folder.

```
2. cd ClinicalReportingPipeline/
3. docker-compose run --service-ports ClinicalReportR -t //inout -p jwp

```
* `-t`: folder name containing input data. This should be in the data volume of ClinicalReportR service (modify Docker compose file to change this).
* `-p`: output format to save the results.
	* `j` to save report in JSON format
	* `w` to save report in DOCX format
	* `p` to save report in PDF format

You should now have the report in ReportingApplication/inout folder.



## Demo Run
We provided an example input file, strelka\_passed\_missense\_somatic\_snvs.vcf under ./ReportingApplication/inout folder along with a dummy metadata file, strelka\_passed\_missense\_somatic\_snvs.json.  

### Running Demo with Singularity
```
1. git clone https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git
2. singularity pull -n reporting_app.img  shub://sbilge/ClinicalReportingPipeline:report
3. singularity pull -n file_deploy.img  shub://sbilge/ClinicalReportingPipeline:filedeploy
4. mkdir vep_files
5. singularity run -B ./vep_files:/mnt file_deploy.img
6. singularity run -B ./vep_files:/data -B ./ClinicalReportingPipeline/ReportingApplication/inout:/inout reporting_app.img -t /inout -p jwp

```
### Running Demo with Docker

```
1. git clone https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git
2. cd ClinicalReportingPipeline/
3. docker-compose run --service-ports ClinicalReportR -t /inout -p jwp

```
