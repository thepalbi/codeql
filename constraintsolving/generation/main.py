from generation import CodeQLWrapper
import argparse
import logging

query = "NoSql"
project = "/Users/thepalbi/Facultad/tesis/ql-atm/constraintsolving/output/1046224544_fontend_19c10c3"
ql_file = "/Users/thepalbi/Facultad/tesis/ql-atm/javascript/ql/src/Sources-{0}.ql".format(query)
output_file = "logs/js-results.csv"
bqrs_file = "output/1046224544_fontend_19c10c3/results/codeql-javascript/Sources-{0}.bqrs".format(query)

logging.basicConfig(level=logging.DEBUG, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

if __name__ == "__main__":
    wrapper = CodeQLWrapper()
    wrapper.database_analyze(project, ql_file, output_file)
    wrapper.bqrs_decode(bqrs_file, "sourceNoSqlClasses", "data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-src-NoSql.prop.csv")



