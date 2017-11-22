import factgen
import random

def generate_from_lhs(lhs, all_triples, sort_result = True):
    known_facts = list(filter(lambda x: x[0] == lhs, all_triples)) # selecting all triples where lhs is the same as the given parameter
    known_relation_entity_combinations = list(filter(lambda x: x[1] in set(map(lambda x: x[1], known_facts)), all_triples)) # selecting all triples where the relation and the rhs side is in the known_facts list

    relation_probabilities = calculate_relation_probabilities(known_facts, all_triples) # calculating (p(r|X))
    entity_relation_probabilities = calculate_entity_relation_probabilities(known_relation_entity_combinations, all_triples) # calculating p(Y|r)

    new_facts = generate_new_facts(relation_probabilities, entity_relation_probabilities) # generating new facts
    new_facts = list(map(lambda x: x + (calculate_score(x, all_triples),), new_facts))  # calculating scores

    if sort_result:
        return sorted(new_facts, key=lambda x: x[3], reverse=True)
    else:
        return new_facts

def calculate_relation_probabilities(known_facts, all_triples, sort_result = True):
    '''
    Calculates p(r|X) for the given facts

    :param known_facts: The facts for which the p(r|X) probability should be calculated.
    :type known_facts: list of tuples of format (lhs, relation)
    :param all_triples: The list of all triples
    :type all_triples: list of tuples of format (lhs, relation, rhs)
    :param sort_result: A boolean indicating if the results should be sorted by score (descending)
    :type sort_result: bool
    :return: The probability of (r|X) for all possible combinations of the input
    :rtype: list of tuples of format (lhs, relation, score)
    '''
    relation_probabilities = []
    for lhs, relation in set(map(lambda x: (x[0], x[1]), known_facts)):
        facts_with_relation = list(filter(lambda x: x[0] == lhs and x[1] == relation, all_triples))

        relation_probabilities.append((lhs, relation, len(facts_with_relation) / len(all_triples)))

    if sort_result:
        return sorted(relation_probabilities, key=lambda x: x[2], reverse=True)  # sorting result
    else:
        return relation_probabilities

def calculate_entity_relation_probabilities(known_relation_entity_combinations, all_triples, sort_result = True):
    '''
    Calculates p(Y|r) for the given facts

    :param known_relation_entity_combinations:
    :type known_relation_entity_combinations:
    :param all_triples: The list of all triples
    :type all_triples: list of tuples of format (lhs, relation, rhs)
    :param sort_result: A boolean indicating if the results should be sorted by score (descending)
    :type sort_result: bool
    :return: The probability of (Y|r) for all possible combinations of the input
    :rtype: list of tuples of format (lhs, relation, score)
    '''
    entity_relation_probabilities = []
    for relation, rhs in set(map(lambda x: (x[1], x[2]), known_relation_entity_combinations)):
        facts_with_entity = list(filter(lambda x: x[1] == relation and x[2] == rhs, all_triples))

        entity_relation_probabilities.append((relation, rhs, len(facts_with_entity) / len(all_triples)))

    if sort_result:
        return sorted(entity_relation_probabilities, key=lambda x: x[1], reverse=True)
    else:
        return entity_relation_probabilities

def generate_new_facts(lhs_and_relation, relation_and_rhs):
    result = []
    for lhs, relation, lhs_value in lhs_and_relation:
        for relation, rhs, rhs_value in list(filter(lambda x: x[0] == relation, relation_and_rhs)):
            result.append((lhs, relation, rhs))

    return result

def calculate_score(fact, all_triples):
    '''
    Calculates the score of the given fact from the list of all triples.

    :param fact: The triple for which the probability should be calculated.
    :type fact: (lhs, relation, rhs)
    :param all_triples: The list of all triples
    :type all_triples: list of tuples of format (lhs, relation, rhs)
    :return: The original fact tuple and its score appended as the last parameter.
    :rtype: (lhs, relation, rhs, score)
    '''
    return len(list(filter(lambda x: x == fact, all_triples))) / len(all_triples)