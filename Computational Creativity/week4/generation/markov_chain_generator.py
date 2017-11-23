from generation import utilities
import markovify
from nltk import word_tokenize
import string
import string

import markovify
from nltk import word_tokenize

from generation import utilities


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

    model = markovify.Text(" ".join(filtered_tokens), state_size=order)
    
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