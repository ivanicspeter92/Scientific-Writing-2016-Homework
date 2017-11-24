from ex2 import generate_or_empty_on_throw
from ex3 import evaluate

results = []

for _ in range(0, 50):
    poem = generate_or_empty_on_throw("dinner", "cat", "dog", verbose=False)

    if poem == "":
        pass
    score = evaluate(poem)

    print("Score: {}\n\n{}".format(score, poem))
    print("------")

    results.append((score, poem))