import pronouncing
import numpy as np

def __evaluate_rhyme_pattern(lines):
    last_words = list(map(lambda l: l.split(" ")[-1], lines))

    first_couplet_score = __are_rhymes(last_words[0], last_words[1])
    second_couplet_score = __are_rhymes(last_words[2], last_words[3])

    return np.mean([first_couplet_score, second_couplet_score])

def __are_rhymes(word, another):
    return word in pronouncing.rhymes(another)