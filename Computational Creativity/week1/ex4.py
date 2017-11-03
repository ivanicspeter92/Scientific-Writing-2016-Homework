import os
import re
import nltk
from collections import OrderedDict

'''
Flattens a list of lists
'''
flatten = lambda l: [item for sublist in l for item in sublist]

def markov_chain(raw_text, sanitize_text = True):
    assert isinstance(raw_text, str)

    tokens = tokenize_text_to_words(raw_text)

    if sanitize_text:
        tokens = sanitize(token_list=tokens)

    transitions = calculate_transitions(tokens)
    probs = calculate_probabilities(transitions)

    return probs

def read_alice(tokenize_and_sanitize = False):
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

    if tokenize_and_sanitize:
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
    else:
        return sentences

def calculate_transitions(tokens):
    transitions = {}
    for i in range(len(tokens) - 1):
        pred = tokens[i]
        succ = tokens[i + 1]
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

def tokenize_text_to_words(raw_text):
    text_without_multiple_whitespaces = re.sub(r'\s+', ' ', raw_text)

    # Tokenize the text into words.
    sentences = nltk.sent_tokenize(text_without_multiple_whitespaces)

    # Tokenize each sentence to words. Each item in 'words' is a list with
    # tokenized words from that list.
    tokenized_sentences = []
    for s in sentences:
        w = nltk.word_tokenize(s)
        tokenized_sentences.append(w)

    return flatten(tokenized_sentences)

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

def sanitize(token_list, stopword_list = [], remove_punctuation = True):
    '''
    Sanitizes the token list with the given list of stopwords. If the token_list is a string, it is converted into a list of words.
    :param token_list: the list of tokens to sanitize
    :type token_list: list
    :param stopword_list: the list of stopwords to remove
    :type stopword_list: list
    :param remove_punctuation: The flag indicating if punctuation marks should be removed
    :type remove_punctuation: bool
    :return:
    :rtype:
    '''
    if isinstance(token_list, str):
        text_without_multiple_whitespaces = re.sub(r'\s+', ' ', token_list)
        token_list = text_without_multiple_whitespaces.split(" ")
    if isinstance(stopword_list, list) == False or len(stopword_list) == 0: # defaulting back to english dictionary if wrong parameters are given
        stopword_list = open('english_stopwords.txt', 'r').read().splitlines()

        #stopword_list = list(map(lambda x: x.lower(), stopword_list)) # converting all tokens to lowercase

    if remove_punctuation:
        token_list = list(map(lambda x: re.sub(r'[^\w\s]','', x), token_list)) # removing punctuation marks
    tokens_not_in_stopwords = list(filter(lambda x: len(x) != 0 and x not in stopword_list, token_list))  # filtering out tokens that are not in the stopword list and are empty strings
    return tokens_not_in_stopwords

alice = read_alice(tokenize_and_sanitize = False)
alice = "".join(flatten(alice))
probs = markov_chain(alice, sanitize_text=True)