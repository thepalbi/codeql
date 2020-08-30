## Installing dependencies

`python3 -m pip install -r requirements.txt`

Then try `python3 -m pip gurobipy` to install python support for the `gurobi` solver.  

In OSX you may need to install `girubi` support for python manualy by executing this command: `python3 /Library/gurobiXXX/mac64/setup.py install`, where `XXX` is the version installed in your computer.


## Downloading databases from LGTM

The files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` contains each one a 
a list of datatabases to be fetched from the LGTM site.  

Run `python3 -m misc.scrape -dld [project-slug] -o [outputdirectory]` where 
`project-slug` is one database listed in the three aforementioned files (e.g. `1046224544/fontend`). The result of the script is a zip file (e.g.,`outputdirectory/1046224544-fontend.zip`) will be placed in the folder `outputdirectory` that must exist beforehand. 

Finally unzip the zip file corresponding to the downloaded database (e.g.,:`output/1046224544-fontend.zip`)

To run the analysis pipeline there are currently two options: 

1) Using the Orquestator to run the analysis end-to-end or indivitual steps
2) Execute indivirual the scripts

# 1) \[Still in Development\] Executing the analysis pipeline using the Orchestrator 
The `Orchestrator` can be used to execute each phase of the analysis pipeline. 
The pipeline at the moment has the following steps implemented:

- `generate_entities`: Generate `repr` functions for sources/sinks/sanitizers, propagation graph nodes and edges and a node-to-`repr`
 mapping.
- `generate_model`: Generate `gurobi` model to optimize.
- `optimize`: Run `gurobi` with the model generated in the `generate_model` step.
- `generate_scores`: Generate scores info for sinks, sources and sanitizers. This will leave the scores in the folder `data/[db-name]/*tsmworse-*.prop.csv`


This steps can be executed individually or all together in an end-to-end runner.   You can use the orchestrator in code, or with it's CLI. The latter one is located in `main.py`.

Fist, configure the environment variables defined in

You can either run a single step of the pipeline:

```bash
# Run the whole pipeline:
python main.py --project-dir output/abhinavkumarl-bidding-system/ --query-type Xss --query-name DomBasedXssWorse
```

For instance this command will run the `generate_scores` step

```bash
# Execute one step: 
python main.py --project-dir output/abhinavkumarl-bidding-system/ --single-step generate_scores --query-type Xss --query-name DomBasedXssWorse
```

To see more options or get help from the CLI:

```bash
python main.py --help
```

# 2) Execute each analysis phase script

## Setting the envorinment variables
Follow the steps below to prepare the environment:

- Let's say the CodeQL database has bees stored in `output/1046224544_fontend_19c10c3`
- Set the following environment variables: 
    - `CODEQL=` path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli-atm-home/codeql/codeql`)
    - `CODEQL_SOURCE_ROOT=`  path to the `ql` queries root (e.g.,`/home/dev/microsoft/ql`)
    - `QUERY_TYPE=` query type, one of  [`Xss`, `NoSql`, `Sql`]
    - `QUERY_NAME=` query name, one of  [`NosqlInjectionWorse`, `SqlInjectionWorse`,`DomBasedXssWorse`]


## Generating propagation graph info and known sources/sinks/sanitizers

Then invoke `python3 -m generation.main --step entities --project-dir [projectDir]` where `projectDir` is the name of the resulting folder after of the unzipped database and the output folder (e.g.,`output/1046224544_fontend_19c10c3`) or simply invoke  `./generateData.sh [projectDir]`.

This module will orchestrate all the calls to the `CodeQL` toolchain, to generate and extract:
    - Sources, sinks and sanitizers information
    - Propagation graph
    - A seldon-like repr mapping

## Constraint Solving

Now, we will generate the constraints out of the information generated in the previous phase and send invoke the gurobi optimizer. 

### Generating Constraints

To produce the constraints perform  `python3 main.py --mode [project] -g `, where project is the name of the project to analyze (e.g.: `1046224544_fontend_19c10c3`)

This will obtain the information from the CVS files in the `data` folder generate all constraints in the `constraints/projectdir` folder (e.g.,`constraints/1046224544_fontend_19c10c3/...`)

To analyze several projects use the option  `--mode combined` and add the parameter `--project_folders [folder]` to indicate the folder containing all the projects to be analyzed.

### Running solver

To run the solver perform:  ``python3 main.py --mode [projectdir] -s``

This will generate results in `results/projectdir/[query-name+timestamp]`and the gurobi model in `models/projectdir/[query-name+timestamp]` folder. 

`results/projectdir/[query-name=timestamp]` will contain `reprScores.txt` which needs to be added to `ql/javascript/ql/src/tsm_[query-type]_worse.qll` file or use the next steps to combine scores

## Combine the scores from each database

Use `cd misc; python3 combinescores.py` to combine the scores from each database.

Copy the scores to the target `query-type`:   `codeql/javascript/ql/src/tsm_[query-type]_worse.qll`

## Using the scored reps to compute event scores for each database

For each database, run
`python3 -m generation.main --step scores --project-dir [projectDir]` where `projectDir` is the name of the resulting folder after of the unzipped database and the output folder (e.g.,`output/1046224544_fontend_19c10c3`).

This will generate csv files scoring all events in `data/[db-name]/*tsmworse-*.prop.csv`



# Compute metrics to analyze precision 

Use `python3 generateMetrics.py [projectList]` where `projectList` is one of these files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` that contains list of projects.  This script will compute precision and recall across different thresholds for the query type.
 
