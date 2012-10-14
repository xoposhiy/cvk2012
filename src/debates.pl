#!/usr/bin/perl
use encoding 'utf8';

%h;
open D, "<../data/debates-source.txt";
<D>;
while (<D>){
	/(.+),(\d+)/;
	$name = $1;
	@ps = split(/[ ()]+/, $name);
	$name = join(" ", @ps[0,1]);
	$h{$name} = $2;
}
close D;
open F, "<../data/vectors.csv";
<F>;
print "name,debates\n";
while(<F>){
	chomp;
	/^(.*?)\,/;
	print $1.",".$h{$1}."\n";
}
close F
