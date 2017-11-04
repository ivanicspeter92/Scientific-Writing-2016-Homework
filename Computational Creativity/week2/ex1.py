import os
import re
import nltk

'''
Flattens a list of lists
'''
flatten = lambda l: [item for sublist in l for item in sublist]

def markov_chain(tokens, sanitize_text = True, order = 1):
    '''
    Returns the state-transition probabilities generated from the given list of tokens
    :param tokens: The list of tokens to generate the Markov chain from
    :type tokens: list
    :param sanitize_text: A boolean determining if the list of tokens should be further sanitized. Defaults to True
    :type sanitize_text: bool
    :param order: The order of the markov chain. Should be greater than or equal to 1. Defaults to 1.
    :type order: int
    :return: The dictionary of state transition probabilities, where the keys of the dictionary are tokens and the values are (str, float) [for the 1st order chain] or (tuple, float) [for the higher order chains] paired array of values
    :rtype: dict
    '''
    assert isinstance(tokens, list)
    while any(isinstance(element, list) for element in tokens): # check if the tokens are lists of lists
        tokens = flatten(tokens)

    if sanitize_text:
        tokens = sanitize(tokens)

    transitions = calculate_transitions(tokens, order)
    probs = calculate_probabilities(transitions)

    return probs

def read_alice():
    # Download Alice's Adventures in Wonderland if it is not yet present
    alice_file = 'alice.txt'
    alice_raw = None

    if not os.path.isfile(alice_file):
        from urllib import request
        url = 'http://www.gutenberg.org/cache/epub/19033/pg19033.txt'
        response = request.urlopen(url)
        alice_raw = response.read().decode('utf8')
        with open(alice_file, 'w', encoding='utf8') as f:
            f.write(alice_raw)
    else:
        with open(alice_file, 'r', encoding='utf8') as f:
            alice_raw = f.read()

    # Remove the start and end bloat from Project Gutenberg (this is not exact, but
    # easy).
    pattern = r'\*\*\* START OF THIS PROJECT GUTENBERG EBOOK .+ \*\*\*'
    end = "End of the Project Gutenberg"
    start_match = re.search(pattern, alice_raw)
    if start_match:
        start_index = start_match.span()[1] + 1
    else:
        start_index = 0
    end_index = alice_raw.rfind(end)
    alice = alice_raw[start_index:end_index]

    # And replace more than one subsequent whitespace chars with one space
    alice = re.sub(r'\s+', ' ', alice)

    # Tokenize the text into sentences.
    sentences = nltk.sent_tokenize(alice)

    # Tokenize each sentence to words. Each item in 'words' is a list with
    # tokenized words from that list.
    tokenized_sentences = []
    for s in sentences:
        w = nltk.word_tokenize(s)
        tokenized_sentences.append(w)

    # Next, we sanitize the 'words' somewhat. We remove all tokens that do not have
    # any Unicode word characters, and force each sentence's last token to '.'.
    # You can try other sanitation methods (e.g. look at the last sentence).
    is_word = re.compile('\w')
    sanitized_sentences = []
    for sent in tokenized_sentences:
        sanitized = [token for token in sent if is_word.search(token)] + ['.']
        sanitized_sentences.append(sanitized)
    return sanitized_sentences

def calculate_transitions(tokens, order):
    assert isinstance(order, int)
    assert order >= 1
    assert isinstance(tokens, list)

    transitions = {}
    for i in range(len(tokens) - order):
        pred = tokens[i:i+ order]

        if order > 1: # converting the predecessor list to an immutable hashable tuple which can be used as dict keys (list can't be because they do not have this property)
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

def calculate_totals(transitions):
    totals = {}
    for pred, succ_counts in transitions.items():
        totals[pred] = sum(succ_counts.values())

    return totals

def calculate_probabilities(transitions):
    '''
    Compute the probability for each successor given the predecessor.

    :param transitions: The dictionary of state transition occurrences, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type transitions: dict
    :param totals:
    :type totals: dict
    :return: The dictionary of state transition probabilities, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :rtype: dict
    '''
    totals = calculate_totals(transitions)
    probs = {}
    for pred, succ_counts in transitions.items():
        probs[pred] = {}
        for succ, count in succ_counts.items():
            probs[pred][succ] = count / totals[pred]

    return probs

def sanitize(token_list, stopword_list = []):
    '''
    Sanitizes the token list with the given list of stopwords. If the token_list is a string, it is converted into a list of words.
    :param token_list: the list of tokens to sanitize
    :type token_list: list
    :param stopword_list: the list of stopwords to remove
    :type stopword_list: list
    :return:
    :rtype:
    '''
    if isinstance(stopword_list, list) == False or len(stopword_list) == 0: # defaulting back to english dictionary if wrong parameters are given
        stopword_list = open('english_stopwords.txt', 'r').read().splitlines()

    tokens_not_in_stopwords = list(filter(lambda x: len(x) != 0 and x not in stopword_list, token_list))  # filtering out tokens that are not in the stopword list and are empty strings
    return tokens_not_in_stopwords

alice = read_alice()
probs = markov_chain(alice, sanitize_text = True, order = 1)