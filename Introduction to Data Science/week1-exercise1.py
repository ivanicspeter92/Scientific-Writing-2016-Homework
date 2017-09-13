import pandas as pd
import matplotlib.pyplot as plt
from builtins import round
from scipy.special.tests.test_data import data
import json


def read_data(filename):
    data = pd.read_csv(filename)

    return data

def drop_colums(data, columns):
    columns = set(columns).intersection(set(data.columns)) # removing columns that are not in the data to avoid exceptions

    for column in columns:
        data = data.drop(column, 1)

    return data

def remove_numbers(string):
    if type(string) is not str:
        return string
    filtered_characters = list(filter(lambda c: not c.isdigit(), string))

    return ''.join(filtered_characters)

def get_deck_letter(cabins):
    return cabins.map(lambda cabin: remove_numbers(cabin))

def cast_to_categorical_colums(data, columns):
    for feature in columns:
        data[feature] = data[feature].astype("category")

    return data

def replace_continous_values_with_average(data):
    for column in data:
        if pd.api.types.is_numeric_dtype(data[column]):
            average = data[column].mean()

            if pd.api.types.is_integer_dtype(data[column]):
                average = round(average, 0)

            data[column] = data[column].fillna(average)
            #print("Filled " + column + " with average: " + str(average))

    return data

def replace_categorical_values_with_mode(data, preferred_mode_index = 0):
    for column in data:
        if pd.api.types.is_categorical_dtype(data[column]):
            values = data[column].dropna()
            mode = list(values.mode())[preferred_mode_index]

            data[column] = data[column].fillna(mode)
            print("Filled " + column + " with mode: " + str(mode))

    return data

# 1
data = read_data(filename = "data/titanic/train.csv")
# 2
data = drop_colums(data, ["PassengerId", "Name"])
# 3
data["Deck"] = get_deck_letter(data["Cabin"])
# 4
data = cast_to_categorical_colums(data, columns = ["Deck", "Survived", "Sex", "Embarked", "Pclass"])

# 5a
data = replace_continous_values_with_average(data)
# 5b
data = replace_categorical_values_with_mode(data)

# 6
data.to_csv("data/titanic_processed/train_processed.csv", sep = "\t")
data.to_json("data/titanic_processed/train_processed.json", orient="records", lines = True)