def evaluate(poem, *args, **kwargs):
    '''
    Evaluates the poem by using the following evaluation criteria:
        - does the poem contain exactly 4 lines?
        - do the

    :param poem: The four-line poem as a string to be evaluated.
    :type poem: str
    :param args:
    :type args: tuple
    :param kwargs: The list of optional arguments as described below.
        line_separator_character: The character which separates the lines in the poem string. Defaults to "\n"
    :type kwargs: dict
    :return: The score of the poem on the range of [0, 1]
    :rtype: float
    '''
    line_separator_character = kwargs.get("line_separator_character", "\n")
