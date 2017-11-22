def __read_triples_file(path):
    '''
    Parses the file on the given path as a list of triples.
    :param path: The path to the file to read.
    :type path: str
    :return: A list of tuples of format (lhs, predicate, rhs)
    :rtype: list

    :exception: FileNotFoundException if the given file on `triples_input_path` is not found.
    '''
    with open(path, "r", encoding="utf-8") as f:
        data = f.read()
    fields = [line.split("\t") for line in data.split("\n") if line]

    # Make them all lowercase, for ease of querying
    return [(row[0].lower(), row[1].lower(), row[2].lower()) for row in fields] # The LHS, predicate and RHS

'''
Flattens a list of lists
'''
flatten = lambda l: [item for sublist in l for item in sublist]

def get_index(in_list, of_item):
    '''
    Returns the index of a given item in a list.
    :param in_list: The list
    :type in_list: list
    :param of_item: The item to be searched for.
    :type of_item: Any
    :return: The index of the item or none if not found.
    :rtype: int or None
    '''
    for num,row in enumerate(in_list):
        if of_item in row:
            return num