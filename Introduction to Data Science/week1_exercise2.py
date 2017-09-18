import pandas as pd
import string
from nltk.stem import *

basefolder = "data/amazon_reviews"

def remove_punctuation_and_stopwords(data, stopwords, punctuation_characters = string.punctuation):
    data = data.map(lambda record: remove_punctuation(record, punctuation_characters = punctuation_characters))
    data = data.map(lambda record: remove_stopwords(record, stopwords))

    return data

def remove_punctuation(string, punctuation_characters):
    if type(punctuation_characters) is list:
        punctuation_characters = "".join(punctuation_characters)

    return string.translate(string.maketrans('','', punctuation_characters))

def remove_stopwords(string, stopwords):
    string = string.split()
    string = " ".join(filter(lambda s: s not in stopwords, string))

    return string

def stem_reviews(reviews):
    reviews = map(lambda review: stem_review(review), reviews)
    return reviews

def stem_review(review):
    stemmer = SnowballStemmer("english")
    words = review.split(" ")
    stemmed_words = list(map(lambda w: stemmer.stem(w), words))

    return " ".join(stemmed_words)

# a
data = pd.read_json(basefolder + "/reviews_Automotive_5.json", lines = True)
# b
data["reviewText"] = data["reviewText"].map(lambda string: string.lower())
# c
stopwords = open("data/amazon_reviews/stop-word-list.txt", "r").read().split("\n")
data["reviewText"] = remove_punctuation_and_stopwords(data = data["reviewText"], punctuation_characters = list(string.punctuation), stopwords = stopwords)
# d
a = stem_review(data["reviewText"][0])
#e
positive_reviews = data.loc[data["overall"] >= 4]
negative_reviews = data.loc[data["overall"] <= 2]

positive_reviews.to_csv(basefolder + "_processed/pos.csv")
negative_reviews.to_csv(basefolder + "_processed/neg.csv")