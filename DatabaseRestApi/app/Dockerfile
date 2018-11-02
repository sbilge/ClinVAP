FROM alpine:3.3
ENV TERM xterm

LABEL maintainer="sueruen@informatik.uni-tuebingen.de"

RUN apk add --update musl python3 nano py-pip bash ca-certificates
RUN pip install --upgrade pip
RUN rm /var/cache/apk/*

COPY ./requirements.txt /
RUN pip install -r requirements.txt

RUN mkdir /api
COPY  settings.py /api
COPY run.py /api

WORKDIR /api
RUN chmod +x run.py settings.py
CMD ["python", "run.py"]
EXPOSE 8000 5000 8080 9001
