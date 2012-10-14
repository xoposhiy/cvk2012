for i in {1..70}
do
	echo "http://www.cvk2012.org/essai/"$i"/"
	curl "http://www.cvk2012.org/essai/"$i"/" > "../data/essai/"$i".html"
done