import re

def evaluate_vowel_and_consonant_ratio(lines):
    poem = " ".join(lines)
    vowels = count_vowels(poem)
    consonants = count_consonants(poem)

    ratio = vowels / consonants if vowels < consonants else consonants / vowels

    return ratio

def count_vowels(string):
    vowels = re.findall('[aeiou]', string, re.IGNORECASE)
    return len(vowels)

def count_consonants(string):
    consonants = re.findall('[bcdfghjklmnpqrstvwqxz]', string, re.IGNORECASE)
    return len(consonants)