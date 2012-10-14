parse_html.pl < ../data/candidates.html >o
echo "block,name,name_eng" > ../data/blocks.csv
grep BLOCK < o | cut -c7- | sort  >> ../data/blocks.csv
echo "name,name_eng,curia,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25" > ../data/vectors.csv
grep "VECTOR " < o | cut -c8- >> ../data/vectors.csv