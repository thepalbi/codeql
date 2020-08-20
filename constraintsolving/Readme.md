### Installing dependencies

`python3 -m pip install -r requirements.txt`

Then try `python3 -m pip gurobipy`.  In OSX you may need to install `girubi` support for python manualy  executing this command: 
`python3 /Library/gurobiXXX/mac64/setup.py install` where `XXX` is the version installed in your computer.


### Downloading databases from LGTM

The files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` contains each one a 
a list of datatabases to be fetched from the LGTM site.  

Run `python3 -m misc.scrape -dld [project-slug] -o [outputdirectory]` where 
`project-slug` is one database listed in the three aforementioned files (e.g. `1046224544/fontend`). The result of the script is a zip file (e.g.,`outputdirectory/1046224544-fontend.zip`) will be placed in the folder `outputdirectory` that must exist beforehand. 


### Generating propagation graph info and known sources/sinks/sanitizers
Unzip the zip file corresponding to the downloaded database (e.g.,:`outputdirectory/1046224544-fontend.zip`)

Set the following environment variables: 

`CODEQL=` path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli-atm-home/codeql/codeql`)

`CODEQL_SOURCE_ROOT=`  path to the `ql` queries root (e.g.,`/home/dev/microsoft/ql`)

`QUERY=`  query type (e.g.,`Xss`)


`./generatedata.sh [projectdir]` 

where `projectdir` is the name of the resulting folder after of the unzipped database (e.g.,`output/1046224544_fontend_19c10c3`)

This will generate propagation graph info, sources, sinks, sanitizers in `data/projectdir` (e.g.,`data/1046224544_fontend_19c10c3/...`)

### Generating Constraints

Change projectdir

``python3 main.py --mode [projectdir] -g ``

This will generate all constraints in `constraints/projectdir` folder

## Running solver

``python3 main.py --mode [projectdir] -s``

This will generate results in `results/projectdir/[query-type]`and the gurobi model in `models/projectdir/[query-type]` folder 

`results/projectdir/[query-type]` will contain `reprScores.txt` which needs to be added to `codeql/javascript/ql/src/tsm_[query]_worse.qll` file
or use the next steps to combine scores

## Combine the scores from each database

Use `cd misc; python3 combinescores.py` to combine the scores from each database

Change the `query` to target queryType: `NosqlInjectionWorse/SqlInjectionWorse/DomBasedXssWorse`

Copy the scores to `codeql/javascript/ql/src/tsm_[query]_worse.qll`

## Using the scored reps to compute event scores for each database

For each database, run
`./generateEventScores.sh [db-path]`

This will generate csv files scoring all events in `data/[db-name]/*tsmworse-*.prop.csv`


## Compute metrics 

Use `python3 generateMetrics.py` to compute precision and recall across different thresholds for a query
 
 

