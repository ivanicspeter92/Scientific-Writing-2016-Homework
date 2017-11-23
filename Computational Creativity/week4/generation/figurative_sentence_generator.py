from .therex import TheRex
import random

def generate_figurative_sentences(target_noun, template):
    '''
    Creates figurative sentences from the given target noun.
    :param target_noun: The target noun to generate the sentence from.
    :type target_noun: str
    :param template: The template for the figurative sentence as a string. NOTE: the string must contain the following substrings: {TARGET}, {PROP} and {SOURCE}
    :type template: str
    :return: The figurative sentences as a list of strings.
    :rtype: list

    :exception: KeyError if the given target noun is incorrect (e.g. not a noun or unrecognized value)
    :exception AssertionError If the template does not contain one of the required substrings.
    '''
    assert "{TARGET}" in template.upper()
    assert "{PROP}" in template.upper()
    assert "{SOURCE}" in template.upper()

    therex_members = TheRex().member(target_noun)

    categories = therex_members["categories"]
    categories = list(categories.items())  # converting the dictionary to a list of tuples
    categories = sorted(categories, key=lambda x: x[1], reverse=True)  # sort to descending list

    sentences = list(map(lambda category: __get_figurative_sentence(target_noun, category, template), categories))
    return sentences

def generate_figurative_sentence_from_multiple(target_nouns, template):
    while len(target_nouns) > 0:
        noun = random.choice(target_nouns)
        try:
            return generate_figurative_sentences(noun, template)
        except:
            target_nouns.remove(noun)
            pass
    return None

def __get_property_and_source(category):
    property, source = category[0].split(":")

    return property, source

def __get_figurative_sentence(target_noun, category, template):
    property, source = __get_property_and_source(category)
    sentence = template.format(TARGET = target_noun, PROP = property, SOURCE = source)

    return sentence