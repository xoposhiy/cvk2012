for i in 1 2 3 4 
do
	
	curl "http://cvk2012.org/debaty/"$i"_den_kvalifikacionnogo_tura/" | perl -pe "chomp" | perl -ne 's/\s+/ /g; for $i (/<b>([^<]*)<\/b>/g) {print $i."\n\r"; }'
done