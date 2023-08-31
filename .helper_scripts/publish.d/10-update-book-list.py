#!/usr/bin/env python

import datetime
import yaml
import glob
import os
import re

HOME=os.environ.get('HOME')
quartz_content_folder=os.environ.get('QUARTZ_FOLDER') + '/content'
obsidian_vault_folder=os.environ.get('OBSIDIAN_VAULT_FOLDER')
quartz_books_summary_file = f'{quartz_content_folder}/Books.md'
books_folder = f'{obsidian_vault_folder}/Books'

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
#for book in sorted(glob.glob('*.md', root_dir=books_folder)):
for book in sorted(glob.glob(f'{books_folder}/*.md')):
    with open(f'{book}', 'r') as f:
        content = f.read()

    match = re.match(pattern=frontmatter_pattern, string=content)
    frontmatter_content = match.groupdict().get('content')

    book_frontmatter = yaml.safe_load(frontmatter_content)

    books.append(book_frontmatter)


with open(quartz_books_summary_file, 'w+') as fh:
    output = [
        '---',
        'title: "Books"',
        'tags: books',
        '---',
        '',
    ]
    output.append(f'| Title | Author | My rating | Read (Year-Month-Day) |')
    output.append(f'| ----- | ------ | --------- | ---- |')
    for book in books:
        if "currently-reading" in book['tags']:
            book['date_read'] = 'Currently Reading'
        else:
            book['date_read'] = book['date_read'].strftime('%Y-%m-%d')

        output.append('| {title:<60} | {author:<30} | {rating} | {date_read:<10} |'.format(**book))


    fh.write('\n'.join(output))
