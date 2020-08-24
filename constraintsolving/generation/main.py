from generation import DataGenerator
import logging

logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

if __name__ == "__main__":
    generator = DataGenerator("output/1046224544_fontend_19c10c3", "1046224544_fontend_19c10c3")
    generator.generate("Sql")