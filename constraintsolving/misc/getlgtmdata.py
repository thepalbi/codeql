import requests
import ast
import shutil
import traceback as tb
import time
import pandas as pd
from slugify import slugify
import os
LGTM_ACCESS_TOKEN="62a92b7d201c7def5c1ae347e254cc35345f8a24e7db0a19744b0d4d7193c5ad"
lgtm_session = requests.Session()

lgtm_session.headers.update({'authorization': 'bearer ' + LGTM_ACCESS_TOKEN})

def lgtm_contains_analysis(slug):
    try:
        project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + slug).json()
        assert 'id' in project_response
        #print(project_response)
    except:
        #tb.print_exc()
        #print("Not found")
        return False
    try:
        project_id = project_response['id']
        analyses_repsonse = lgtm_session.get(
            'https://lgtm.com/api/v1.0/analyses/{0}/commits/latest'.format(project_id)).json()
        # print(analyses_repsonse)
    except:
        # tb.print_exc()
        #print("analyses error")
        return False

    try:
        analysis_id = analyses_repsonse['id']
        analysis_response = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/{0}/alerts'.format(analysis_id)).json()
        print(analysis_id)
        for r in analysis_response['runs']:
            if r['properties']['semmle.sourceLanguage'] != 'javascript':
                continue
            for result in r['results']:
                if 'command' in result['ruleId']:
                    print(slug)
                    print(result)
                    return True
    except:
        tb.print_exc()
        print("analysis error")
        return False

    return False

def download_project(slug, dbdir):
    try:
        dbpath = "{0}/{1}.zip".format(dbdir, slugify(slug))
        if os.path.exists(dbpath):
            print("Exists already")
            return True
        project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + slug).json()
        project_id = project_response["id"]
        snapshot_response = lgtm_session.get('https://lgtm.com/api/v1.0/snapshots/{0}/javascript'.format(project_id), stream=True)
        if snapshot_response.status_code == 200:
            with open(dbpath, 'wb') as f:
                snapshot_response.raw.decode_content = True
                shutil.copyfileobj(snapshot_response.raw, f)
        else:
            print("Not Found! ", slug)
            return False
    except:
        tb.print_exc()
        print("Not Found")
        return False
    return True

if __name__ == '__main__':
    f = open("misc/data/lgtm-ssh-deps.txt").readlines()
    f = [k for k in f if not k.startswith("{")]
    print(k)
    # df=pd.read_csv("misc/data/lgtm-ssh-deps.txt")
    # keys=list(df.index)
    # sorted_keys = sorted(keys, key=lambda x:df.loc[x]['stars'], reverse=True)

    # c=0
    # for k in sorted_keys:
    #     if df.loc[k]['dependent_repos_count'] > 0:
    #         print(df.loc[k]['name'], df.loc[k]['stars'], df.loc[k]['repository_url'])
    #         result=download_project("/".join(df.loc[k]['repository_url'].split("/")[-2:]), "databases/projects/CommandInjection")
    #         if result:
    #             print("Downloaded: %s" % df.loc[k]['name'])
    #             c+=1
    #     if c == 70:
    #         break
    # exit(0)
    download_project("chalk/chalk", "databases/projects/CommandInjection")
    exit(0)
    #project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + "deepkit/deepkit").json()
    #project_response = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/1511641246649/commits/latest').json()
    #project_response = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/1e752776f86d67ffb7a43ae206fadca05ce00977/alerts').json()
    #print(project_response)
    projects = open("data/mongodb_ghub.txt").readlines()
    done=list()
    done = done + projects[:500]
    for p in projects[500:]:
        slug=p.split(" ")[0]
        print(slug)
        if slug in done:
            print('skipping')
            continue
        else:
            done.append(slug)
        try:
            project_response = lgtm_session.get('https://lgtm.com/api/v1.0/projects/g/' + slug).json()
            assert 'id' in project_response
            #print(project_response)
        except:
            #tb.print_exc()
            print("Not found")
            continue
        try:
            project_id = project_response['id']
            print(project_id)
            analyses_repsonse = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/{0}/commits/latest'.format(project_id)).json()
            #print(analyses_repsonse)
        except:
            #tb.print_exc()
            print("analyses error")
            continue

        try:
            analysis_id = analyses_repsonse['id']
            print(analysis_id)
            analysis_response = lgtm_session.get('https://lgtm.com/api/v1.0/analyses/{0}/alerts'.format(analysis_id)).json()
            #print(analysis_response)
            for r in analysis_response['runs']:
                if r['properties']['semmle.sourceLanguage'] != 'javascript':
                    continue
                for result in r['results']:
                    if 'sql' in result['ruleId']:
                        print(result)
        except:
            tb.print_exc()
            print("analysis error")

        time.sleep(2)

