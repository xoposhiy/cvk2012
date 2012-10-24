#!/usr/bin/env python2.7

import csv, collections
import logging
import numpy as np


if __name__ == "__main__":
    badIds = set(ln.strip() for ln in open("mmm-ids.txt"))
    gVotes = []
    with open("protocol.csv") as input:
        reader = csv.reader(input, delimiter=";")
        next(reader)
        for ln in reader:
            if not ln:
                continue
            #remove pure mmm ids
            #if ln[0] in badIds:
            #    continue
            votes = set([int(item) for item in ln[2].split(",")])
            lVotes = np.array([int(v in votes) for v in xrange(382)])
            gVotes.append(lVotes)
    gVotes = np.array(gVotes)
    np.save("all-votes.npy", gVotes)
