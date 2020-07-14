from redditor.subreddits import get_subreddit
from redditor.connections import postgres_connector
from redditor.connections import reddit_connector
from redditor.plotting import plot_line_2d
import pandas as pd


# # Grab Some Reddit Data
reddit = reddit_connector()

subreddits = get_subreddit(reddit, 'politics',  10, 'hot')

conn = postgres_connector()

sql = "select date_trunc('minute', created_utc::timestamptz) as time_hour, count(*) as n_observations " \
      "from submissions " \
      "group by time_hour " \
      "order by time_hour;"

dat = pd.read_sql(sql, conn)\
    .sort_values(by=['time_hour'])

plot_line_2d(dat, x='time_hour', y='n_observations')


