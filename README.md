# Clinical Reporting Pipeline

This is a prototype implementation of a clinical reporting pipeline in R.
It creates a genetic report of somatic mutations from a vcf file annotated via [Ensembl Variant Effect Predictor](https://github.com/Ensembl/ensembl-vep).

Note: CIViC only supports reference genome build 37.



## Usage with Docker

We assume that we want to create a report for a vcf file, and that you have Docker installed. 

We clone this repository and checkout the single_script branch:

```
1. git clone -b master https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git
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

