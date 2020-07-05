import praw
import os
import pandas as pd


def get_subreddit(con, subreddit, limit=100, sort_by="top"):
    location = con.subreddit(subreddit)

    if sort_by == 'hot':
        print("Grabbing {} values from r/{} and sorting by {}.".format(limit, subreddit, sort_by))
        returned_data = location.hot(limit=limit)
    elif sort_by == 'new':
        print("Grabbing {} values from r/{} and sorting by {}.".format(limit, subreddit, sort_by))
        returned_data = location.new(limit=limit)
    elif sort_by == 'top':
        print("Grabbing {} values from r/{} and sorting by {}.".format(limit, subreddit, sort_by))
        returned_data = location.top(limit=limit)
    elif sort_by == 'controversial':
        print("Grabbing {} values from r/{} and sorting by {}.".format(limit, subreddit, sort_by))
        returned_data = location.controversial(limit=limit)
    elif sort_by == 'rising':
        print("Grabbing {} values from r/{} and sorting by {}.".format(limit, subreddit, sort_by))
        returned_data = location.rising(limit=limit)
    else:
        print('Failed')

    placeholder = {"title": [],
                   "subreddit": [],
                   "score": [],
                   "id": [],
                   "url": [],
                   "number_of_comments": [],
                   "created": [],
                   "body": []}

    for submission in returned_data:
        placeholder["title"].append(submission.title)
        placeholder['subreddit'].append(submission.subreddit)
        placeholder["score"].append(submission.score)
        placeholder["id"].append(submission.id)
        placeholder["url"].append(submission.url)
        placeholder["number_of_comments"].append(submission.num_comments)
        placeholder["created"].append(submission.created)
        placeholder["body"].append(submission.selftext)

    return pd.DataFrame(placeholder)
