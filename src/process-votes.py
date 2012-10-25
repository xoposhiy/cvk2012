#!/usr/bin/env python2.7
import numpy as np
import sys

def LoadNames():
    import csv
    names = {}
    with open("candidates.csv") as input:
        reader = csv.reader(input, delimiter=";")
        next(reader)
        for ln in reader:
            names[int(ln[0])] = ln[1]
    return names
        

if __name__ == "__main__":
    K = int(sys.argv[1]) if len(sys.argv) > 1 else 2
    gVotes = np.load("all-votes.npy")
    names = LoadNames()
    avg =  np.average(gVotes, axis=0)
    idxList = [i for i in xrange(382) if avg[i]]
    gVotes = gVotes.transpose()[idxList].transpose()
    n, m = gVotes.shape
    gVotesMatrix = np.mat(gVotes)
    onesMatrix = np.mat(np.ones([n,m]))
    avgVotes = np.sum(avg)
    a = np.array([np.random.random(n) for _ in xrange(K)])
    a = list(a / a.sum(axis=0))
    for _ in xrange(100):
        a.sort(key=np.sum)    
        p = [((a[i] * gVotesMatrix) / a[i].sum()).transpose() for i in xrange(K)]
        pa = []
        for i in xrange(K):
            tmp = np.log(1-p[i])
            pa.append(np.exp(gVotesMatrix * (np.log(p[i]) - tmp) + onesMatrix * tmp))
        sa = sum(pa)
        for i in xrange(K):
            a[i] = (pa[i] / sa).transpose()
        print >>sys.stderr, map(np.sum, a), map(np.sum, p)
    orders = [sorted(xrange(m), key=lambda k:p[i][k], reverse=True) for i in xrange(K)]
    print "\t".join("Group size: {0:.0f}".format(a[i].sum()) for i in xrange(K))
    for j in xrange(m):
        print "\t".join("[{1:.6f}] {0}".format(names[idxList[orders[i][j]]+1], float(p[i][orders[i][j]])) for i in xrange(K))

