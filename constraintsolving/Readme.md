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


# Executing the analysis pipeline using the Orchestrator 
The `Orchestrator` can be used to execute each phase of the analysis pipeline. 
The pipeline at the moment has the following steps implemented:

- `generate_entities`: Generate `repr` functions for sources/sinks/sanitizers, propagation graph nodes and edges and a node-to-`repr` mapping  (intermediate results in `working-dir/data`).
- `generate_model`: Generate `gurobi` model to optimize (intermediate results in `working-dir/constrains`)
- `optimize`: Run `gurobi` with the model generated in the `generate_model` step ( (intermediate results in `working-dir/model`)
- `generate_scores`: Generate scores info for sinks, sources and sanitizers. This will leave the scores in the folder `data/[db-name]/*tsmworse-*.prop.csv` and results in `results-dir/`

These steps can be executed individually or all together in an end-to-end runner. You can use the orchestrator in code, or with it's CLI. The latter one is located in `main.py`.

First, configure the `config.json` file, which has to be located at the `constraintsolving/` root dir. It has the following properties:

```json
{
  "codeQLExecutable": "absolute path to the codeql executable",
  "codeQLSourcesRoot": "absolute path to this project's root directory (where the `.git` folder lives)",
  "workingDirectory": "absolute path to the working directory",
  "resultsDirectory": "absolute path to the results dir"
}
```

The `workingDirectory` determine the location where all working files (e.g., csv files, constraints, and gurobi model) are places.  
`resultsDirectory` is the place when the resulting files on the process (e.g, `reprScores.txt`)
are place. Both directories can be overwritten by using (optional) command line options.

Then, you can either run a single step of the pipeline:

```bash
# Run the whole pipeline:
python main.py --project-dir output/abhinavkumarl-bidding-system/ --query-type Xss --query-name DomBasedXssWorse --results-dir /results/xss --working-dir /wrk/xss run
```

For instance this command will run the `generate_scores` step

```bash
# Execute one step: 
python main.py --project-dir output/abhinavkumarl-bidding-system/ --single-step generate_scores --query-type Xss --query-name DomBasedXssWorse run
```

Additionally, a set of databases can be processed (either a single step or all steps) by using the option `--projects-list`. For instance:

```bash
# Run the whole pipeline on multiple projects:
python main.py --project-dir output/xss/ --query-type Xss --query-name DomBasedXssWorse --results-dir /results/xss --working-dir /wrk/xss --project-list xss_projects.txt run
```

Because some of the step generate large intermediary files, we have added a clean step. At the moment (https://github.com/garbervetsky/ql/commit/91b21f301b871dd44213f2b60d27d324c44509c7), this just cleans the following intermediate folders:
- `models`
- `constraints`
- `logs`

To run in clean mode, use the following command:

```bash
python main.py --project-dir output/abhinavkumarl-bidding-system/ --query-type Xss --query-name DomBasedXssWorse clean
```

To see more options or get help from the CLI:

```bash
python main.py --help
```

## Combine the scores from each database
Once the pipeline has been executed, each indivual results can be combine to get and aggregated results for a set of DBs.

Use `python3 misc/combinescores.py` to combine the scores from each database. 
This will generate the file `allscores_[query_type]_avg.txt`.

This file must be included in the target `query-type`:  `codeql/javascript/ql/src/TSM/tsm_repr_pred.qll` and then re-execute the `generateScores` step. 
This can be done with the commmand:

```bash
 python3 main.py --project-dir output  --query-name DomBasedXssWorse --query-type Xss  --results-dir .  --working-dir /wrk/xss --project-list xss_projects.txt  --single-step generate_scores --scores-file allscores_DomBasedXssWorse_avg.txt 
 ```

This command will recompute the metrics *all* the projects contained in the list `xss_projects.txt` using the the combined score `allscores_DomBasedXssWorse_avg.txt` intead of the individual `reprScores.txt` of each individual project.  

# Compute metrics to analyze precision 

Use `python3 generateMetrics.py [projectList] --working-dir [wrkDir]` where `projectList` is one of these files `nosqlinjection_projects.txt`, `sqlinjection_projects.txt`, and `xss_projects.txt` that contains list of projects. `wrkDir` is the folder where the working files are located (e.g., `data`, `model`, etc.).  
This script will compute precision and recall across different thresholds for the query type.
 
