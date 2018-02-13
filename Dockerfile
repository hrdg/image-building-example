FROM dockerhub.datacamp.com:443/msft-sql-base-prod:32
#ubuntu:16.04

#RUN useradd -m repl

ADD requirements.sh requirements.sh

RUN chmod u+x requirements.sh

RUN ./requirements.sh
