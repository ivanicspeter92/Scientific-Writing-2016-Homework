import ex2
import nltk

def contains_noun(pos_tag_tuples):
    noun_keys = ["NOUN", "NN"]

    return len(list(filter(lambda x: x[1] in noun_keys, pos_tag_tuples))) > 0

pos_tag_tuples = []

while contains_noun(pos_tag_tuples) == False:
    text = ex2.generate2(ex2.probs1, ex2.probs2, 10)
    pos_tag_tuples = nltk.pos_tag(text.split(" "))

