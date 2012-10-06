# -*- coding:utf-8 -*-
import os
import sys
import urllib
import urlparse
from HTMLParser import HTMLParser, HTMLParseError

def Attr(attrs, attrName):
    for k, v in attrs:
        if k == attrName:
            return v
    return None

class PageParser(HTMLParser):
    def __init__(self, id):
        HTMLParser.__init__(self)
        self.id = id
        self.inH3 = False
        self.inArticles = False

    def handle_starttag(self, tag, attrs):
        self.inH3 = tag == 'h3'
        if self.inArticles:
            if tag != 'p' and tag != 'a':
                self.inArticles = False
            elif tag == 'a':
                href = Attr(attrs, 'href')
                p = urlparse.urlparse(href)
                if p.scheme != 'http' or \
                   p.netloc in ['', 'ustre.am', 'www.1tv.ru', 'pik.tv', 'youtube.com', 'www.youtube.com', 'youtu.be', 'нет', 'vk.com', 'facebook.com'] or \
                   'tvrain' in p.netloc or \
                   'wikipedia' in p.netloc or \
                   'Когда' in p.netloc or \
                   ('video' in href and p.netloc != 'www.igpr.ru') or \
                   (p.netloc == 'www.facebook.com' and 'story_fbid' not in href) or \
                   p.path in ['', '/']:
                    print >>sys.stderr, 'Skipping {0}'.format(href)
                else:
                    print '{0}\t{1}'.format(id, href)

    def handle_data(self, text):
        if self.inH3 and text == 'Выступления и статьи':
            self.inArticles = True

for line in open('candidates.txt'):
    id, _ = line.strip().split('\t')
    with open(os.path.join('candidate_pages', '{0}.html'.format(id))) as f:
        try:
            PageParser(id).feed(f.read())
        except HTMLParseError:
            print >>sys.stderr, "{0}'s page is malformed".format(id)
