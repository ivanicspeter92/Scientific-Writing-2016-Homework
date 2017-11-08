import ex3
import random
from therex import TheRex

target = random.choice(ex3.nouns)
# target = ex3.nouns[0]
# target = ex3.nouns[len(ex3.nouns) - 1]

therex_members = TheRex().member(target)
categories = therex_members["categories"]
categories = list(categories.items()) # converting the dictionary to a list of tuples
categories = sorted(categories, key=lambda x: x[1], reverse=True) # sort to descending list