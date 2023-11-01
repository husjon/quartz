#!/usr/bin/env python

import glob
import os
import re

import yaml

HOME = os.environ.get("HOME")
quartz_content_folder = os.environ.get("QUARTZ_FOLDER") + "/content"
obsidian_vault_folder = os.environ.get("OBSIDIAN_VAULT_FOLDER")
quartz_books_summary_file = f"{quartz_content_folder}/Books.md"
books_folder = f"{obsidian_vault_folder}/Books"

frontmatter_pattern = re.compile(
    r"""
---\n
(?P<content>
(.*?|\n)+
title:
(.*?|\n)+
tags:
(.*?|\n)+
)
---\n
""",
    flags=re.VERBOSE,
)

books = []
# for book in sorted(glob.glob('*.md', root_dir=books_folder)):
for book in sorted(glob.glob(f"{books_folder}/*.md")):
    if "/Books.md" in book:
        continue
    with open(f"{book}", "r", encoding="utf-8") as f:
        content = f.read()

    match = re.match(pattern=frontmatter_pattern, string=content)
    frontmatter_content = match.groupdict().get("content")

    book_frontmatter = yaml.safe_load(frontmatter_content)

    books.append(book_frontmatter)


with open(quartz_books_summary_file, "w+", encoding="utf-8") as fh:
    output = [
        "---",
        'title: "Books"',
        "tags: books",
        "---",
        "",
    ]
    output.append("| Title | Author | My rating | Read (Year-Month-Day) |")
    output.append("| ----- | ------ | --------- | ---- |")
    for book in books:
        if "currently-reading" in book["tags"]:
            book["date_read"] = "Currently Reading"
        else:
            book["date_read"] = book["date_read"].strftime("%Y-%m-%d")

        line = [
            f"{book['title']:<60}",
            f"{book['author']:<30}",
            f"{book['rating']}",
            f"{book['date_read']:<10}",
        ]

        output.append(f"| {' | '.join(line)} |")

    fh.write("\n".join(output))
