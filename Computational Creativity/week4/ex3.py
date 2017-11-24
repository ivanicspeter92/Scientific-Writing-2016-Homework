from enum import Enum
import numpy as np
from evaluation import vowel_and_consonant_evaluator, line_count_evaluator, rhyme_pattern_evaluator

class EvaluationMeasure(Enum):
    MEAN = "mean"
    MEDIAN = "median"

def evaluate(poem, *args, **kwargs):
    '''
    Evaluates the poem by using the following evaluation criteria:
        - does the poem contain exactly 4 lines?
        - does the poem follow AABB pattern?
        - what is the ratio between the vowels and the consonants of the poem?
        - (not implemented) measure of surprise - are there any unusual words or word pairs on the same line that are not typically used together?
        - (not implemented) POS balance
        - (not implemented) is the poem grammatically correct?

    :param poem: The four-line poem as a string to be evaluated.
    :type poem: str
    :param args:
    :type args: tuple
    :param kwargs: The list of optional arguments as described below.
        line_separator_character: The character which separates the lines in the poem string. Defaults to "\n"
        measure: An EvaluationMeasure indicating what is the measure to calculate the final score. Defaults to EvaluationMeasure.MEAN.
        verbose: Produce more output on the console. Defaults to False.
    :type kwargs: dict
    :return: The score of the poem on the range of [0, 1]
    :rtype: float
    '''
    line_separator_character = kwargs.get("line_separator_character", "\n")
    measure = kwargs.get("measure", EvaluationMeasure.MEAN)
    verbose = kwargs.get("verbose", False)
    scores = []

    lines = poem.split(sep = line_separator_character)

    scores.append(line_count_evaluator.evaluate_line_counts(lines))
    scores.append(rhyme_pattern_evaluator.evaluate_rhyme_pattern(lines))
    scores.append(vowel_and_consonant_evaluator.evaluate_vowel_and_consonant_ratio(lines))

    if verbose: print("Scores: {}".format(scores))

    return __calculate_score(scores, measure)

def __calculate_score(scores_array, measure):

    if measure == EvaluationMeasure.MEDIAN:
        return np.median(scores_array)
    elif measure == EvaluationMeasure.MEAN:
        return np.mean(scores_array)
    else:
        return None