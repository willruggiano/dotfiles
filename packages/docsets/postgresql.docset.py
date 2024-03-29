# https://github.com/drbraden/pgdash
import os
import sqlite3
import re
from bs4 import BeautifulSoup

conn = sqlite3.connect("postgresql.docset/Contents/Resources/docSet.dsidx")
cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS searchIndex;")
cur.execute(
    "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
)
cur.execute("CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);")

docpath = "postgresql.docset/Contents/Resources/Documents"

page = open(os.path.join(docpath, "bookindex.html")).read()
soup = BeautifulSoup(page)

any = re.compile(".*")
for tag in soup.find_all("a", {"href": any}):
    name = tag.text.strip()
    if len(name) > 1:
        path = tag.attrs["href"].strip()
        if path != "index.html":
            cur.execute(
                "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)",
                (name, "func", path),
            )
            print(f"name: {name}, path: {path}")

conn.commit()
conn.close()
