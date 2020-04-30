## BUILD API

```
docker build -t redditorapi .
```

```
docker exec -it api_redditapi_1 /bin/bash
``

```
http://localhost:8000/find_posts?key=trump&limit=10
```


```
library(httr)
library(tidyverse)

response <- 
  GET(
    url = 'http://ndexr.com:8000/find_posts', 
    query = list(key = 'covid', limit = 100  )
  )
  
data <- fromJSON(content(response, 'text'))

data = as_tibble(fromJSON(data$data))
```
