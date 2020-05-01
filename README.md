This application is for the gathering, storage, and display of Reddit data. 
I love large structures - behemoth applications which include a lot of moving parties. 

This is one of them.

## A History 

A little bit of history. I worked at a company called Digital First Media. I was hired on as a data optimization engineer. 
The job was primary working on their optimization code for online marketing campaigns. As the guy in-between, I worked
with highly qualified data engineers on one side of me and extremely competent web developers on the other side.
 
[Duffy](https://github.com/duffn) was definitely one of the talented ones, who taught me quite a bit. While I was there, 
one of my complaints was related to how much we were spending for tools we could easily make in house. Of of those choices, 
was whether to buy RSConnect or not. I found a way to build highly scalable R APIs using docker-compose and NGINX. Duffy 
was the guy who knew what was needed for a solution, so he gave me quite a bit of guidance in infrastructure. 

So that's where I learned about building really cool APIs. Well, there are people who consume APIs, and Duffy was doing 
cool stuff in Data Engineering. So, I gravitated a bit out of the math into the tools Data Engineers used, and became interested 
in Python, SQL, Airflow etc. These guys spin that stuff daily, and so it's not impossible to learn! I started creating data 
pipelines, which grew - and became difficult to maintain. I wanted to learn best practices in data engineering - because when things 
break, it's devastating and a time sink and kept me up nights.  

AIRFLOW, is one of the tools for this job. It makes your scheduled jobs smooth like butter, and is highly transparent with 
the health of your network, and allows for push button runs of your code. This was far superior to cron.

Well, I learned data engineering stuff and wanted to learn React/Javascript. This is the most recent venture, and I'm still learning. 
                                                                                                                          
                                                                                                                          
## About This Project

There are three dockerfiles that are needed: `DockerfileApi`, `DockerfileRpy`, and `DockerfileUi`

`DockerfileApi` is associated with the container needed to run an R [Plumber](https://www.rplumber.io/) API. 
In the container I take from [trestletech](https://hub.docker.com/r/trestletech/plumber/), I add on some additional 
Linux binaries and R packages. There are two R packages in this project. One is called [biggr] and the other is called [redditor],
which are located in `./bigger` and `./redditor-api` respectively. To build the container, run the following:

```
docker build -t redditorapi --file ./DockerfileApi .
```

`DockerfileRpy` is a container running both R and Python, This is taken from the `python:3.7.6` container. I install R on top of it, so 
I can run scheduled jobs. This container runs Airflow, which is set up in `airflower`. Original name, right? 

```
docker build -t rpy --file ./DockerfileRpy .
```

This container contains node, npm, and everything else needed to run the site. The site is a React application using Material UI.
The project is located at `redditor-ui`

```
docker build -t redditorui --file ./DockerfileUi .
```

All of the above gets our containers ready for use. But there's a to unpack in this docker-compose file.

### LOTS OF SERVICES

```
services:
```

The first is the web server. This hosts NGINX, which is being used as a load balancer and reverse proxy. A load 
balancer takes incoming traffic, and routes that traffic to multiple different locations, Say you clone an API, as I
do in the project. You can then do the same or different tasks simultaneously. If there is one API, then each process 
has to 'wait in line' until the one ahead of it is done. 

So, you arrive to `localhost/api` and it routes you to either port 8000 or 8001, where the R apis live.
If you arrive to `localhost/airflowr` then you'll see airflow running. How this is done is in `nginx.conf` and the web
service + `nginx.conf` file can be used alone for services requiring the same types of configuration.

```
  web:
    image: nginx
    volumes:
     - ./nginx.conf:/etc/nginx/conf.d/mysite.template
    ports:
     - "80:80"
    environment:
     - NGINX_HOST=host.docker.internal
     - NGINX_PORT=80
    command: /bin/bash -c "envsubst < /etc/nginx/conf.d/mysite.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"
```

```
  webserver:
    image: rpy
    restart: always
    depends_on:
      - initdb
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@host.docker.internal:5439/airflow
    volumes:
      - ./airflower/dags:/root/airflow/dags
      - ./airflower/plugins:/root/airflow/plugins
      - airflow-worker-logs:/root/airflow/logs
    ports:
      - "8080:8080"
    command: airflow webserver
  mongo_db:
    image: 'mongo'
    container_name: 'ndexr_mongo'
    restart: always
    ports:
      - '27017:27017'
    expose:
      - '27017'
    volumes:
      - ./init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js:ro
      - mongodbdata:/data/db
    environment:
      - MONGO_INITDB_DATABASE=${MONGO_INITDB_DATABASE}
      - MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME}
      - MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD}
  postgres:
    image: postgres:9.6
    restart: always
    environment:
      - POSTGRES_USER=${AIRFLOW_USER}
      - POSTGRES_PASSWORD=${AIRFLOW_PASSWORD}
      - POSTGRES_DB=${AIRFLOW_DB}
    ports:
      - 5439:5432
    volumes:
      - postgres:/var/lib/postgresql/data
      - ./data/postgres.bak:/postgres.bak
  initdb:
    image: rpy
    restart: always
    depends_on:
      - postgres
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@host.docker.internal:5439/airflow
    command: airflow initdb
  userinterface:
    image: redditorui
    restart: always
    volumes:
      - ./.env:/usr/src/app/.env
      - ./redditor-ui/public:/usr/src/app/public
      - ./redditor-ui/src:/usr/src/app/src
    environment:
      REACT_APP_HOST: 127.0.0.1
    ports:
      - "3000:3000"
    links:
      - "web:redditapi"
  scheduler:
    image: rpy
    restart: always
    depends_on:
      - webserver
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@host.docker.internal:5439/airflow
    volumes:
      - ./airflower/dags:/root/airflow/dags
      - ./airflower/scripts/sql:/home/scripts/sql
      - ./airflower/scripts/R/r_files/aws_configure.R:/home/scripts/R/r_files/aws_configure.R
      - ./airflower/scripts/R/r_files/r_venv_install.R:/home/scripts/R/r_files/r_venv_install.R
      - ./airflower/scripts/R/r_files/refresh_mat_comments_by_second.R:/home/scripts/R/r_files/refresh_mat_comments_by_second.R
      - ./airflower/scripts/R/r_files/refresh_mat_stream_authors.R:/home/scripts/R/r_files/refresh_mat_stream_authors.R
      - ./airflower/scripts/R/r_files/refresh_mat_submissions_by_second.R:/home/scripts/R/r_files/refresh_mat_submissions_by_second.R
      - ./airflower/scripts/R/r_files/stream_submissions_to_s3.R:/home/scripts/R/r_files/stream_submissions_to_s3.R
      - ./airflower/scripts/R/r_files/streamall.R:/home/scripts/R/r_files/streamall.R
      - ./airflower/scripts/R/r_files/streamsubmissions.R:/home/scripts/R/r_files/streamsubmissions.R
      - ./airflower/scripts/R/r_files/streamtos3.R:/home/scripts/R/r_files/streamtos3.R
      - ./airflower/scripts/R/shell/aws_configure:/home/scripts/R/shell/aws_configure
      - ./airflower/scripts/R/shell/refresh_mat_comments_by_second:/home/scripts/R/shell/refresh_mat_comments_by_second
      - ./airflower/scripts/R/shell/refresh_mat_submissions_by_second:/home/scripts/R/shell/refresh_mat_submissions_by_second
      - ./airflower/scripts/R/shell/stream_submissions_all:/home/scripts/R/shell/stream_submissions_all
      - ./airflower/scripts/R/shell/streamtos3:/home/scripts/R/shell/streamtos3
      - ./airflower/scripts/R/shell/r_venv_install:/home/scripts/R/shell/r_venv_install
      - ./airflower/scripts/R/shell/refresh_mat_stream_authors:/home/scripts/R/shell/refresh_mat_stream_authors
      - ./airflower/scripts/R/shell/stream_submission_to_s3:/home/scripts/R/shell/stream_submission_to_s3
      - ./airflower/scripts/R/shell/streamall:/home/scripts/R/shell/streamall
      - ./airflower/plugins:/root/airflow/plugins
      - ./.env:/home/scripts/R/r_files/.Renviron
      - airflow-worker-logs:/root/airflow/logs
    links:
      - "postgres"
    command: airflow scheduler
  redditapi:
    image: redditorapi
    command: /app/plumber.R
    restart: always
    ports:
     - "8000:8000"
    working_dir: /app
    volumes:
      - ./plumber.R:/app/plumber.R
      - ./.env:/app/.Renviron
    links:
      - "postgres"
  redditapitwo:
    image: redditorapi
    command: /app/plumber.R
    restart: always
    ports:
     - "8001:8000"
    working_dir: /app
    volumes:
      - ./plumber.R:/app/plumber.R
      - ./.env:/app/.Renviron
    links:
      - "postgres"

volumes:
  mongodbdata:
  postgres: {}
  airflow-worker-logs:
```

```
docker-compose up -d --build postgres
docker-compose up -d --build initdb
```

```
docker exec -it  redditor_scheduler_1  /bin/bash
docker exec -it  redditor_postgres_1  /bin/bash
docker exec -it  redditor_userinterface_1  /bin/bash
```
```
psql -U airflow postgres < postgres.bak
```

```
scp -i "~/ndexr.pem" ubuntu@ndexr.com:/var/lib/postgresql/postgres/backups/postgres.bak postgres.bak
docker exec redditor_postgres_1 pg_restore -U airflow -d postgres /postgres.bak
```



```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker volume prune
```