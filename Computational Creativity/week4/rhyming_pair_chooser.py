from nltk.tag import pos_tag
import pronouncing
import random

def get_rhyming_noun_pairs_from_line(line):
    line_last_word = line.split(" ")[-1]

    return get_rhyming_noun_pairs(line_last_word)

def get_rhyming_noun_pairs(word):
    assert " " not in word
    word_rhymes = generate_rhymes(word)
    rhymes_with_tags = pos_tag(word_rhymes)

    rhyming_nouns = list(filter(lambda x: x[1] in ["NNP", "NN"], rhymes_with_tags))

    return list(map(lambda x: x[0], rhyming_nouns))

def generate_rhymes(word):
    rhyming_words = pronouncing.rhymes(word)
    return rhyming_words