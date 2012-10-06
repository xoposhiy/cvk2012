import os
import sys
import urllib

lines = open('candidates.txt').readlines()
for i, line in enumerate(lines):
    id, _ = line.strip().split('\t')
    try:
        urllib.urlretrieve('http://www.cvk2012.org/candidates/?ID={0}'.format(id), os.path.join('candidate_pages', '{0}.html'.format(id)))
    except:
        print >>sys.stderr, "FAIL {0}".format(id)
    print >>sys.stderr, '{0}/{1}'.format(i + 1, len(lines))
