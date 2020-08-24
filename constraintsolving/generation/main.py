import os
import sys
from generation import DataGenerator
import logging

logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

if __name__ == "__main__":
    projectDir = sys.argv[1]
    if(len(sys.argv)>2):
        projectName = sys.argv[2] 
    else:
        projectName = os.path.basename(projectDir)

    queryType = os.environ["QUERY"]
    generator = DataGenerator(projectDir, projectName)
    ath_to_sources, path_to_sinks, path_to_sanitizers, path_to_triplets, path_to_repr_mapping = generator.generate(queryType)
