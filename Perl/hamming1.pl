#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

if(@ARGV==0) {
}

parse_command_line(in1 => {description=>'species1 splice sites stength', ifunreadable=>'sss1 not specified'},
                   in2 => {description=>'species2 splice sites stength', ifunreadable=>'sss2 not specified'},
		   map => {description=>'splice site map', ifunreadable=>'splice site map not specified'});

%one = split /[\t\n]/, `cut -f1,7 $in1`;
%two = split /[\t\n]/, `cut -f1,7 $in2`;

foreach $line(split /\n/, `cut -f1,2,4,8 $map`) {
    ($x, $t, $g, $y) = split /\t/, $line;
    print join("\t", $x, $y, $t, $g, $one{$x}, $two{$y},hamming($one{$x}, $two{$y})), "\n";
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

