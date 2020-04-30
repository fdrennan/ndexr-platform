-- Build the R API
```
docker build -t redditorapi --file ./DockerfileApi .
docker build -t rpy --file ./DockerfileRpy .
docker build -t redditorui --file ./DockerfileUi .
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




docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker volume prune