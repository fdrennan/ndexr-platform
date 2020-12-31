
rpy:
	docker build -t rpy --file ./DockerfileRpy .

init:
	docker-compose --file ./airflow/airflower/docker-compose.yaml --build postgres --force-recreate up -d
	docker-compose up -d --file ./airflow/airflower/docker-compose.yaml --build initdb --force-recreate

stop:
	docker-compose  --file ./airflow/airflower/docker-compose.yaml down

where:
	pwd

restart:
	echo "cd airflow"
	echo "docker-compose --file ./airflow/docker-compose.yaml up --build initdb"
	echo "docker-compose --file ./airflow/docker-compose.yaml up --build postgres"

postgres_stop:
	service postgresql stop

postgres_start:
	service postgresql startp