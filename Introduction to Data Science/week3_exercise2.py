import pandas as pd
import scipy.misc
from sklearn.linear_model import LogisticRegression
from random import shuffle
import numpy as np
import matplotlib.pyplot as plt

class HASYDataLoader:
    def __init__(self, path, symbol_range = range(70, 80)):
        self.path = path
        self.data = pd.read_csv(path + "hasy-data-labels.csv")
        self.data = self.data[self.data["symbol_id"] >= symbol_range.start]
        self.data = self.data[self.data["symbol_id"] <= symbol_range.stop]

        self.images = self.__read_images()
        self.symbol_ids = self.data["symbol_id"]

    def get_training_and_test_data(self, training_ratio = 0.8, randomize = True):
        index_array = np.array(range(0, len(loader.data)))
        if randomize:
            shuffle(index_array)
        training_range = range(0, int(len(loader.data) * training_ratio))
        test_range = range(int(len(loader.data) * training_ratio), len(loader.data))

        training_images = loader.images[index_array[training_range]]
        test_images = loader.images[index_array[test_range]]
        training_symbols = loader.symbol_ids.values[index_array[training_range]]
        test_symbols = loader.symbol_ids.values[index_array[test_range]]

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

    def __read_images(self):
        images = list(map(lambda x: scipy.misc.imread(self.path + x, mode="L").flatten(), list(self.data["path"])))

        return np.array(images)

def get_one_zero_loss(y, y_hat):
    return np.sum(y != y_hat)

def get_mean_squared_loss(y, y_hat):
    return np.mean(pow((y - y_hat), 2))

loader = HASYDataLoader(path="data/HASYv2/")
training_images, test_images, training_symbols, test_symbols = loader.get_training_and_test_data()

# 3
model = LogisticRegression()
model.fit(X = training_images, y = training_symbols)

# 4
most_common_symbol = scipy.stats.mode(training_symbols).mode[0]
naive_prediction_symbols = np.array([most_common_symbol] * len(test_images))
model_prediction_symbols = model.predict(test_images)

print("One-zero loss:")
print("Naive: %f" % get_one_zero_loss(test_symbols, naive_prediction_symbols))
print("Logistic: %f" % get_one_zero_loss(test_symbols, model_prediction_symbols))

print("-----")

print("Mean squared loss:")
print("Naive: %f " % get_mean_squared_loss(test_symbols, naive_prediction_symbols))
print("Logistic: %f" % get_mean_squared_loss(test_symbols, model_prediction_symbols))

# 5
#correctness_array = test_symbols == model_prediction_symbols
#wrong_prediction_indexes = np.where(correctness_array == False)[0]
#plt.imshow(loader.images[int(np.random.choice(wrong_prediction_indexes, 1))].reshape(32, 32))