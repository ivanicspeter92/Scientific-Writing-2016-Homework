import ex4 # importing ex4 will import ex3 which prints the generated sentence on the screen
print("------")

template = "{} is as {} as {}" # {TARGET} is as {PROP} as {SOURCE}

for category in ex4.categories:
    property, source = category[0].split(":")
    print(template.format(ex4.target, property, source))