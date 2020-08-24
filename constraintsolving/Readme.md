## Installing dependencies

`python3 -m pip install -r requirements.txt`

Then try `python3 -m pip gurobipy` to install python support for the gurobi solver.  

In OSX you may need to install `girubi` support for python manualy by executing this command: `python3 /Library/gurobiXXX/mac64/setup.py install`, where `XXX` is the version installed in your computer.


## Downloading databases from LGTM

The files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` contains each one a 
a list of datatabases to be fetched from the LGTM site.  

Run `python3 -m misc.scrape -dld [project-slug] -o [outputdirectory]` where 
`project-slug` is one database listed in the three aforementioned files (e.g. `1046224544/fontend`). The result of the script is a zip file (e.g.,`outputdirectory/1046224544-fontend.zip`) will be placed in the folder `outputdirectory` that must exist beforehand. 


## Generating propagation graph info and known sources/sinks/sanitizers
First, follow the steps below to prepare the environment:

- Unzip the zip file corresponding to the downloaded database (e.g.,:`output/1046224544-fontend.zip`)
- Let's say the CodeQL database has bees stored in `output/1046224544_fontend_19c10c3`
- Set the following environment variables: 
    - `CODEQL=` path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli-atm-home/codeql/codeql`)
    - `CODEQL_SOURCE_ROOT=`  path to the `ql` queries root (e.g.,`/home/dev/microsoft/ql`)
    - `QUERY_TYPE=` query type, one of  [`Xss`, `NoSql`, `Sql`]
    - `QUERY_NAME=` query name, one of  [`NosqlInjectionWorse`, `SqlInjectionWorse`,`DomBasedXssWorse`]

Then invoke `python3 -m generation.main [projectDir] [projectName]` where `projectDir` is the name of the resulting folder after of the unzipped database and the output folder (e.g.,`output/1046224544_fontend_19c10c3`) and `projectName` is the project name (e.g.,`1046224544_fontend_19c10c3`) or simply invoke  `./generateData.sh [projectDir]`.

This module will orchestrate all the calls to the `CodeQL` toolchain, to generate and extract:
    - Sources, sinks and sanitizers information
    - Propagation graph
    - A seldon-like repr mapping

The call above returns the path to each generated CSV file, in that order. The files are stored in the `data/projectName` folder. 
For instance, the following code snippet can be used to obtain the paths of the CVS files produced by this module. 

```python
from generation import DataGenerator
import logging

logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

if __name__ == "__main__":
    generator = DataGenerator("output/1046224544_fontend_19c10c3", "1046224544_fontend_19c10c3")
    path_to_sources, path_to_sinks, path_to_sanitizers, path_to_triplets, path_to_repr_mapping =
        generator.generate("Sql")
```

It's recommended to configure logging as mentioned above, since it might be helpful to debug issues.


## Constraint Solving

Now, we will generate the constraints out of the information generated in the previous phase and send invoke the gurobi optimizer. 

### Generating Constraints

To produce the constraints perform  ``python3 main.py --mode [projectdir] -g ``, where project is the folder of the project to analyze (e.g.: `1046224544_fontend_19c10c3`)

This will obtain the information from the CVS files in the `data` folder generate all constraints in the `constraints/projectdir` folder (e.g.,`constraints/1046224544_fontend_19c10c3/...`)

To analyze several projects use the option  `--mode combined` and add the parameter `--project_folders [folder]` to indicate the folder containing all the projects to be analyzed.

### Running solver

To run the solver perform:  ``python3 main.py --mode [projectdir] -s``

This will generate results in `results/projectdir/[query-name+timestamp]`and the gurobi model in `models/projectdir/[query-name+timestamp]` folder. 

`results/projectdir/[query-name=timestamp]` will contain `reprScores.txt` which needs to be added to `codeql/javascript/ql/src/tsm_[query-type]_worse.qll` file or use the next steps to combine scores

## Combine the scores from each database

Use `cd misc; python3 combinescores.py` to combine the scores from each database.

Copy the scores to the target `query-type`:   `codeql/javascript/ql/src/tsm_[query-type]_worse.qll`

[//]: # (Change the `query` to target query-type: [`NosqlInjectionWorse`, `SqlInjectionWorse`,`DomBasedXssWorse`])


## Using the scored reps to compute event scores for each database

For each database, run
`./generateEventScores.sh [db-path]`

This will generate csv files scoring all events in `data/[db-name]/*tsmworse-*.prop.csv`


## Compute metrics 

Use `python3 generateMetrics.py` to compute precision and recall across different thresholds for a query
 
 

