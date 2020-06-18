FROM postgres:latest

# install Python 3
RUN apt-get update && apt-get install -y python3 python3-pip
RUN apt-get -y install python3.7-dev
RUN apt-get -y install postgresql-server-dev-10 gcc python3-dev musl-dev
RUN pip3 install psycopg2