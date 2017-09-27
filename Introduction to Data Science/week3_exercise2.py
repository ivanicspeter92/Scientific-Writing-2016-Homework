import scipy.misc
from sklearn.linear_model import LogisticRegression
import numpy as np
import matplotlib.pyplot as plt
from HASYDataLoader import HASYDataLoader

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
correctness_array = test_symbols == model_prediction_symbols
wrong_prediction_indexes = np.where(correctness_array == False)[0]

index = int(np.random.choice(wrong_prediction_indexes, 1))
prediction = model_prediction_symbols[index]
actual = test_symbols[index]
plt.imshow(loader.images[index].reshape(32, 32))
plt.title("Predicted {} but actual was {}".format(prediction, actual))
