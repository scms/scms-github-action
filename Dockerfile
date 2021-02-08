# Container image that runs your code
FROM adoptopenjdk/openjdk15-openj9:alpine-slim

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY populate_scc.sh /populate_scc.sh
COPY sccinput /tmp/sccinput

RUN     mkdir -p /opt \
        && mkdir -p /tmp/sccoutput \
        && wget -q "https://github.com/scms/scms/releases/download/v0.4.0/scms-0.4.0.zip" -O /opt/scms-0.4.0.zip \
        && cd /opt \
        && unzip /opt/scms-0.4.0.zip \
        && mv /opt/scms-0.4.0 /opt/scms \
        && chmod u+x /opt/scms/bin/scms /entrypoint.sh /populate_scc.sh

RUN     /populate_scc.sh \
        && rm -rf /tmp/sccinput /tmp/sccoutput

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
