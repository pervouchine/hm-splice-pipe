#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

# Attention: this script to to compute one-to-one mapping based on f:A->B and g:B->A
# It doesn't care if the destination nucleotide in the target genome is annotated or not
# The output is: 

if(@ARGV==0) {
    print STDERR "This script takes two reciprocal pairwise mappings and returns unique bidirectional matches\n";
}

parse_command_line(src => {description=>'species1=>species2 mapping', ifunreadable=>'src not specified'},
		   dst => {description=>'species2=>species1 mapping', ifunreadable=>'dst not specified'});

%a = read_file($src);
%b = read_file($dst);

print STDERR "[>stdout";
foreach $x(sort keys(%a)) {			# for each x in the domain of the forward mapping
    %aux=();					#
    foreach $y(@{$a{$x}}) {			#   for each y of its images
	foreach $z(@{$b{$y}}) {			#     for each z of backward images of y 
	    $aux{"$x;$y"}++ if($z eq $x);	#	keep (x,y) if y projects back to x
	}
    }	
    @arr = keys(%aux);
    next unless(@arr==1);			# may be x->y and y->z are not unique but (x,y)
    ($x, $y) = split /\;/, shift(@arr);		# is reported if (x,y) is unique
    next if($done_a{$x} || $done_b{$y});
    print "$x\t$y\n"; #t$STATUS_3\n";
    $done_a{$x} = $done_b{$y} = 1;
}
print STDERR "]\n";

sub read_file {
    my %f=();
    print STDERR "[<=@_[0]";
    open FILE, @_[0];
    while($line=<FILE>) {
  	chomp $line;
	($chr1, $pos1, $str1, $chr2, $pos2, $str2) = split /\t/, $line;
	push @{$f{"$chr1\t$pos1\t$str1"}}, "$chr2\t$pos2\t$str2";
    }
    close FILE;
    print STDERR "]\n";
    return(%f);
}
