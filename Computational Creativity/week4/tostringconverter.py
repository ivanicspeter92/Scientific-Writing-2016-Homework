from nltk import word_tokenize
import string
def format_made_up_fact(made_up_fact):
    return " ".join(made_up_fact[:3])

def format_markov_chain_sentence(sentence):
    if sentence is None: return ""

    tokens = word_tokenize(sentence)
    filtered_tokens = list(filter(lambda word: word not in string.punctuation, tokens))

    return " ".join(filtered_tokens)