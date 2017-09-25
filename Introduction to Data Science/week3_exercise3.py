from json import load

from week3_exercise2 import HASYDataLoader, get_one_zero_loss, get_mean_squared_loss
from sklearn.ensemble import RandomForestClassifier
import matplotlib.pyplot as plt
from tpot import TPOTClassifier

def train_random_forests(training_images, test_images, training_symbols, test_symbols):
    number_of_trees = list(range(10, 201, 10))
    loss_array = []
    model_array = []

    # 1
    # model = RandomForestClassifier() # with default parameters the error seems to be typically higher, almost double of the logistic regression

    for n in number_of_trees:
        print(n)
        model = RandomForestClassifier(n_estimators=n)
        model.fit(X=training_images, y=training_symbols)
        model_prediction_symbols = model.predict(test_images)

        loss = get_one_zero_loss(test_symbols, model_prediction_symbols)
        print("One-zero loss:")
        print("Random forest: %f" % loss)

        model_array.append(model)
        loss_array.append(loss)

    return model_array, loss_array, number_of_trees

def plot_error_loss(number_of_trees, loss_array, label = None):
    plt.plot(number_of_trees, loss_array, label = label)
    plt.title("Number of decision trees vs loss")
    plt.xlabel("Number of decision trees")
    plt.ylabel("Loss (one-zero)")

loader = HASYDataLoader(path="data/HASYv2/")
training_images, test_images, training_symbols, test_symbols = loader.get_training_and_test_data()

#2
model_array, loss_array, number_of_trees = train_random_forests(training_images=training_images, training_symbols=training_symbols, test_images=test_images, test_symbols=test_symbols)
plot_error_loss(number_of_trees, loss_array)

# 4
training_images, test_images, validation_images, training_symbols, test_symbols, validation_symbols = loader.get_training_validation_and_test_data()

model_array, loss_array, number_of_trees = train_random_forests(training_images=training_images, training_symbols=training_symbols, test_images=validation_images, test_symbols=validation_symbols)

plt.figure(2)
plot_error_loss(number_of_trees, loss_array, label = "Validation error")

loss_array = []
for model in model_array:
    prediction_symbols = model.predict(test_images)
    loss = get_one_zero_loss(prediction_symbols, test_symbols)

    loss_array.append(loss)

plot_error_loss(number_of_trees, loss_array, label = "Test error")
plt.legend(bbox_to_anchor=(1.05, 1), loc = 2, borderaxespad=0.)

#5
tpot = TPOTClassifier(generations=5, population_size=20, verbosity=2)
tpot.fit(training_images, training_symbols)
print(tpot.score(test_images, test_symbols))