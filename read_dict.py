import csv

data = []
with open('data/char_dict2.1.txt', 'r', encoding='utf8') as fp:
    header = fp.readline().strip().split()
    print(header)

    for line in fp:
        row = {}
        parts = line.strip().split()

        for i, part in enumerate(parts):
            row[header[i]] = part
        data.append(row)

print(data)

with open('dict.csv', 'w+', encoding='utf8') as f:
    writer = csv.DictWriter(f, fieldnames=['Cha',
                                           'SeR',
                                           'SeP',
                                           'PhR',
                                           'PhP',
                                           'xP',
                                           'ToS',
                                           'ReS',
                                           'SeS',
                                           'PhS',
                                           'NoC',
                                           'Com1',
                                           'Com2',
                                           'Com3',
                                           'Com4',
                                           'Com5',
                                           'Py',
                                           'Str',
                                           'Type'])
    f.write('{}, {}, {}, {}, {}, {},'
             ' {}, {}, {}, {}, {}, {},'
             '{}, {}, {}, {}, {}, {}'
             '{}\n'.format('Cha', 'SeR', 'SeP', 'PhR', 'PhP', 'xP',
                           'ToS', 'ReS', 'SeS', 'PhS', 'NoC', 'Com1',
                           'Com2', 'Com3', 'Com4', 'Com5', 'Py', 'Str', 'Type'))

    for x in data:
        f.write('{}, {}, {}, {}, {}, {},'
                 ' {}, {}, {}, {}, {}, {},'
                 '{}, {}, {}, {}, {}, {}'
                 '{}\n'.format(x['Cha'], x['SeR'], x['SeP'], x['PhR'], x['PhP'], x['xP'],
                               x['ToS'], x['ReS'], x['SeS'], x['PhS'], x['NoC'], x['Com1'],
                               x['Com2'], x['Com3'], x['Com4'], x['Com5'], x['Py'], x['Str'], x['Type']))