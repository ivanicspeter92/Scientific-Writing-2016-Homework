import ex1
import random
import numpy

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
        current_state = probs2[start] if isinstance(start, tuple) else probs1[start] # KeyError is raised if start is not found
        string_list.append(current_state)
    else:
        current_state = random.sample(probs2.keys(), k = 1)[0] if length >= 2 else random.sample(probs1.keys(), k = 1)[0] # the generation is started from a random state if start is not found
        string_list.extend(current_state)


    while(len(string_list) < length): # The piece of text should be at most length tokens long
        try:
            probabilities = probs2[current_state] if isinstance(current_state, tuple) else probs1[current_state]

            current_state = numpy.random.choice(list(probabilities.keys()), p = list(probabilities.values()))

            if isinstance(current_state, str):
                string_list.append(current_state)
            elif isinstance(current_state, tuple):
                string_list.extend(current_state) # in case of tuples, we append the elements of the list to avoid lists of lists
        except KeyError: # cannot proceed from the state, breaking the loop
            break

    return " ".join(string_list) # concatenate into a single string

probs1 = ex1.markov_chain(ex1.alice, sanitize_text = True, order = 1)
probs2 = ex1.markov_chain(ex1.alice, sanitize_text = True, order = 2)

generate2(probs1, probs2, 30)