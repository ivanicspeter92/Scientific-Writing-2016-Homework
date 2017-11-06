import ex2
import nltk

def contains_noun(pos_tag_tuples):
    return len(list(filter(lambda x: is_noun(x), pos_tag_tuples))) > 0

def is_noun(pos_tag_tuple):
    assert isinstance(pos_tag_tuple, tuple)
    noun_keys = ["NOUN", "NN"]

    return pos_tag_tuple[1] in noun_keys

pos_tag_tuples = []

while contains_noun(pos_tag_tuples) == False:
    text = ex2.generate2(ex2.probs1, ex2.probs2, 10)
    pos_tag_tuples = nltk.pos_tag(text.split(" "))

