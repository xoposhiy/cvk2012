#!/usr/bin/perl
use encoding 'utf8';
sub k82tr
    { ($_)=@_;

#
# Fonetic correct translit
#

s/Сх/S\'h/; s/сх/s\'h/; s/СХ/S\'H/;
s/Ш/Sh/g; s/ш/sh/g;

s/Сцх/Sc\'h/; s/сцх/sc\'h/; s/СЦХ/SC\'H/;
s/Щ/Sch/g; s/щ/sch/g;

s/Цх/C\'h/; s/цх/c\'h/; s/ЦХ/C\'H/;
s/Ч/Ch/g; s/ч/ch/g;

s/Йа/J\'a/; s/йа/j\'a/; s/ЙА/J\'A/;
s/Я/Ja/g; s/я/ja/g;

s/Йо/J\'o/; s/йо/j\'o/; s/ЙО/J\'O/;
s/Ё/Jo/g; s/ё/jo/g;

s/Йу/J\'u/; s/йу/j\'u/; s/ЙУ/J\'U/;
s/Ю/Ju/g; s/ю/ju/g;

s/Э/E\'/g; s/э/e\'/g;
s/Е/E/g; s/е/e/g;

s/Зх/Z\'h/g; s/зх/z\'h/g; s/ЗХ/Z\'H/g;
s/Ж/Zh/g; s/ж/zh/g;

tr/
абвгдзийклмнопрстуфхцъыьАБВГДЗИЙКЛМНОПРСТУФХЦЪЫЬ/
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;

return $_;

}

print "name, curia, block, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24, q25\n";
@curias = qw(common left lib naz);
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
 		$name = $1; #k82tr($1);
 		@ps = split(/[\s()]+/, $_);
 		$name = join(" ", @ps[0,1,2]);
 	}
 	if (/candidate_compass_data.>\[(.*)\]/){
 		$compass = $1;
 	}
}


