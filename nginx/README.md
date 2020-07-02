
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
