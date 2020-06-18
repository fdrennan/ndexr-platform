import os
import urllib.request
import requests
import json

r = requests.get('http://ndexr.com/api/get_submission_files')
files = json.loads(json.loads(r.text)['data'])

for file in files:
    print(file)
    file_name = os.path.split(file)[1]
    print(file_name)
    urllib.request.urlretrieve(file, os.getcwd() + '/' + file_name)

