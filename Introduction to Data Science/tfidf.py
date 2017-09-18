import math

def tf(word, blob):
    return blob.split(" ").count(word) / len(blob.split(" "))

def n_containing(word, bloblist):
    return sum(1 for blob in bloblist if word in blob.split(" "))

def idf(word, bloblist):
    return math.log(len(bloblist) / (1 + n_containing(word, bloblist)))

def tfidf(word, blob, bloblist):
    return tf(word, blob) * idf(word, bloblist)