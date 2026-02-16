# Pull any base image that includes python3
FROM python:3.12

# install the toolbox runner tools
RUN pip install "json2args[data]>=0.6.2"

# if you do not need data-preloading as your tool does that on its own
# you can use this instread of the line above to use a json2args version
# with less dependencies
# RUN pip install json2args>=0.6.2

# Build spec binary from source
RUN apt-get update && apt-get install -y golang-go git && \
    git clone https://github.com/hydrocode-de/gotap.git /tmp/gotap && \
    cd /tmp/gotap && go build -o /usr/local/bin/spec ./main.go && \
    rm -rf /tmp/gotap && \
    apt-get remove -y golang-go git && apt-get autoremove -y && apt-get clean

# Do anything you need to install tool dependencies here
RUN echo "Replace this line with a tool"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src
CMD ["spec", "run", "foobar", "--input-file", "/in/input.json"]
