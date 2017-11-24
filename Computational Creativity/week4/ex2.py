import ex1

def generate_poem(*args, **kwargs):
    '''
    Generates a four line poem with the given arguments using the ex1.couplet() function.

    :param args: See the documentation of ex1.couplet
    :type args: tuple
    :param kwargs: See the documentation of ex1.couplet
    :type kwargs: dict
    :return: A four-line poem as a string.
    :rtype: str

    :exception See the documentation of ex1.couplet
    '''
    verbose = kwargs.get("verbose", False)

    if verbose: print("Building 1st part...")
    first_half = ex1.couplet(*args, **kwargs)

    if verbose: print("Building 2nd part...")
    second_half = ex1.couplet(*args, **kwargs)

    return "{}\n{}".format(first_half, second_half)

def generate_or_empty_on_throw(*args, **kwargs):
    try:
        return generate_poem(*args, **kwargs)
    except:
        return ""

# poem = generate_poem("dinner", "cat", "dog", verbose=True)
# print("-----")
# print(poem)
#
# poems = list(map(lambda x: generate_or_empty_on_throw("dinner", "cat", "dog", verbose=True), range(0,50)))