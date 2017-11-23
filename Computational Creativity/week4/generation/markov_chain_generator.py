import string
from nltk import word_tokenize
import nltk
from generation import utilities
import re

def generate_markov_model(project_gutenberg_book_paths, order, verbose):
    '''
    Reads the TXT files downloaded from project gutenberg and builds a Markov model based on their contents.

    :param project_gutenberg_book_paths: A list of strings pointing to the path of the
    :type project_gutenberg_book_paths: list
    :param order: The order of the Markov chain.
    :type: int
    :param: verbose: A boolean indicating if additional output should be generated.
    :type: bool
    :return: The Markov model.
    :rtype: markovify.text.Text

    :exception FileNotFoundException if the file was not found on the given path.
    :exception AssertionException if the order is incorrect.
    '''
    assert isinstance(order, int) and order > 0

    if verbose: print("Creating {}. order markov chain from corpus {}".format(order, project_gutenberg_book_paths))
    contents = " ".join(list(map(lambda p: __read_project_guttenberg_book(p), project_gutenberg_book_paths))) # the raw contents as a single string of the books

    tokens = word_tokenize(contents)
    tokens = list(map(lambda t: t.lower(), tokens))

    filtered_tokens = __filter_tokens(tokens, verbose)
    model = __markov_chain(" ".join(filtered_tokens), order=order)
    
    return model

def __read_project_guttenberg_book(path):
    '''
    Reads the TXT file downloaded from project gutenberg.
    :param path: The path to the file.
    :type path: str
    :return: The clean text of the text file without all start & end tags and empty lines.
    :rtype: str

    :exception FileNotFoundException if the file was not found on the given path.
    '''
    book = open(path,'r', encoding="utf-8").read()

    # Divide text by rows
    rows = book.split('\n')

    # Search for START and END tags to remove useless parts
    start_idx = utilities.get_index(rows, '*** START')
    end_idx = utilities.get_index(rows, '*** END')

    rows = rows[start_idx+1:end_idx]

    text = '\n'.join([r for r in rows if r!=''])
    return text

def __filter_tokens(tokens, verbose):
    if verbose: print("Filtering {} tokens".format(len(tokens)))

    other_characters = ["‘", "’"]

    filtered_tokens = list(filter(lambda word: word not in string.punctuation, tokens))
    #filtered_tokens = list(filter(lambda word: word not in set(stopwords.words('english')), filtered_tokens))
    filtered_tokens = list(filter(lambda word: word not in other_characters, filtered_tokens))

    if verbose: print("Filtered out {} tokens".format(len(tokens) - len(filtered_tokens)))

    return filtered_tokens

def __markov_chain(raw_text, order):
    assert isinstance(raw_text, str)

    tokens = __tokenize_text_to_words(raw_text)

    transitions = __calculate_transitions(tokens, order=order)
    probs = __calculate_probabilities(transitions)

    return probs


def __calculate_transitions(tokens, order):
    assert isinstance(order, int)
    assert order >= 1
    assert isinstance(tokens, list)

    transitions = {}
    for i in range(len(tokens) - order):
        pred = tokens[i:i + order]

        if order > 1:  # converting the predecessor list to an immutable hashable tuple which can be used as dict keys (list can't be because they do not have this property)
            pred = tuple(pred)
        else:
            pred = str(pred[0])

        succ = tokens[i + order]

        if pred not in transitions:
            # Predecessor key is not yet in the outer dictionary, so we create
            # a new dictionary for it.
            transitions[pred] = {}

        if succ not in transitions[pred]:
            # Successor key is not yet in the inner dictionary, so we start
            # counting from one.
            transitions[pred][succ] = 1.0
        else:
            # Otherwise we just add one to the existing value.
            transitions[pred][succ] += 1.0

    return transitions

def __calculate_totals(transitions):
    totals = {}
    for pred, succ_counts in transitions.items():
        totals[pred] = sum(succ_counts.values())

    return totals

def __tokenize_text_to_words(raw_text):
    text_without_multiple_whitespaces = re.sub(r'\s+', ' ', raw_text)

    # Tokenize the text into words.
    sentences = nltk.sent_tokenize(text_without_multiple_whitespaces)

    # Tokenize each sentence to words. Each item in 'words' is a list with
    # tokenized words from that list.
    tokenized_sentences = []
    for s in sentences:
        w = nltk.word_tokenize(s)
        tokenized_sentences.append(w)

    return utilities.flatten(tokenized_sentences)

def __calculate_probabilities(transitions):
    '''
    Compute the probability for each successor given the predecessor.

    :param transitions: The dictionary of state transition occurrences, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type transitions: dict
    :param totals:
    :type totals: dict
    :return: The dictionary of state transition probabilities, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :rtype: dict
    '''
    totals = __calculate_totals(transitions)
    probs = {}
    for pred, succ_counts in transitions.items():
        probs[pred] = {}
        for succ, count in succ_counts.items():
            probs[pred][succ] = count / totals[pred]

    return probs