#!/usr/bin/perl

sub k82tr
    { ($_)=@_;

#
# Fonetic correct translit
#

s/Ñõ/S\'h/; s/ñõ/s\'h/; s/ÑÕ/S\'H/;
s/Ø/Sh/g; s/ø/sh/g;

s/Ñöõ/Sc\'h/; s/ñöõ/sc\'h/; s/ÑÖÕ/SC\'H/;
s/Ù/Sch/g; s/ù/sch/g;

s/Öõ/C\'h/; s/öõ/c\'h/; s/ÖÕ/C\'H/;
s/×/Ch/g; s/÷/ch/g;

s/Éà/J\'a/; s/éà/j\'a/; s/ÉÀ/J\'A/;
s/ß/Ja/g; s/ÿ/ja/g;

s/Éî/J\'o/; s/éî/j\'o/; s/ÉÎ/J\'O/;
s/¨/Jo/g; s/¸/jo/g;

s/Éó/J\'u/; s/éó/j\'u/; s/ÉÓ/J\'U/;
s/Ş/Ju/g; s/ş/ju/g;

s/İ/E\'/g; s/ı/e\'/g;
s/Å/E/g; s/å/e/g;

s/Çõ/Z\'h/g; s/çõ/z\'h/g; s/ÇÕ/Z\'H/g;
s/Æ/Zh/g; s/æ/zh/g;

tr/
àáâãäçèéêëìíîïğñòóôõöúûüÀÁÂÃÄÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖÚÛÜ/
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;

return $_;

}

print "name, curia, block, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24, q25\n";
@curias = qw(common lib left naz);
$curia = -1;
while(<>){
	if (/h2.(.*)..h2/){
		$curia++;
	}
 	if (/<div class=.dna.><\/div>/){
 		print $name.", ".$curias[$curia].", ".$block.", ".$compass."\n";
 	}
 	if (/account_candidate_PrintShort/){
 		$block = "";
 		$name = "";
 		$compass = "";
 	}
 	if (/bloki\/(.*?)\//){
		$block = $1;
	}
 	if (/<span class=.title.>/){
 		$_ = <>;
 		/^\s+(.*)\s+$/;
 		$name = k82tr($1);
 		@ps = split(/[\s()]+/, $_);
 		$name = join(" ", @ps[0,1]);
 	}
 	if (/candidate_compass_data.>\[(.*)\]/){
 		$compass = $1;
 	}
}


