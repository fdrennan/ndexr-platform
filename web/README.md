
Two R APIS that are exactly the same except for the port location. These are load balanced by the `web` container and the `nginx.conf` file.

Again the `- filelocationlocal:filelocationcontainer` syntax explains how this project is connected.

```
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
```