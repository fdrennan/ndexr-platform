import os
import praw
import psycopg2
from dotenv import load_dotenv
load_dotenv(verbose=True)

def postgres_connector(POSTGRES_HOST=os.getenv("POSTGRES_HOST"),
                       POSTGRES_DB=os.getenv("POSTGRES_DB"),
                       POSTGRES_USER=os.getenv("POSTGRES_USER"),
                       POSTGRES_PASSWORD=os.getenv("POSTGRES_PASSWORD"),
                       POSTGRES_PORT=os.getenv("POSTGRES_PORT")):

    print(f'Attempting connection to: {POSTGRES_HOST}:{POSTGRES_PORT} {POSTGRES_DB}')

    conn = psycopg2.connect(host=POSTGRES_HOST,
                            database=POSTGRES_DB,
                            user=POSTGRES_USER,
                            password=POSTGRES_PASSWORD,
                            port=POSTGRES_PORT)

    return(conn)


def reddit_connector(REDDIT_CLIENT=os.getenv("REDDIT_CLIENT"),
                     REDDIT_AUTH=os.getenv("REDDIT_AUTH"),
                     USER_AGENT=os.getenv("USER_AGENT")):

    print(f'Attempting connection Reddit: {USER_AGENT}')

    reddit = praw.Reddit(client_id=REDDIT_CLIENT,
                         client_secret=REDDIT_AUTH,
                         user_agent=USER_AGENT)

    return(reddit)