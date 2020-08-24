### Installing dependencies

`python3 -m pip install -r requirements.txt`

Then try `python3 -m pip gurobipy` to install python support for the gurobi solver.  

In OSX you may need to install `girubi` support for python manualy by executing this command: `python3 /Library/gurobiXXX/mac64/setup.py install`, where `XXX` is the version installed in your computer.


### Downloading databases from LGTM

The files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` contains each one a 
a list of datatabases to be fetched from the LGTM site.  

Run `python3 -m misc.scrape -dld [project-slug] -o [outputdirectory]` where 
`project-slug` is one database listed in the three aforementioned files (e.g. `1046224544/fontend`). The result of the script is a zip file (e.g.,`outputdirectory/1046224544-fontend.zip`) will be placed in the folder `outputdirectory` that must exist beforehand. 


### Generating propagation graph info and known sources/sinks/sanitizers
First, follow the steps below to prepare the environment:

- Unzip the zip file corresponding to the downloaded database (e.g.,:`output/1046224544-fontend.zip`)
- Let's say the CodeQL database has bees stored in `output/1046224544_fontend_19c10c3`
- Set the following environment variables: 
    - `CODEQL=` path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli-atm-home/codeql/codeql`)
    - `CODEQL_SOURCE_ROOT=`  path to the `ql` queries root (e.g.,`/home/dev/microsoft/ql`)

The old `generateData.sh` string has been moved to the `generation` python module. The basic usage is the following.

```python
from generation import DataGenerator
import logging

logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

if __name__ == "__main__":
    generator = DataGenerator("output/1046224544_fontend_19c10c3", "1046224544_fontend_19c10c3")
    path_to_sources, path_to_sinks, path_to_sanitizers, path_to_triplets, path_to_repr_mapping =
        generator.generate("Sql")
```

- The instantiation of `DataGenerator` contains as arguments first the relative path to the folder containing the CodeQL database (which we extracted above), and the second one is a project slug (it's recommended to use the folder name of the database).
- The generation should not need to be run with any working directory (it uses inside all absolute paths).
- The call to `DataGenerator::generate` will orchestrate all the calls to the `CodeQL` toolchain, to generate and extract:
    - Sources, sinks and sanitizers information
    - Propagation graph
    - A seldon-like repr mapping
- The call above returns the path to each generated CSV file, in that order
- It's recommended to configure logging as mentioned above, since it might be helpful to debug issues

### Generating Constraints

Change projectdir

``python3 main.py --mode [projectdir] -g `` where project is the folder of the project to analyze (e.g.: `1046224544_fontend_19c10c3`)

This will generate all constraints in `constraints/projectdir` folder (e.g.,`constraints/1046224544_fontend_19c10c3/...`)

To analyze several projects use the option  `--mode combined` and add the parameter `--project_folders [folder]` to indicate the folder containing all the projects to be analyzed and .

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
 
 

