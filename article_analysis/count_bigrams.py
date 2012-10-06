import collections
import glob
import os

candidateNames = {}
with open('candidates.txt') as f:
    for line in f:
        id, name = line.strip().split('\t')
        candidateNames[id] = name

bigrams = collections.defaultdict(list)
for filename in glob.glob(os.path.join('candidate_articles', '*.lemmas')):
    localBigrams = collections.defaultdict(int)
    id = os.path.basename(filename).partition('_')[0]

    with open(filename) as f:
        def IsGoodWord(b):
            if len(b) < 2:
                return False
            if len(b[0].decode('utf-8')) < 4:
                return False
            grammemes = b[1]
            forbiddenPOS = ['PART', 'INTJ', 'PR', 'CONJ', 'SPRO']
            return not any(grammemes.startswith(fp) for fp in forbiddenPOS)
        words = filter(IsGoodWord, [line.strip().split('\t') for line in f.readlines()])

    for i in xrange(len(words) - 1):
        localBigrams[(words[i][0], words[i + 1][0])] += 1
    for k, v in localBigrams.iteritems():
        bigrams[k].append((id, v))

result = collections.defaultdict(list)
for k, v in bigrams.iteritems():
    v.sort(key = lambda p: -p[1])
    if len(v) < 2:
        continue
    diff = v[0][1] - v[1][1]
    if diff >= 5:
        result[candidateNames[v[0][0]]].append((k[0], k[1], diff))

for k in sorted(result):
    v = result[k]
    v.sort(key = lambda p: -p[2])
    print '{0}: {1}'.format(k, ', '.join('{0} {1} ({2})'.format(p[0], p[1], p[2]) for p in v))
