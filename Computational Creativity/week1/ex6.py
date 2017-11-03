import ex4
import random
import numpy

def generate(state_transition_probabilities, length=10, start=None):
    '''
    Generates a `length` word long text based on the given `state_transition_probabilities`.

    :param state_transition_probabilities: The dictionary of state transition probabilities, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type state_transition_probabilities: dict
    :param length: The length of the output to be generated in terms of tokens. Defaults to 10.
    :type length: int
    :param start: The token to start the text generation from. An exception is raised if the token is not found as a key in `state_transition_probabilities`. Defaults to None, in which case a random state is selected initially.
    :type start: str
    :return: The string of the generated text.
    :rtype: str
    '''
    string_list = []

    if start is not None:
        current_state = state_transition_probabilities[start] # KeyError is raised if start is not found
    else:
        current_state = random.sample(state_transition_probabilities.keys(), k = 1)[0] # the generation is started from a random state if start is not found

    string_list.append(current_state)

    while(len(string_list) < length): # The piece of text should be at most length tokens long
        try:
            probabilities = state_transition_probabilities[current_state]

            current_state = numpy.random.choice(list(probabilities.keys()), p = list(probabilities.values()))
            string_list.append(current_state)
        except KeyError: # cannot proceed from the state, breaking the loop
            break

    return " ".join(string_list) # concatenate into a single string

generate(ex4.probs, length=10)