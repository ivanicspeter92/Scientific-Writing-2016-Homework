import ex4

def likelihood(text, state_transitions_probabilities):
    '''
    Computes the (pseudo)likelihood of the text using the state transition probabilities. If some of the tokens (or state transitions) derived from text are not in `state_transition_probabilities`, the function raises an error.

    :param text: The raw text to analyze.
    :type text: str
    :param state_transition_probabilities: The dictionary of state transition probabilities, where the keys of the dictionary are tokens and the values are (str, float) paired array of values
    :type state_transition_probabilities: dict
    :return: The likelihood of the raw text to be generated based on the values in the provided `state_transition_probabilities`
    :rtype: float
    '''
    assert isinstance(text, str)

    words = ex4.tokenize_text_to_words(" ".join(ex4.sanitize(text)))
    result = len(list(filter(lambda x: x == words[0], state_transitions_probabilities.keys()))) / len(state_transitions_probabilities) # calculate initial by first_word_count / all_word_count

    for i in range(len(words) - 1):
        current_word = words[i]
        next_word = words[i + 1]
        next_probability = state_transitions_probabilities[current_word][next_word]

        result = result * next_probability
    return result

likelihood(text = "Alice went to shop", state_transitions_probabilities = ex4.markov_chain(ex4.alice))