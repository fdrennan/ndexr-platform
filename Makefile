
rpy:
	docker build -t rpy --file ./DockerfileRpy .

init:
	docker-compose up -d --file ./airflow/airflower/docker-compose.yaml --build postgres
	docker-compose up -d --file ./airflow/airflower/docker-compose.yaml --build initdb

stop:
	docker-compose  --file ./airflow/airflower/docker-compose.yaml downS

restart: init
	docker-compose down --file ./airflow/airflower/docker-compose.yaml
	docker-compose up -d --file ./airflow/airflower/docker-compose.yaml

postgres_stop:
	service postgresql stop

postgres_start:
	service postgresql startp