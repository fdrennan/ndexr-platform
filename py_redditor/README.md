# Setup
1. Fork the fdrennan/ndexr-platform repo to your Github account 
2. Click `New` -> `Terminal` in JupyterLab

3. Run in your terminal
```.env
cd ~
git clone https://github.com/USERNAME/ndexr-platform.git
cd ndexr-platform/py_redditor/
conda init
```

4. Exit out of the prior terminal and then run 
```
cd ~
cd ndexr-platform/py_redditor/
conda create --name YOUR_ENV_NAME python=3.8 -y
source activate YOUR_ENV_NAME
conda config --add channels conda-forge
conda install --file ndexr-platform/py_redditor/requirements.txt -y
/home/YOUR_USER_NAME/.conda/envs/YOUR_ENV_NAME/bin/python -m nb_conda_kernels.install -v --enable
python -m ipykernel install --user --name=YOUR_ENV_NAME

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

