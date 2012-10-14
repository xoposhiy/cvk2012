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


@curias = qw(common left lib naz);
$curia = -1;

while(<>){
	chomp;
	if (/h2.(.*)..h2/){
		$curia++;
	}
 	if (/^.\/div./ && $name){
 		print "VECTOR ".$name.",".k82tr($name).",".$curias[$curia].",".$compass."\n" if ($compass);
 		foreach $b (@blocks){
 			print "BLOCK ".$b.",".$name.",".k82tr($name)."\n";	
 		}
 		$name = undef;
 	}
 	if (/account_candidate_PrintShort/){
 		@blocks = ();
 		$name = "";
 		$compass = "";
 	}
 	if (/bloki\/(.*?)\//){
		push @blocks, $1;
	}
 	if (/<span class=.title.>/){
 		$_ = <>;
 		/^\s+(.*)\s+$/;
 		$name = $1; #k82tr($1);
 		@ps = split(/[\s()]+/, $name);
 		$name = join(" ", @ps[0,1]);
 	}
 	if (/candidate_compass_data.>\[(.*)\]/){
 		$compass = $1;
 	}
}
