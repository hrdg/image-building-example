FROM dockerhub.datacamp.com:443/shell-base-prod:22
#ubuntu:16.04

#RUN useradd -m repl

ADD requirements.sh requirements.sh

RUN chmod u+x requirements.sh

RUN ./requirements.sh
