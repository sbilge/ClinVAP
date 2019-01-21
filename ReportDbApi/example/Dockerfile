FROM mongo

RUN apt-get update && apt-get -y upgrade

COPY annotated.json annotated.json
CMD mongoimport --host db \
		        --port 27017 \
		        --db clinical_reporting \
				--collection reports \
				--file annotated.json \
				--drop && \
				rm annotated.json
