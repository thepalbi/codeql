import os
import traceback as tb
import time
import requests
import re
from slugify import slugify
import shutil
import argparse
from bs4 import BeautifulSoup
from misc.tokens import tokens
os.environ["LIBRARIES_API_KEY"]=tokens["LIBRARIES_API_KEY"]
from pybraries.search import Search
from pybraries import fix_pages
import json

def download_project(slug, dbdir):
    try:
        LGTM_ACCESS_TOKEN = tokens["lgtm"]
        lgtm_session = requests.Session()
        lgtm_session.headers.update({'authorization': 'bearer ' + LGTM_ACCESS_TOKEN})
        dbpath = "{0}/{1}.zip".format(dbdir, slugify(slug))
        print(dbpath)
        if os.path.exists(dbpath):
            print("Exists already")
            return True
        project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + slug).json()
        project_id = project_response["id"]
        snapshot_response = lgtm_session.get('https://lgtm.com/api/v1.0/snapshots/{0}/javascript'.format(project_id), stream=True)
        if snapshot_response.status_code == 200:
            print("Downloading project from lgtm: {0}".format(slug))
            with open(dbpath, 'wb') as f:
                snapshot_response.raw.decode_content = True
                shutil.copyfileobj(snapshot_response.raw, f)
            print("Downloaded to path: {0}".format(dbpath))
        else:
            print("Not Found! ", slug)
            return False
    except:
        tb.print_exc()
        print("Not Found")
        return False
    return True


def topicSearch(topic, stars):
    search_url = 'https://api.github.com/search/repositories?q={}+language:js+language:ts+fork:true+stars:%3E%3D{}&sort=stars&per_page=100'.format(topic, stars)

    while search_url is not None:
        r = requests.get(search_url, auth=tokens["github"])
        for res in r.json()['items']:
            print(res)
        search_url = None
        if 'Link' in r.headers:
            search_url = re.search('<([^>]*)>; rel="next"', r.headers['Link'])

def keywordSearch(keyword, repo, outputfilepath):
    keyword_search_url = 'https://api.github.com/search/code?q={1}+language:js+language:ts+repo:{0}+in:file'.format(
        repo, keyword)
    headers = {"Accept": "application/vnd.github.v3.text-match+json", "Authorization": "token " + tokens["githubv4"][1]}
    with open(outputfilepath, "w") as outputfile:
        outputfile.write("[\n")
        while keyword_search_url is not None:
            r = requests.get(keyword_search_url, headers=headers)
            if r.status_code != 200:
                print(r.content)
                print(r.headers)
                os.remove(outputfilepath)
                exit(1)
            for res in r.json()["items"]:
                outputfile.write(json.dumps(res, indent=2))
                outputfile.write(",\n")
            keyword_search_url = None
            if 'Link' in r.headers:
                keyword_search_url = re.search('<([^>]*)>; rel="next"', r.headers['Link'])
            time.sleep(10)
        outputfile.write("\n]")

def getText(t):
    try:
        return "{}/{}".format(
        t.find('a', {"data-repository-hovercards-enabled": ""}).text,
        t.find('a', {"data-hovercard-type": "repository"}).text
    )
    except:
        return ""


def getDependents(reponame, getPackages=False, max_pages=1, func=None):
    pages = 0
    dependents_url = 'https://github.com/{}/network/dependents'.format(reponame)
    if getPackages:
        dependents_url = dependents_url + "?dependent_type=PACKAGE"
    allrepos = []
    while pages < max_pages:
        print("..", end='')
        r = requests.get(dependents_url, auth=("saikatg", "710179b0946569a104bd5c662dac854759bea3f5"))

        soup = BeautifulSoup(r.content, "html.parser")
        data = list(filter(lambda x: len(x) > 0, [getText(t) for t in soup.findAll("div", {"class": "Box-row"})]))
        if func is not None:
            for d in data:
                if d not in allrepos:
                    func(d)
                allrepos.append(d)
        else:
            allrepos = allrepos + data
        pages+=1
        try:
            dependents_url = soup.find("div", {"class": "paginate-container"}).findAll('a')[-1]["href"]
            assert "dependents_after" in dependents_url
        except:
            #tb.print_exc()
            break
        time.sleep(1)
    print()
    return list(set(allrepos))


def search_package(package_name, platform, max_pages=100000):
    search = Search()
    with open("misc/data/{0}.txt".format(package_name)) as datafile:
        for r in range(max_pages):
            try:
                print("Page %d" % r)
                fix_pages(r, 100)
                info = search.project_dependents(platforms=platform, project=package_name)
                for i in info:
                    datafile.write(str(i))
                    datafile.write(",\n")
                time.sleep(1)
            except:
                tb.print_exc()
                break
        datafile.write("\n]")


def lgtm_contains_analysis(slug, qtype):
    LGTM_ACCESS_TOKEN = "62a92b7d201c7def5c1ae347e254cc35345f8a24e7db0a19744b0d4d7193c5ad"
    lgtm_session = requests.Session()
    lgtm_session.headers.update({'authorization': 'bearer ' + LGTM_ACCESS_TOKEN})
    try:
        project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + slug).json()
        assert 'id' in project_response
    except:
        return False
    try:
        project_id = project_response['id']
        analyses_repsonse = lgtm_session.get(
            'https://lgtm.com/api/v1.0/analyses/{0}/commits/latest'.format(project_id)).json()
        # print(analyses_repsonse)
    except:
        return False

    try:
        analysis_id = analyses_repsonse['id']
        analysis_response = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/{0}/alerts'.format(analysis_id)).json()
        #print(analysis_id)
        for r in analysis_response['runs']:
            if r['properties']['semmle.sourceLanguage'] != 'javascript':
                continue
            for result in r['results']:
                if qtype in result['ruleId']:
                    print(slug)
                    print(result)
                    return True
    except:
        tb.print_exc()
        print("analysis error")
        return False

    return False


def keywordSearchInDeps(keywordfile):
    repos=open(keywordfile).readlines()
    for r in repos:
        if len(r.split(",")[1].strip()) > 0:
            reponame=r.split(",")[0].strip()
            keyword=r.split(",")[1].strip()
            print("Repo: %s, Keyword: %s" % (reponame,keyword))
            depfilename="misc/data/keyword/{0}_deps.txt".format(slugify(reponame))
            if os.path.exists(depfilename):
                dependents=open(depfilename).readlines()
            else:
                dependents=getDependents(reponame, max_pages=100)
                with open("misc/data/keyword/{0}_deps.txt".format(slugify(reponame)), "w") as outfile:
                    for d in dependents:
                        outfile.write(d)
                        outfile.write("\n")

            print("Dependents %d" % len(dependents))

            for dep in dependents:
                print("Searching for keyword in %s " % dep)
                if not os.path.exists('misc/data/keyword/{0}.json'.format(slugify(dep))):
                    keywordSearch(keyword, dep, 'misc/data/keyword/{0}.json'.format(slugify(dep)))
                    time.sleep(15)
        else:
            print("ignoring %s" % r)

def get_args():
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument("-search", dest="search")
    arg_parser.add_argument("-dep_search", dest="dep_search")
    arg_parser.add_argument("-dep", dest="get_dependents")
    arg_parser.add_argument("-dld", dest="download")
    arg_parser.add_argument("-p", dest="platform", choices=["github", "npm"])
    arg_parser.add_argument("-t", dest="dependent_type", choices=["project", "package"])
    arg_parser.add_argument("-l", dest="lgtm_analysis")
    arg_parser.add_argument("-o", dest="output")

    args = arg_parser.parse_args()
    return args


# python3 .\misc\scrape.py -dep "mscdex/ssh2" -p github -t package -l command -o misc\data\ttt.txt
args = get_args()
if args.get_dependents is not None:
    repos = getDependents(args.get_dependents,
                  args.dependent_type == "package",
                  max_pages=100000,
                  func=lambda x: lgtm_contains_analysis(x, args.lgtm_analysis)
                  if args.lgtm_analysis is not None else None)
    if args.output is not None:
        with open(args.output, "w") as outputfile:
            for r in repos:
                outputfile.write(r)
                outputfile.write("\n")
elif args.search is not None:
    keywordSearch("exec", args.search, args.output)
elif args.dep_search is not None:
    keywordSearchInDeps(args.dep_search)
elif args.download is not None:
    download_project(args.download, args.output)