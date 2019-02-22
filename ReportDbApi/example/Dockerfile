FROM mongo

RUN apt-get update && apt-get -y upgrade

COPY annotated.json annotated.json
CMD mongoimport --host db \
	              --port 27017 \
	              --db report_db \
		            --collection patient_report \
		            --file annotated.json \
		            --drop && \
    rm annotated.json