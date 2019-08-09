"""
Matches characters in chars.txt to their bitmap filenames.
"""
import csv

char = []

with open('data/chars.txt', 'r', encoding='utf8') as fp:
    for i, line in enumerate(fp):
        line = line.strip()
        c = {
            'char': line,
            'pic': str(i+1) + 'pic'  # index start from 0
        }
        char.append(c)

with open('data/chars_pic.csv', 'w+', encoding='utf8') as fp:
    writer = csv.DictWriter(fp, fieldnames=['char', 'pic'])
    writer.writeheader()
    for data in char:
        writer.writerow(data)