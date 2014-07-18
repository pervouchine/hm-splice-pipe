#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

if(@ARGV==0) {
}

parse_command_line(in1 => {description=>'species1 splice sites stength', ifunreadable=>'sss1 not specified'},
                   in2 => {description=>'species2 splice sites stength', ifunreadable=>'sss2 not specified'},
                   map => {description=>'relation map', ifunreadable=>'relation map not specified'});


%one = split /[\t\n]/, `cut -f1,7 $in1`;
%two = split /[\t\n]/, `cut -f1,7 $in2`;

foreach $line(split /\n/, `cut -f1,8 $map`) {
    ($x, $y) = split /\t/, $line;
    ($chr1, $don1, $acc1, $str1) = split /\_/, $x;
    ($chr2, $don2, $acc2, $str2) = split /\_/, $y;
    print join("\t", $x, $y, $one{join("_",$chr1, $don1, $str1)}, $one{join("_",$chr1, $acc1, $str1)}, 
			     $two{join("_",$chr2, $don2, $str2)}, $two{join("_",$chr2, $acc2, $str2)}, 
			     hamming($one{join("_",$chr1, $don1, $str1)}, $two{join("_",$chr2, $don2, $str2)}) +
			     hamming($one{join("_",$chr1, $acc1, $str1)}, $two{join("_",$chr2, $acc2, $str2)})), "\n";
}


sub hamming {
    my @a = split //, @_[0];
    my @b = split //, @_[1];
    my $s=0;
    for(my $i=0;$i<@a;$i++) {
	$s+= ($a[$i] eq $b[$i] ? 0 : 1); 
    }
    return($s);
}

