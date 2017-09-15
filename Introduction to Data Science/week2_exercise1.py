import pandas as pd
import random
import matplotlib.pyplot as plt
import numpy as np
from week1_exercise1 import cast_to_categorical_colums
pd.options.mode.chained_assignment = None

def get_modes_and_medians(data):
    ignored_colums = set(["Name", "PassengerId"])
    categorical_colums = set(["Deck", "Survived", "Sex", "Embarked", "Pclass", "Ticket", "Cabin"])
    data = cast_to_categorical_colums(data, columns = categorical_colums)
    modes_and_medians = {}

    for catcol in categorical_colums.difference(ignored_colums):
        mode = list(data[catcol].mode())
        modes_and_medians[catcol] = mode
    for noncatcol in set(data.columns).difference(categorical_colums).difference(ignored_colums):
        median = data[noncatcol].median()
        modes_and_medians[noncatcol] = median

    return modes_and_medians

def singlify_modes(modes_and_medians):
    single_medians = modes_and_medians
    for key in modes_and_medians.keys():
        if type(modes_and_medians[key]) == list and len(modes_and_medians[key]) > 1:
            single_medians[key] = random.choice(modes_and_medians[key])
        else:
            single_medians[key] = modes_and_medians[key]

    return single_medians

def create_average_passenger(data):
    modes_and_medians = get_modes_and_medians(data)
    single_medians = singlify_modes(modes_and_medians)

    return pd.DataFrame(single_medians)

def get_similar_passengers(specimen, data, age_threshold = 5, family_size_threshold = 1, same_survival = True, same_gender = True):
    filtered_data = data

    filtered_data = filtered_data[(filtered_data["Age"] >= float(specimen["Age"] - age_threshold)) & (filtered_data["Age"] <= float(specimen["Age"] + age_threshold))]
    filtered_data = filtered_data[(filtered_data["FamilySize"] >= int(specimen["FamilySize"] - family_size_threshold)) & (filtered_data["FamilySize"] <= int(specimen["FamilySize"] + family_size_threshold))]
    if same_survival:
        filtered_data = filtered_data[filtered_data["Survived"] == int(specimen["Survived"])]
    if same_gender:
        filtered_data = filtered_data[filtered_data["Sex"].isin(specimen["Sex"])]

    return filtered_data

def plot_family_size_over_age(data, add_noise = True, special_people = False):
    survived_colors = {1: "black", 0 : "black"} if special_people else {1: "green", 0: "crimson"}
    colorlist = list(data["Survived"].map(lambda x: survived_colors[x]))

    male_marker = "$\u2642$"
    female_marker = "$\u2640$"

    # gender_markers = {"male": male_marker, "female": female_marker}
    # markerlist = list(data["Sex"].map(lambda x: gender_markers[x]))

    noise = np.random.normal(0, 0.1, len(data)) if add_noise else np.repeat(0, len(data))

    males = data[data["Sex"] == "male"]
    females = data[data["Sex"] == "female"]

    plt.scatter(x = males["FamilySize"] + noise[:len(males)], y = males["Age"], color = colorlist, alpha = 1.0 if special_people else 0.3, s = 150 if special_people else 75, marker = male_marker)
    plt.scatter(x=females["FamilySize"] + noise[:len(females)], y = females["Age"], color = colorlist, alpha = 1.0 if special_people else 0.3, s = 150 if special_people else 75, marker=female_marker)

data = pd.read_csv("data/titanic_processed/train_processed.csv", sep = "\t")
data["FamilySize"] = data["SibSp"] + data["Parch"]

# 1
modes_and_medians = get_modes_and_medians(data)
print(modes_and_medians)

# 2
average_joe = create_average_passenger(data)
average_joe["Name"] = "Average Joe"

#average_survivor_jane = create_average_passenger(data[(data["Sex"] == "female") & (data["Survived"] == 1)])
average_survivor_jane = create_average_passenger(data[data["Survived"] == 1])
average_survivor_jane["Name"] = "Average survivor Jane"

#average_non_survivor_joe = create_average_passenger(data[(data["Sex"] == "male") & (data["Survived"] == 0)])
average_non_survivor_joe = create_average_passenger(data[data["Survived"] == 0])
average_non_survivor_joe["Name"] = "Average non-survivor Joe"

print(average_joe)
print(average_survivor_jane)
print(average_non_survivor_joe)

# 3
plot_family_size_over_age(data)
plot_family_size_over_age(pd.concat([average_joe, average_non_survivor_joe, average_survivor_jane]), add_noise = False, special_people = True)

plt.show()

#average_joe["FamilySize"] == average_non_survivor_joe["FamilySize"]
#average_joe["Age"] == average_non_survivor_joe["Age"]

similar_to_joe = get_similar_passengers(average_joe, data)
similar_to_jane = get_similar_passengers(average_survivor_jane, data)

similar_to_joe
similar_to_jane