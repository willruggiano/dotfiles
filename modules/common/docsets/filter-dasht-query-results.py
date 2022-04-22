import sys

# LOL. This makes we want to vomit.

i = 0
item = ""
items = []
for line in sys.stdin:
    if i == 0:
        item += line.replace("name = ", "").replace("\n", " ")
        i += 1
    elif i == 1:
        i += 1
    elif i == 2:
        i += 1
    else:
        item += line.replace("url = ", "").replace("\n", " ")
        items.append(item)
        i = 0
        item = ""

print("\n".join(items))
