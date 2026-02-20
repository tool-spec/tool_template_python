# Build gotap from source, then discard Go
FROM golang:1.25-alpine AS gotap-builder
RUN apk add --no-cache git
ARG GOTAP_VERSION=main
RUN git clone --depth 1 --branch ${GOTAP_VERSION} https://github.com/tool-spec/gotap.git /gotap && \
    cd /gotap && go build -o gotap .

# Pull any base image that includes python3
FROM python:3.12
COPY --from=gotap-builder /gotap/gotap /usr/local/bin/gotap
RUN chmod +x /usr/local/bin/gotap

# Do anything you need to install tool dependencies here
RUN echo "Replace this line with a tool"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

# Generate parameter bindings from tool.yml at build time (replaces json2args)
WORKDIR /src
RUN gotap generate --spec-file=tool.yml --target=python --output=parameters.py

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
