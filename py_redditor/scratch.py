from redditor.subreddits import get_subreddit
from dotenv import load_dotenv
import praw
import os
import psycopg2
import pandas as pd
import plotly.express as px

load_dotenv(verbose=True)

# Grab Some Reddit Data
reddit = praw.Reddit(client_id=os.getenv("REDDIT_CLIENT"),
                     client_secret=os.getenv("REDDIT_AUTH"),
                     user_agent=os.getenv("USER_AGENT"))

subreddits = get_subreddit(reddit, 'politics',  10, 'hot')

print(subreddits)

# Create a connection
conn = psycopg2.connect(host=os.getenv("POSTGRES_HOST"),
                        database=os.getenv("POSTGRES_DB"),
                        user=os.getenv("POSTGRES_USER"),
                        password=os.getenv("POSTGRES_PASSWORD"))

sql = "select date_trunc('hour', created_utc::timestamptz) as time_hour, count(*) as n_observations " \
      "from submissions " \
      "where lower(selftext) like '%wayfair%'" \
      "order by time_hour;"

dat = pd.read_sql(sql, conn)\
    .sort_values(by=['time_hour'])

fig = px.line(dat, x='time_hour', y='n_observations')
fig.show()