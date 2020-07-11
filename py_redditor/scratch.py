from redditor.subreddits import get_subreddit
from dotenv import load_dotenv
import praw
import os

load_dotenv(verbose=True)

reddit = praw.Reddit(client_id=os.getenv("REDDIT_CLIENT"),
                     client_secret=os.getenv("REDDIT_AUTH"),
                     user_agent=os.getenv("USER_AGENT"))

subreddits = get_subreddit(reddit, 'politics',  10, 'hot')