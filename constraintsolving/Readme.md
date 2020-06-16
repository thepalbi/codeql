### Installing dependencies

`python3 -m pip install -r requirements.txt`

### Generating propagation graph info

Change project name, codeql cli path, and database name accordingly

`./generatedata.sh`

This will generate propagation graph info, sources, sinks, sanitizers in `data/projectdir`

### Generating Constraints

Change projectdir

``python3 get_constraints.py ``

This will generate all constraints in `constraints/projectdir` folder

## Run solver

Install gurobipy separately. Change projectdir.

``python3 solve-gb.py``

This will generate results and the gurobi model in `models/projectdir` folder

