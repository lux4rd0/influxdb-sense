FROM debian:9.9

RUN apt-get update && \
    apt-get -y install jq bc curl && \
    rm -r /var/lib/apt/lists/*

COPY websocat_amd64-linux-static /websocat
COPY influxdb_sense.sh /
COPY stream_sense.sh /

RUN chmod 755 /influxdb_sense.sh
RUN chmod 755 /stream_sense.sh

CMD ["bash", "/stream_sense.sh"]
