import random

from generation import factgen, figurative_sentence_generator, made_up_fact_generator, rhyming_pair_chooser, tostringconverter, utilities

from generation import markov_chain_generator


def couplet(*args, **kwargs):
    '''
    Produces two lines of a poem and returns it to the caller.

    :param args: A tuple of strings as concepts/topics to use for the generation. All of the values in the tuple are going to be used for generating a couplet, but not necessarily appear in the final result. If the string is invalid or cannot be found in the system in any way, the string is skipped during the generation.
    :type args: tuple
    :param kwargs: The list of optional arguments as described below.
        max_line_length: The length of the lines in characters. Must be an integer greater than 100. Defaults to 100.
        triples_input_path: The path to the input triples file. Defaults to reverb.txt. Throws FileNotFoundException if
        uses_reverb_triple_format: A bool indicating if the input triples should be read as reverb triples. If set to false, the input file is assumed to be in (lhs, predicate, rhs) format on every line. Defaults to true.
        min_attested: An integer indicating the min attested filter for filtering the triples in the reverb format. Has no effect if the uses_reverb_format is set to False. Defaults to 2.
        figurative_sentence_template: The template for the figurative sentences. NOTE: the string must contain the following substrings: {TARGET}, {PROP} and {SOURCE}. Defaults to "{SOURCE} is as {PROP} as {TARGET}".
        corpus: The path to the books downloaded from Project Gutenberg which form the core of the Markov chain corpus. Must be a list of strings. Defaults to ["knowledge_base/books/alice.txt", "knowledge_base/books/grimms_fairy_tales.txt"].
        markov_chain_order: The order of the markov chain to be used. Must be an integer higher than 0. Defaults to 1.
        verbose: Provide more output on the screen. Defaults to False.
    :type kwargs: dict
    :return: A list of strings that are the lines of the composed poem.
    :rtype: list

    :exception: AssertionError if the max_line_length parameter is not an integer or is less than 20.
    :exception: FileNotFoundException if the given file on `triples_input_path` is not found.
    :exception: IndexError if the file on the given path has been found but its format was incorrect: (lhs, predicate, rhs) on every line.
    :exception AssertionError If the figurative sentence template does not contain one of the required substrings or is incorrect.
    :exception: FileNotFoundException if the text files for the Markov chain generation (defined by corpus) are not found.
    '''
    verbose = kwargs.get("verbose", False)
    if verbose: print("couplet() called with parameters:\n args: {}\n kwargs: {}".format(args, kwargs))

    max_line_length = kwargs.get("max_line_length", 100)
    assert isinstance(max_line_length, int) and max_line_length >= 100
    triples_input_path = kwargs.get("triples_input_path", "knowledge_base/reverb.txt")
    uses_reverb_triple_format = kwargs.get("uses_reverb_triple_format", True)
    min_attested = kwargs.get("min_attested", 2)
    figurative_sentence_template = kwargs.get("figurative_sentence_template", "{SOURCE} is as {PROP} as {TARGET}")
    corpus = kwargs.get("corpus", ["knowledge_base/books/alice.txt", "knowledge_base/books/grimms_fairy_tales.txt"])
    markov_chain_order = kwargs.get("markov_chain_order", 1)

    if verbose: print("Parameters parsed successfully")

    if verbose: print("Loading triples from {}".format(triples_input_path))
    triples = __read_triples(path=triples_input_path, uses_reverb_triple_format=uses_reverb_triple_format,min_attested=min_attested)
    if verbose: print("Successfully loaded {} triples".format(len(triples)))

    if verbose: print("Generating Markov model from {}".format(corpus))
    markov_model = markov_chain_generator.generate_markov_model(corpus, order = markov_chain_order, verbose = verbose)
    if verbose: print("Markov model loaded from {} sentences".format(len(markov_model.parsed_sentences)))

    if verbose: print("Generating couplet...")
    couplet = __generate_couplet(topics=args, triples=triples, markov_model=markov_model, figurative_sentence_template=figurative_sentence_template, max_line_length=max_line_length, verbose=verbose)
    if verbose: print("Couplet generated")

    return couplet

def __generate_couplet(topics, triples, markov_model, figurative_sentence_template, max_line_length, verbose):
    if verbose: print("Generating couplet for {}".format(topics))

    #repository = list(map(lambda t: __gather_facts_and_sentences(topic=t, triples=triples, figurative_sentence_template=figurative_sentence_template, verbose=verbose), topics))

    if verbose: print("Creating 1st line...")

    made_up_facts = list(map(lambda t: __gather_facts(topic=t, triples=triples, verbose=verbose), topics))
    made_up_facts = utilities.flatten(made_up_facts)

    fact = tostringconverter.format_made_up_fact(random.choice(made_up_facts))
    markov_text = markov_model.make_short_sentence(max_chars=(max_line_length - len(fact)), init_state=(random.choice(topics),))
    markov_text = tostringconverter.format_markov_chain_sentence(markov_text)
    first_line = " ".join([fact, markov_text])

    #----#
    if verbose: print("Creating 2nd line...")

    targets = rhyming_pair_chooser.get_rhyming_noun_pairs_from_line(first_line)
    if len(targets) == 0: # if no rhymes were found for the last word of the first line, fallback to the one of the originally given topics
        targets = topics

    figurative_sentences = __gather_sentences(targets, template=figurative_sentence_template, verbose=verbose)
    figurative_sentence = random.choice(figurative_sentences)

    markov_text = None
    while markov_text is None:
        markov_text = markov_model.make_short_sentence(max_chars=(max_line_length - len(figurative_sentence)), init_state=(random.choice(topics),))

    markov_text = tostringconverter.format_markov_chain_sentence(markov_text)
    second_line = " ".join(list(filter(lambda x: x is not None, [markov_text, figurative_sentence])))

    return "{}\n{}".format(first_line, second_line)

def __gather_facts(topic, triples, verbose):
    made_up_facts = made_up_fact_generator.generate_from_lhs(topic, triples)
    if verbose: print("Generated {} made up facts".format(len(made_up_facts)))

    return made_up_facts

def __gather_sentences(topic, template, verbose):
    if verbose: print("Gathering sentences from topic {} using template {}".format(topic, template))
    figurative_sentences = figurative_sentence_generator.generate_figurative_sentence_from_multiple(target_nouns=topic, template=template)
    if verbose: print("Generated {} figurative sentences".format(len(figurative_sentences)))

    return figurative_sentences

def __gather_facts_and_sentences(topic, triples, figurative_sentence_template, verbose):
    if verbose: print("Gathering facts and sentences for {}".format(topic))

    made_up_facts = __gather_facts(topic, triples, verbose)
    figurative_sentences = __gather_sentences(topic, figurative_sentence_template, verbose)

    return made_up_facts, figurative_sentences

def __read_triples(path, uses_reverb_triple_format, min_attested):
    if uses_reverb_triple_format:
        all_triples = factgen.read_triples(path, min_attested=min_attested)
    else:
        all_triples = utilities.read_triples_file(path)

    return all_triples

c = couplet("dinner", "cat", "dog", verbose=True)
# print("----")
# print(c)

#markov_model = markov_chain_generator.generate_markov_model(["books/alice.txt", "books/grimms_fairy_tales.txt"], order = 1)
# figurative_sentence_generator.generate_figurative_sentences("me", "{SOURCE} is as {PROP} as {TARGET}")
#s = __gather_sentences(rhyming_pair_chooser.get_rhyming_noun_pairs("like"), template="{SOURCE} is as {PROP} as {TARGET}", verbose=True)