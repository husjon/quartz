#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.pyaml
# Note: replace shebang above with "#!/usr/bin/env python" for non NixOS systems


import yaml
import glob
import os
import re


OBSIDIAN_VAULT_PATH = os.environ.get('OBSIDIAN_VAULT_PATH', '')
if OBSIDIAN_VAULT_PATH == '':
    print("OBSIDIAN_VAULT_PATH not set")
    exit(1)

QUARTZ_VAULT_PATH = os.environ.get('QUARTZ_VAULT_PATH', '')
if QUARTZ_VAULT_PATH == '':
    print("QUARTZ_VAULT_PATH not set")
    exit(1)

QUARTZ_PATH = os.environ.get('QUARTZ_PATH', '')
if QUARTZ_PATH == '':
    print("QUARTZ_PATH not set")
    exit(1)

QUARTZ_BOOKS_SUMMARY_FILE = f'{QUARTZ_VAULT_PATH}/Books.md'
BOOKS_FOLDER = f'{OBSIDIAN_VAULT_PATH}/99. External data/Goodreads Sync/'


frontmatter_pattern = re.compile(r'''
---\n
(?P<content>
(.*?|\n)+
title:
(.*?|\n)+
tags:
(.*?|\n)+
)
---\n
''', flags=re.VERBOSE)

books = []
for book in sorted(glob.glob(f'{BOOKS_FOLDER}/*.md')):
    with open(f'{book}', 'r') as f:
        content = f.read()

    match = re.match(pattern=frontmatter_pattern, string=content)
    frontmatter_content = match.groupdict().get('content')

    book_frontmatter = yaml.safe_load(frontmatter_content)

    books.append(book_frontmatter)


with open(QUARTZ_BOOKS_SUMMARY_FILE, 'w+') as fh:
    output = [
        '---',
        'title: Books',
        'tags: books',
        'publish: true',
        '---',
        '',
    ]
    output.append('| Title | Author | My rating | Read (Year-Month-Day) |')
    output.append('| ----- | ------ | --------- | ---- |')
    for book in books:
        if "currently-reading" in book['tags']:
            book['date_read'] = 'Currently Reading'
        else:
            book['date_read'] = book['date_read'].strftime('%Y-%m-%d')

        output.append(
            '| {title:<60} | {author:<30} | {rating} | {date_read:<10} |'
            .format(**book)
        )

    fh.write('\n'.join(output))

    print(f'Updated {QUARTZ_BOOKS_SUMMARY_FILE}')
