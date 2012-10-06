import os
import sys
import traceback
import urllib

lines = open('articles.txt').readlines()
urlId = 1
prevAuthorId = None
for i, line in enumerate(lines):
    authorId, url = line.strip().split('\t')
    if authorId != prevAuthorId:
        urlId = 1
    prevAuthorId = authorId
    filename = os.path.join('candidate_articles', '{0}_{1}.html'.format(authorId, urlId))
    urlId += 1

    print >>sys.stderr, 'Downloading <{0}> '.format(url),
    if os.path.exists(filename):
        print >>sys.stderr, 'SKIPPING ',
    else:
        try:
            page = urllib.urlopen(url)
            code = page.getcode()
            if code != 200:
                print >>sys.stderr, 'HTTP ERROR: {0} '.format(code),
            else:
                content = page.read()
                if 'charset=windows-1251' in content.lower():
                    sourceEncoding = 'koi8-r' if 'delyagin.ru' in url else 'windows-1251'
                    print >>sys.stderr, '{0} -> UTF-8 '.format(sourceEncoding.upper()),
                    content = content.decode(sourceEncoding).encode('utf-8')
                with open(filename, 'w') as f:
                    print >>f, content
                print >>sys.stderr, 'OK ',
        except:
            print >>sys.stderr, 'ERROR ',
            traceback.print_exc()
    print >>sys.stderr, '{0}/{1}'.format(i + 1, len(lines))

