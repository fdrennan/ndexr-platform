# Run Airflow Locally

### Background

Apache Airflow is the leading orchestration tool for batch workloads. Originally conceived at Facebook and eventually open-sourced at AirBnB, Airflow allows you to define complex directed acyclic graphs (DAG) by writing simple Python. 

Airflow has a number of built-in concepts that make data engineering simple, including DAGs (which describe how to run a workflow) and Operators (which describe what actually gets done). See the Airflow documentation for more detail: https://airflow.apache.org/concepts.html 

Airflow also comes with its own microservice architecture: a database to persist the state of DAGs and connections, a web server that supports the user-interface, and workers that are managed together by the scheduler and database. Logs persist both in flat files and the database, and Airflow can be setup to write remote logs (to S3 for example). Logs are viewable in the UI.

![Airflow Architecture](docs/airflow_architecture.png)

### Getting Started

DAGs should be developed & tested locally first, before being promoted to a development environment for integration testing. Once DAGs are successful in the lower environments, they can be promoted to production. 

Code is contributed either in `dags`, a directory that houses all Airflow DAG configuration files, or `plugins`, a directory that houses Python objects that can be used within a DAG. Essentially, if you want to abstract something out for reuse in other pipelines, it should probably go in `plugins`. 


#### Running Airflow locally

1) Create a virtual environment and:
   
   a) `pip install --no-deps -r airflow.requirements.txt`

2) Generate a Fernet key using the below code snippet:

        # Airflow uses Fernet keys to encrypt connection information in the metadata database.
        # As long as you set a consistent Fernet key, your sensitive information will be saved properly!
        # This means you can store & reuse sensitive connection information in your local Postgres container!

        from cryptography.fernet import Fernet
        fernet_key= Fernet.generate_key()
        print(fernet_key.decode()) # your fernet_key, keep it in secured place!

3) Set the `AIRFLOW__CORE__FERNET_KEY` envrionment variable in `.env` using the key generated in step 2. 
5) Start the Airflow database. This ensures Postgres is ready for any database migrations.

        docker-compose up -d --build postgres

6) Build the docker container
   - `docker build -t rpy .`
7) Start Airflow! 
   - if this is your **first time** standing up Airflow:

                # you need to run the initdb container so the Airflow schema can be created in the database
                docker-compose up -d --build initdb

                # now you can start Airflow
                docker-compose up 

   - if you've built Airflow before and already have volumes for the database:

                docker-compose up

8) Navigate to http://localhost:8080/ and start writing & testing your DAGs!

You'll notice in `docker-compose.yaml` that both DAGs and plugins are mounted as volumes. This means once Airflow is started, any changes to your code will be quickly synced to the webserver and scheduler. You shouldn't have to restart the Airflow instance during a period of development! 


`docker-compose up -d` runs the Airflow UI, which is located at `localhost:8080`

```
version: '3.4'
services:
  webserver:
    image: rpy
    restart: always
    depends_on:
      - initdb
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@172.17.0.1:5439/airflow
    volumes:
      - ./airflower/dags:/root/airflow/dags
      - ./airflower/plugins:/root/airflow/plugins
      - airflow-worker-logs:/root/airflow/logs
    ports:
      - "8080:8080"
    command: airflow webserver
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
  initdb:
    image: rpy
    restart: always
    depends_on:
      - postgres
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@172.17.0.1:5439/airflow
    command: airflow initdb
  scheduler:
    image: rpy
    restart: always
    depends_on:
      - webserver
    env_file: .env
    environment:
      AIRFLOW_HOME: /root/airflow
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@172.17.0.1:5439/airflow
    volumes:
      - ./airflower/dags:/root/airflow/dags
      - ./airflower/scripts:/home/scripts
      - ./airflower/plugins:/root/airflow/plugins
      - ./.env:/root/.Renviron
      - airflow-worker-logs:/root/airflow/logs
      - ./data:/data
    command: airflow scheduler
  db:
    image: postgres
    container_name: "redditor_postgres"
    restart: always
    ports:
      - '5432:5432'
    expose:
      - '22'
      # Opens port 5432 on the container
      - '5432'
      # Where our data will be persisted
    volumes:
      - redditor_volume:/var/lib/postgresql/data
      - ./data:/data
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}

volumes:
  postgres: {}
  redditor_volume: {}
  airflow-worker-logs:

```