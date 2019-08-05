import csv
import numpy as np


def process_hog(hog_str):
    hog_f = hog_str.replace('H', '').split('_')
    hog_f = [int(x) for x in hog_f]
    return hog_f


data = []

with open('data/chars_hog.csv', 'r', encoding='utf8') as fp:
    reader = csv.DictReader(fp)
    for row in reader:
        data.append(dict(row))

result = np.zeros((len(data), 4800), dtype=int)

for i, a in enumerate(data):
    hog = process_hog(a['Hog'])
    for j in hog:
        result[i][j-1] = 1

np.savetxt('data/chars_hog_feature.csv', result.astype(int), fmt='%i' , delimiter=',')

hog_file = open('data/chars_hog_feature.csv', 'r', encoding='utf8')
hog_clean_file = open('data/chars_hog_matrix.csv', 'w+', encoding='utf8')

header = ''
for i in range(4800):
    header += ',H{}'.format(str(i+1))
header += '\n'

hog_clean_file.write(header)

for i, line in enumerate(hog):
    line_new = data[i]['Cha'] + ', ' + line
    hog_clean_file.write(line_new)

hog_file.close()
hog_clean_file.close()
