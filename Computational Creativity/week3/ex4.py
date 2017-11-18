import week3.ex2 as ex2
from week3 import factgen
import random
import numpy

'''
Flattens a list of lists
'''
flatten = lambda l: [item for sublist in l for item in sublist]

def markov_chain(tokens, order = 1):
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

    transitions = calculate_transitions(tokens, order)
    probs = calculate_probabilities(transitions)

    return probs

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

def generate2(probs1, probs2, length=10, start=None):
    '''
    Generates a `length` word long text based on the given `state_transition_probabilities`.

    :param probs1: The dictionary of state transition probabilities for the 1st order Markov chain, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type probs1: dict
    :param probs2: The dictionary of state transition probabilities for the 2nd order Markov chain, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type probs2: dict
    :param length: The length of the output to be generated in terms of tokens. Defaults to 10.
    :type length: int
    :param start: The token to start the text generation from. An exception is raised if the token is not found as a key in `state_transition_probabilities`. Defaults to None, in which case a random state is selected initially.
    :type start: str or tuple
    :return: The string of the generated text.
    :rtype: str
    '''
    assert isinstance(length, int)
    assert length >= 1

    string_list = []

    if start is not None:
        current_state = start
        if isinstance(current_state, tuple):
            # current_state = probs2[start] # KeyError is raised if start is not found
            string_list.extend(current_state)
        else:
            # current_state = probs1[start] # KeyError is raised if start is not found
            string_list.append(current_state)
    else:
        current_state = random.sample(probs2.keys(), k = 1)[0] if length >= 2 else random.sample(probs1.keys(), k = 1)[0] # the generation is started from a random state if start is not found
        string_list.extend(current_state)


    while(len(string_list) < length): # The piece of text should be at most length tokens long
        try:
            # print("State: {}".format(current_state))
            if isinstance(current_state, tuple):
                probabilities = probs2[current_state]
            else:
                probabilities = probs1[current_state]

            current_state = numpy.random.choice(list(probabilities.keys()), p = list(probabilities.values()))

            if isinstance(current_state, str):
                string_list.append(current_state)
            elif isinstance(current_state, tuple):
                string_list.extend(current_state) # in case of tuples, we append the elements of the list to avoid lists of lists
        except KeyError: # cannot proceed from the state, breaking the loop
            break

    return " ".join(string_list) # concatenate into a single string

with open("alice_with_triples.txt", "r", encoding="utf-8") as f:
    data = f.read()
fields = flatten([line.split(" ") for line in data.split("\n") if line])

triples = ex2.generate_from_lhs("dogs", ex2.all_triples)
for t in triples:
    s = " ".join([t[0], t[1], t[2]]).split(" ")

    generated = generate2(markov_chain(fields, order = 1), markov_chain(fields, order = 2), start=(s[-2], s[-1]))
    print("{} {}".format(" ".join(s[0:-2]), generated))