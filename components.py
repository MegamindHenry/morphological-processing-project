import csv

with open('dict_new.csv', 'r', encoding='utf8') as fp:
    header = fp.readline().strip().split()
    print(header)
