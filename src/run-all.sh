curl http://cvk2012.org/candidates/ > ../data/candidates.html
parse_html.pl < ../data/candidates.html > ../data/vectors.csv
make-graph.r