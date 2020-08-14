import requests
from bs4 import BeautifulSoup
import requests
from github import Github
import re
import config
from misc.getlgtmdata import lgtm_contains_analysis
import time
import traceback as tb
g = Github("710179b0946569a104bd5c662dac854759bea3f5")

repo = "mscdex/ssh2"
page_num = 30
#url = 'https://github.com/{}/network/dependents?dependent_type=PACKAGE'.format(repo)
url = 'https://github.com/{}/network/dependents'.format(repo)
deps=dict()


#print(getDependents("mscdex/ssh2", func=lgtm_contains_analysis, max_pages=1000))
print(getDependents("sindresorhus/execa", func=lgtm_contains_analysis, max_pages=10000))

exit(0)
