#!/usr/bin/env python2.7
import numpy as np

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
    gVotes = np.load("all-votes.npy")
    names = LoadNames()
    avg =  np.average(gVotes, axis=0)
    idxList = [i for i in xrange(382) if avg[i]]
    gVotes = gVotes.transpose()[idxList].transpose()
    n, m = gVotes.shape
    gVotesMatrix = np.mat(gVotes)
    onesMatrix = np.mat(np.ones([n,m]))
    avgVotes = np.sum(avg)
    print avgVotes
    a0 = np.random.random(n)
    a1 = 1 - a0
    for _ in xrange(10):
        if a0.sum() > a1.sum():
            a0, a1 = a1, a0
        p = ((a0 * gVotesMatrix) / a0.sum()).transpose()
        q = ((a1 * gVotesMatrix) / a1.sum()).transpose()
        pl = np.log(1-p); p0 = np.exp(gVotesMatrix * (np.log(p)-pl) + onesMatrix * pl)
        ql = np.log(1-q); q0 = np.exp(gVotesMatrix * (np.log(q)-ql) + onesMatrix * ql)
        a0 = (p0/(p0 + q0)).transpose()
        a1 = (q0/(p0 + q0)).transpose()
        print p.sum(), a0.sum(), q.sum(), a1.sum()
    print "MMM choice:"
    for i in xrange(m):
        if p[i] > 0.5:
            print "{0}\t{1}".format(names[idxList[i] + 1], float(p[i]))
    print
    print "Right choice:"
    for i in sorted(xrange(m), key=lambda i: q[i], reverse=True):
        print "{0}\t{1}".format(names[idxList[i] + 1], float(q[i]))
