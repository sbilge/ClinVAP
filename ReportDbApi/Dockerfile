FROM python:3.6-stretch

RUN apt-get update && apt-get -y upgrade 
RUN pip install --upgrade pip 
RUN pip install eve
RUN mkdir /api
COPY run.py /api
COPY settings.py /api
COPY schema /api/schema

WORKDIR /api
RUN chmod +x run.py 
CMD ["python", "run.py"]
