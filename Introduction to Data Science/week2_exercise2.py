import pandas as pd
import tfidf
from week1_exercise2 import remove_punctuation_and_stopwords, remove_stopwords
import string

def word_occurrance_count(str):
    counts = {}
    words = str.split()

    for word in words:
        if word in counts:
            counts[word] += 1
        else:
            counts[word] = 1

    return counts

def merge_word_count_dictionaries(dict1, dict2):
    for key in dict2:
        if key in dict1.keys():
            dict1[key] += dict2[key]
        else:
            dict1[key] = dict2[key]
    return dict1

def sum_word_occurrance_count_dictionaries(dictionaries):
    result = {}

    for dict in dictionaries:
        result = merge_word_count_dictionaries(result, dict)

    return result

def sort_dictionary_by_values(dictionary, reverse = False):
    return [(k, v) for v, k in sorted([(v, k) for k, v in dictionary.items()], reverse = reverse)] # http://bytesizebio.net/2013/04/03/stupid-python-tricks-3296-sorting-a-dictionary-by-its-values/

def get_word_counts(reviews):
    counts = reviews.apply(lambda x: word_occurrance_count(x))
    counts = sum_word_occurrance_count_dictionaries(counts)

    return counts

def get_tfidf_values(count_array, blob, bloblist):
    tfidf_values = []
    for word_count in count_array:
        word = word_count[0]
        positive_tfidf = tfidf.tfidf(word=word, blob=blob, bloblist=bloblist)
        tfidf_values.append((word, positive_tfidf))
        print("{}: {}".format(word, positive_tfidf))
    return tfidf_values

def preprocess(reviews):
    reviews = reviews[reviews["reviewText"].isnull() == False]
    reviews["reviewText"] = reviews["reviewText"].map(lambda string: string.lower())

    #stopwords = pd.read_csv("data/amazon_reviews/stop-word-list.txt")
    stopwords = open("data/amazon_reviews/stop-word-list.txt", "r").read().split("\n")
    reviews["reviewText"] = remove_punctuation_and_stopwords(data=reviews["reviewText"], punctuation_characters=list(string.punctuation), stopwords=stopwords)

    return reviews

def hasNumbers(inputString):
    return any(char.isdigit() for char in inputString)

def get_invalid_words(words):
    array = []
    for key in words:
        if len(key) < 3 or hasNumbers(key):
            array.append(key)
    return array

positive_reviews = pd.read_csv("data/amazon_reviews_processed/pos.csv")
negative_reviews = pd.read_csv("data/amazon_reviews_processed/neg.csv")

positive_reviews = preprocess(positive_reviews)
negative_reviews = preprocess(negative_reviews)

# 1
positive_counts = get_word_counts(positive_reviews["reviewText"])
positive_counts_sorted = sort_dictionary_by_values(positive_counts, reverse = True)
negative_counts = get_word_counts(negative_reviews["reviewText"])
negative_counts_sorted = sort_dictionary_by_values(negative_counts, reverse = True)

# 2
all_positive_words = " ".join(positive_reviews["reviewText"])
all_negative_words = " ".join(negative_reviews["reviewText"])

unique_word_counts = merge_word_count_dictionaries(positive_counts, negative_counts)
invalid_words = get_invalid_words(unique_word_counts.keys())

for word in invalid_words:
    unique_word_counts.pop(word, None)

unique_word_counts_sorted = sort_dictionary_by_values(unique_word_counts, reverse = True)#[1:100]

positive_tfidf = get_tfidf_values(unique_word_counts_sorted, all_positive_words, [all_positive_words, all_negative_words])
negative_tfidf = get_tfidf_values(unique_word_counts_sorted, all_negative_words, [all_positive_words, all_negative_words])

matrix = pd.DataFrame()
matrix["word"] = list(map(lambda x: x[0], unique_word_counts_sorted))
matrix["positive_tfidf"] = list(map(lambda x: x[1], positive_tfidf))
matrix["negative_tfidf"] = list(map(lambda x: x[1], negative_tfidf))

pos_max = matrix["positive_tfidf"].min()
pos_max_word = matrix[matrix["positive_tfidf"] == matrix["positive_tfidf"].min()]["word"]
neg_max = matrix["negative_tfidf"].min()
neg_max_word = matrix[matrix["negative_tfidf"] == matrix["negative_tfidf"].min()]["word"]

print("Most important positive word: {} {}".format(pos_max_word.to_string(), pos_max))
print("Most important negative word: {} {}".format(neg_max_word.to_string(), neg_max))