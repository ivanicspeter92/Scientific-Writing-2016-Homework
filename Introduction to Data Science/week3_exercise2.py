import pandas as pd
import scipy.misc
from sklearn.linear_model import LogisticRegression
from random import shuffle
import numpy as np
import matplotlib.pyplot as plt

def read_images(paths, base = ""):
    images = list(map(lambda x: scipy.misc.imread(base + x, mode="L").flatten(), list(paths)))

    return np.array(images)

def get_one_zero_loss(y, y_hat):
    return np.sum(y != y_hat)

def get_mean_squared_loss(y, y_hat):
    return np.mean(pow((y - y_hat), 2))

data = pd.read_csv("data/HASYv2/hasy-data-labels.csv")

# 1
data = data[data["symbol_id"] >= 70]
data = data[data["symbol_id"] <= 80]
png_images = read_images(data["path"], base = "data/HASYv2/")

# 2
index_array = np.array(range(0, len(png_images)))
shuffle(index_array)

training_ratio = 0.8
training_range = range(0, int(len(png_images) * training_ratio))
test_range = range(int(len(png_images) * training_ratio), len(png_images))

training_images = png_images[index_array[training_range]]
test_images = png_images[index_array[test_range]]
training_symbols = data["symbol_id"].values[index_array[training_range]]
test_symbols = data["symbol_id"].values[index_array[test_range]]

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
correctness_array = test_symbols != naive_prediction_symbols
wrong_prediction_indexes = np.where(correctness_array == False)[0]
plt.imshow(png_images[int(np.random.choice(wrong_prediction_indexes, 1))].reshape(32, 32))