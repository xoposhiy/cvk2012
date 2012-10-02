echo name,curia,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25 > ../data/all-answers.csv
grep "" ../data/userstorage.json | perl -pe 's/^.*\[(.*)\].*$/$1/' | grep -v "null" | perl -pe 's/^(.*)$/,4,$1/' >> ../data/all-answers.csv
tail +2 ../data/vectors.csv >> ../data/all-answers.csv