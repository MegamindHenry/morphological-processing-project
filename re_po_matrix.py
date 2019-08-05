import csv
import json
import numpy as np

data = []
warning_data = []
num_1 = 0
num_2 = 0
num_3_more = 0

with open('data/char_dict2.1.txt', 'r', encoding='utf8') as fp:
    header = fp.readline().strip().split()
    print(header)

    for line in fp:
        row = {}
        parts = line.strip().split()

        for i, part in enumerate(parts):
            row[header[i]] = part

        data.append(row)

re_po_data = []
re_po = set()

for x in data:
    warning = {}
    re_po_row = {}

    if x['Com3'] != 'NA':
        num_3_more += 1
        continue

    if x['Str'] == 'SG':
        num_1 += 1

        if x['Com2'] != 'NA':
            warning = {
                'Conflict': 'SG_Str_but_with_more_than_1_comp',
                'Cha': x['Cha']
            }
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Cha'] + '_S',
                'Com2': 'NA',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
            warning_data.append(warning)

            re_po.add(x['Cha'] + '_S')
        elif x['Com1'] == 'NA':
            warning = {
                'Conflict': 'SG_Str_but_not_comp1',
                'Cha': x['Cha']
            }
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Cha'] + '_S',
                'Com2': 'NA',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
            warning_data.append(warning)

            re_po.add(x['Cha'] + '_S')
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_S',
                'Com2': 'NA',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }

            re_po.add(x['Com1'] + '_S')

        re_po_data.append(re_po_row)

    if x['Str'] == 'UD':
        num_2 += 1

        if x['Com2'] == 'NA' or x['Com1'] == 'NA':
            warning = {
                'Conflict': 'UD_but_missing_com',
                'Cha': x['Cha']
            }
            warning_data.append(warning)
            continue
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_U',
                'Com2': x['Com2'] + '_D',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
        re_po_data.append(re_po_row)

        re_po.add(x['Com1'] + '_U')
        re_po.add(x['Com2'] + '_D')

    if x['Str'] == 'LR':
        num_2 += 1

        if x['Com2'] == 'NA' or x['Com1'] == 'NA':
            warning = {
                'Conflict': 'UD_but_missing_com',
                'Cha': x['Cha']
            }
            warning_data.append(warning)
            continue
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_L',
                'Com2': x['Com2'] + '_R',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
        re_po_data.append(re_po_row)

        re_po.add(x['Com1'] + '_L')
        re_po.add(x['Com2'] + '_R')

    if x['Str'] == 'CIR':
        num_2 += 1

        if x['Com2'] == 'NA' or x['Com1'] == 'NA':
            warning = {
                'Conflict': 'UD_but_missing_com',
                'Cha': x['Cha']
            }
            warning_data.append(warning)
            continue
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_O',
                'Com2': x['Com2'] + '_I',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
        re_po_data.append(re_po_row)

        re_po.add(x['Com1'] + '_O')
        re_po.add(x['Com2'] + '_I')

    if x['Str'] == 'HCI':
        num_2 += 1

        if x['Com2'] == 'NA' or x['Com1'] == 'NA':
            warning = {
                'Conflict': 'UD_but_missing_com',
                'Cha': x['Cha']
            }
            warning_data.append(warning)
            continue
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_A',
                'Com2': x['Com2'] + '_B',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
        re_po_data.append(re_po_row)

        re_po.add(x['Com1'] + '_A')
        re_po.add(x['Com2'] + '_B')

    if x['Str'] == 'LRB':
        num_2 += 1

        if x['Com2'] == 'NA' or x['Com1'] == 'NA':
            warning = {
                'Conflict': 'UD_but_missing_com',
                'Cha': x['Cha']
            }
            warning_data.append(warning)
            continue
        else:
            re_po_row = {
                'Cha': x['Cha'],
                'Com1': x['Com1'] + '_X',
                'Com2': x['Com2'] + '_Y',
                'Com3': 'NA',
                'Com4': 'NA',
                'Com5': 'NA'
            }
        re_po_data.append(re_po_row)

        re_po.add(x['Com1'] + '_X')
        re_po.add(x['Com2'] + '_Y')

print('Number of 1 Comp: {}\n'.format(str(num_1)))
print('Number of 2 Comp: {}\n'.format(str(num_2)))
print('Number of 3 and more Comp: {}\n'.format(str(num_3_more)))

with open('data/re_po_data.csv', 'w+', encoding='utf8') as fp:
    writer = csv.DictWriter(fp, fieldnames=['Cha',
                                            'Com1_Po',
                                            'Com2_Po',
                                            'Com3_Po',
                                            'Com4_Po',
                                            'Com5_Po'])
    fp.write('{}, {}, {}, {}, {}, {}\n'.format('Cha',
                                               'Com1_Po',
                                               'Com2_Po',
                                               'Com3_Po',
                                               'Com4_Po',
                                               'Com5_Po'))

    for x in re_po_data:
        fp.write('{}, {}, {}, {}, {}, {}\n'.format(x['Cha'],
                                                   x['Com1'],
                                                   x['Com2'],
                                                   x['Com3'],
                                                   x['Com4'],
                                                   x['Com5']))


with open('warning/re_po_sg_more_com.csv', 'w+', encoding='utf8') as fp:
    writer = csv.DictWriter(fp, fieldnames=['Cha', 'Conflict'])
    writer.writeheader()
    for data in warning_data:
        writer.writerow(data)

num_re_po = len(re_po)
num_data = len(re_po_data)
print('Number of unique redical with position: {}\n'.format(num_re_po))

re2int = dict({x: i for i, x in enumerate(re_po)})
int2re = dict({i: x for i, x in enumerate(re_po)})

result = np.zeros((num_data, num_re_po), dtype=int)

for i, x in enumerate(re_po_data):
    result[i][re2int[x['Com1']]] = 1
    if x['Com2'] != 'NA':
        result[i][re2int[x['Com2']]] = 1


header_re_po = ',Cha'
for i in range(num_re_po):
    header_re_po += ',{}'.format(int2re[i])


np.savetxt('data/chars_re_po.csv',
           result.astype(int), fmt='%i' , delimiter=',',
           header=header_re_po, encoding='utf8', comments='')


re_po_file = open('data/chars_re_po.csv', 'w+', encoding='utf8')

