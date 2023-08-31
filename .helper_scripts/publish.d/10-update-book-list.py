#!/usr/bin/env python

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

    kv_pattern = r'^(?P<key>.*?): "?(?P<value>.*?)"?$'

    book_frontmatter = dict()
    for kv_match in re.finditer(pattern=kv_pattern, string=frontmatter_content, flags=re.MULTILINE):
        key, value = kv_match.groups()
        if key == 'tags':
            value = value.replace(', ]', ']').replace('[', '').replace(']', '')
            value = value.split(', ')
        book_frontmatter[key] = value

    books.append(book_frontmatter)


with open(quartz_books_summary_file, 'w+') as fh:
    output = [
        '---',
        'title: "Books"',
        'tags: books',
        '---',
        '',
    ]
    output.append(f'| Title | Author | My rating | Read |')
    output.append(f'| ----- | ------ | --------- | ---- |')
    for book in books:
        if "currently-reading" in book['tags']:
            book['date_read'] = 'Currently Reading'
        output.append('| {title:<60} | {author:<30} | {rating} | {date_read:<10} |'.format(**book))

    fh.write('\n'.join(output))