import pandas as pd
import random
import matplotlib.pyplot as plt
import numpy as np

pd.options.mode.chained_assignment = None

def cast_to_categorical_colums(data, columns):
    for feature in columns:
        data[feature] = data[feature].astype("category")

    return data

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
survived_colors = { 1 : "chartreuse", 0 : "crimson" }
noise = np.random.normal(0, 0.1, len(data))

plt.scatter(x = data["FamilySize"] + noise, y = data["Age"], color = list(data["Survived"].map(lambda x: survived_colors[x])), alpha = 0.3, s = 50, marker = "o")

plt.scatter(x = average_joe["FamilySize"], y = average_joe["Age"], color = "black", s = 150, marker = "x")
plt.scatter(x = average_non_survivor_joe["FamilySize"], y = average_non_survivor_joe["Age"], color = "grey", s = 150, marker = "x")
plt.scatter(x = average_survivor_jane["FamilySize"], y = average_survivor_jane["Age"], color = "purple", s = 150, marker = "x")
plt.show()
#average_joe["FamilySize"] == average_non_survivor_joe["FamilySize"]
#average_joe["Age"] == average_non_survivor_joe["Age"]

similar_to_joe = get_similar_passengers(average_joe, data)
similar_to_jane = get_similar_passengers(average_survivor_jane, data)

similar_to_joe
similar_to_jane