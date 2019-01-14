## Introduction
The clinical reporting pipeline extracts information from simple somatic mutations (SNVs) of a patient given in VCF files and creates structured clinical reports by annotating, prioritizing and filtering the genomic variants. The report is designed to provide decision making assistance for Molecular Tumor Boards (MTB) by equipping them with the molecular mechanisms initiating carcinogenesis and actionable genes.

**Disclaimer**
The report created by clinical reporting application is intended as a hypothesis generating framework and is thus intended for research use only and not for diagnostic or clinical purposes. Information provided in the report does not replace a physician's medical judgment and usage is entirely at your own risk. The providers of this resource shall in no event be liable for any direct, indirect, incidental, consequential, or exemplary damages.

## Pipeline Components
The pipeline consists of two major components which are the database instance, and the reporting application. The database is queried by the reporting application to annotate the genes as drivers and to reveal the cancer drugs targeting the mutated genes. The reporting application uses Ensembl Variant Effect Prediction (VEP) to predict the variant effects, R based processing script to process, filter and prioritise the variants, and docxtemplater mail merging tool to render the results into the report template. 

### Database
The genes are annotated with their action type i.e. Tumor suppressor gene (TSG), or Oncogene if they are identified as driver. They are further annotated with the information of their targeting drugs. Those information is incorporated into a MongoDB database and queried by the reporting application for every somatic variant from the patient.

Information on the driver genes are collected from public databases and literature such as COSMIC v81, TSGene2.0, UniProtKB, Rubio-Perez et al. and Vogelstein et al.  

Information on drugs is collected from DrugBank 5.0.7, Therapeutic Target Database (TTD), The International Union of Basic and Clinical Pharmacology 2017.5. 

### Reporting Application

**Ensembl VEP.** The first step of the pipeline is to annotate the variants given in the VCF file using Ensembl VEP v93. For compatibility of the VEP output with the rest of the pipeline, human genome assembly GRCh37 is used. 
Loss of Function Transcript Effect Estimator (LOFTEE) is used to predict the variants causing loss of function of protein coding genes (https://github.com/konradjk/loftee). SIFT and Polyphen are included in the VEP for further annotation to reveal the effect of variants provided in the input file over the function of the proteins. SIFT is used to identify whether an amino acid substitution leads to a non-synonymous single nucleotide polymorphism (nsSNP), and hence to categorise the mutations as "deleterious" (damaging) or "tolerated". The PolyPhen software tool is used to label the variants as "probably damaging", "possibly damaging" or "benign".

**R Based Reporting Application.** The output of the variant effect prediction is channeled into R based reporting application to further process the data and extract the necessary information to create the report. The variant effects predicted as "low" or "moderate" are filtered along with the predictions of SIFT and PolyPhen as "tolerated" or "low confidence tolerated" and "benign". For the remaining genes, the database is queried to identify driver genes. Cancer drugs targeting the affected genes are also identified using the database. Clinical evidence summaries from the CIViC database are also incorporated to identify the therapeutics that have evidence of directly targeting the observed variants. The results are outputted as *JSON* file. 
Patient metadata in *JSON* format is also parsed here, and merged with the output file. Please note that, for the application to identify the metadata, it has to have the same name as the input *VCF* file with *JSON* extension and be structured as follows:

{  
"patient_firstname":"<NAME>",  
"patient_lastname":"<SURNAME>",  
"patient_dateofbirth":"<DATE>",  
"patient_diagnosis_short":"<DIAGNOSIS>",  
"mutation_load":"<LOAD>"  
}  

**Rendering report via docxtemplater tool.** The JSON output of the R script is rendered into a word template.

## Implementation
### Running the pipeline with Docker
System requirements: Docker Engine release 1.13.0+, Compose release 1.10.0+
All the images are publicly available on [Docker Hub](https://hub.docker.com/u/personalizedoncology/dashboard/)

To run the pipeline:

`git clone https://github.com/PersonalizedOncology/ClinicalReportingPipeline.git`
`cd ReportingApplication/`  
`docker-compose run --service-ports ClinicalReportR -t /inout -p jwp`  

*-t*: input file location (folder).  
*-p*: output format to save the results. 
 *j* to save report in JSON format
 *w* to save report in DOCX format
 *p* to save report in PDF format


Resulting files should be in the host volume, *./ReportingApplication/inout* under the *ClinicalReportingPipeline* directory. Please note that volumes are handled by docker compose file.

These three images are bind together by docker compose:
	Data deployment image: Transfer the files that are necessary to run Ensembl VEP offline
	Database image: Starts the MongoDB database and Rest API service to conduct driver gene and mechanistic drug target annotation
	Reporting image: Processes the input VCF file and outputs the report. Depends on the Data deployment image and the database image. 

### Running the pipeline with Singularity

On HPC research clusters, the usage of Docker containers is usually not permitted due to security considerations. For this reason, Clinical Reporting Pipeline
is also offered as a set of Singularity images.

System requirements: Singularity 
All the images are publicly available on Singularity Hub, https://www.singularity-hub.org/collections/1457

To run the pipeline:
	
1. Pull reporting image from Singularity Hub.  
`singularity pull -n reporting_app.img shub://sbilge/ClinicalReportingPipeline:report`
2. Pull dependency files image from Singularity Hub.   
`singularity pull -n file_deploy.img shub://sbilge/ClinicalReportingPipeline:filedeploy`
3. Run dependency files image first to transfer those file on your local folder. 
`singularity run -B /LOCAL/PATH/TO/FILES:/mnt file_deploy.img`
4. Run the reporting image to generate the clinical reports. 
`singularity run -B /LOCAL/PATH/TO/FILES:/data -B /PATH/TO/INPUT/DATA:/inout reporting_app.img -t /inout -p jwp`

### Software Availability

The source code for this software is open source and available on [https://github.com/PersonalizedOncology/ClinicalReportingPipeline](https://github.com/PersonalizedOncology/ClinicalReportingPipeline)

If you would like to contribute, you may   
1. open an issue on GitHub,
2. fork the repository, make changes and submit a pull request for us to review the changes and merge your contribution. 

Please contact us on sueruen@informatik.uni-tuebingen.de for further information/help. 

