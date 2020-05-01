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



```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker volume prune
```