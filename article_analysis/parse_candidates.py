from HTMLParser import HTMLParser

def Attr(attrs, attrName):
    for k, v in attrs:
        if k == attrName:
            return v
    return None

class CandidatesParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.candidateId = None
        self.inCandidateName = False

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            href = Attr(attrs, 'href')
            prefix = '/candidates/?ID='
            if href and href.startswith(prefix):
                self.candidateId = href[len(prefix):]
        if self.candidateId is not None and tag == 'span':
            klass = Attr(attrs, 'class')
            if klass == 'title':
                self.inCandidateName = True

    def handle_data(self, text):
        if self.inCandidateName:
            print "%s\t%s" % (self.candidateId, text.strip())
            self.candidateName = None
            self.inCandidateName = False

CandidatesParser().feed(open('candidates.html').read())
