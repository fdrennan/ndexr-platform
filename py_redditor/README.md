
## Install
[Notes](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
conda config --append channels conda-forge

``` 
conda update -n base -c defaults conda
conda create --name pyredditor
conda install -c praw
conda install -c conda-forge python-dotenv
conda install --file requirements.txt
```

```
conda activate pyredditor
```

Getting Started
```
from redditor.subreddits import get_subreddit
from redditor.connections import postgres_connector
from redditor.connections import reddit_connector
from redditor.plotting import plot_line_2d
import pandas as pd


## Default environment variables, can be supplied as args as well
# REDDIT_CLIENT
# REDDIT_AUTH
# USER_AGENT
reddit = reddit_connector()

## Default environment variables, can be supplied as args as well
# POSTGRES_USER
# POSTGRES_PASSWORD
# POSTGRES_DB
# POSTGRES_HOST
# POSTGRES_PORT
conn = postgres_connector()

subreddits = get_subreddit(reddit, 'politics',  10, 'hot')

sql = "select date_trunc('minute', created_utc::timestamptz) as time_hour, count(*) as n_observations " \
      "from submissions " \
      "group by time_hour " \
      "order by time_hour;"

dat = pd.read_sql(sql, conn)\
    .sort_values(by=['time_hour'])

plot_line_2d(dat, x='time_hour', y='n_observations')
```






# Setup
1. Fork the fdrennan/ndexr-platform repo to your Github account
2. Run git clone https://github.com/USERNAME/ndexr-platform.git
3. Click `New` -> `Terminal` in JupyterLab




conda init
conda create --name tester python=3.8
source activate tester
conda install -n tester ipykernel nb_conda_kernels
conda install -c conda-forge praw 
/home/pchhabria/.conda/envs/tester/bin/python -m nb_conda_kernels.install -v --enable
python -m ipykernel install --user --name=tester