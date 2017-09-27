import pandas as pd
from random import shuffle
import numpy as np
import scipy.misc

class HASYDataLoader:
    def __init__(self, path, symbol_range = range(70, 80), flatten_images = True):
        self.path = path
        self.data = pd.read_csv(path + "hasy-data-labels.csv")

        if symbol_range is not None:
            self.data = self.data[self.data["symbol_id"] >= symbol_range.start]
            self.data = self.data[self.data["symbol_id"] <= symbol_range.stop]

        self.images = self.__read_images(flatten=flatten_images)
        self.symbol_ids = self.data["symbol_id"]

    def get_training_and_test_data(self, training_ratio = 0.8, randomize = True):
        index_array = np.array(range(0, len(self.data)))
        if randomize:
            shuffle(index_array)
        training_range = range(0, int(len(self.data) * training_ratio))
        test_range = range(int(len(self.data) * training_ratio), len(self.data))

        training_images = self.images[index_array[training_range]]
        test_images = self.images[index_array[test_range]]
        training_symbols = self.symbol_ids.values[index_array[training_range]]
        test_symbols = self.symbol_ids.values[index_array[test_range]]

        return training_images, test_images, training_symbols, test_symbols

    def get_training_validation_and_test_data(self, training_ratio = 0.8, validation_ratio = 0.1, randomize = True):
        test_ratio = 1 - training_ratio
        validation_ratio_compared_to_test = 1 / (test_ratio / validation_ratio)

        training_images, test_images, training_symbols, test_symbols = self.get_training_and_test_data(training_ratio = training_ratio, randomize = randomize)

        validation_range = range(0, int(len(test_images) * validation_ratio_compared_to_test))
        print("Validation range [{}, {}]".format(validation_range.start, validation_range.stop))
        test_range = range(int(len(test_images) * validation_ratio), len(test_images))

        validation_images = test_images[validation_range]
        validation_symbols = test_symbols[validation_range]
        test_images = test_images[test_range]
        test_symbols = test_symbols[test_range]

        return training_images, test_images, validation_images, training_symbols, test_symbols, validation_symbols

    def __read_images(self, flatten):
        images = list(map(lambda x: scipy.misc.imread(self.path + x, mode="L").flatten() if flatten else scipy.misc.imread(self.path + x, mode="L"), list(self.data["path"])))

        return np.array(images)