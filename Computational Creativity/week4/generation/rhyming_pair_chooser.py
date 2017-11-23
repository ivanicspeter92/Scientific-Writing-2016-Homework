from nltk.tag import pos_tag
import pronouncing
import random

def get_rhyming_noun_pairs_from_line(line, verbose):
    line_last_word = line.split(" ")[-1]

    return get_rhyming_noun_pairs(line_last_word, verbose)

def get_rhyming_noun_pairs(word, verbose):
    assert " " not in word

    if verbose: print("Searching for rhyming nouns for word {}".format(word))
    word_rhymes = generate_rhymes(word)
    rhymes_with_tags = pos_tag(word_rhymes)

    rhyming_nouns = list(filter(lambda x: x[1] in ["NNP", "NN"], rhymes_with_tags))
    if verbose: print("{} rhyming nouns found".format(len(rhyming_nouns)))

    return list(map(lambda x: x[0], rhyming_nouns))

def generate_rhymes(word):
    rhyming_words = pronouncing.rhymes(word)
    return rhyming_words