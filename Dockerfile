FROM python:2.7.18-alpine3.11

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apk update && apk upgrade && \
    apk add --no-cache alpine-sdk git cmake make wget curl gcc

EXPOSE 8000

# MITIE
WORKDIR /opt
RUN git clone https://github.com/mit-nlp/MITIE

WORKDIR /opt/MITIE

COPY ./artifacts/MITIE-models-v0.2.tar.bz2 /opt/MITIE/
RUN tar -xjf MITIE-models-v0.2.tar.bz2

RUN mkdir /opt/MITIE/tools/ner_stream/build
WORKDIR /opt/MITIE/tools/ner_stream/build

RUN cmake ..
RUN cmake --build . --config Release

WORKDIR /opt/MITIE/mitielib
RUN make

RUN mkdir /opt/MITIE/mitielib/build
WORKDIR /opt/MITIE/mitielib/build

RUN cmake ..
RUN cmake --build . --config Release --target install

# mitie-trainer
RUN mkdir -p /opt/mitie-trainer /opt/mitie-trainer/log
WORKDIR /opt/mitie-trainer

COPY conf ./conf
COPY html ./html
COPY tools ./tools

COPY entrypoint.sh requirements.txt sample.tsv sample_walkthrough.sh ./

RUN python -m pip install -rrequirements.txt

#VOLUME ["/opt/mitie-trainer/html/data", "/opt/mitie-trainer/log"]

RUN chmod +x entrypoint.sh
HEALTHCHECK --interval=25s --timeout=5s --retries=10 \
  CMD curl --silent --fail localhost:8000/healthcheck || exit 1

ENTRYPOINT ["/opt/mitie-trainer/entrypoint.sh"]


