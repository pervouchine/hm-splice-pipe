#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

if(@ARGV==0) {
}

parse_command_line(cps => {description=>'cps input', ifunreadable=>'cps not specified'},
		   sgn => {description=>'sgn input', ifunreadable=>'sgn not specified'});
		
###################################################################################################################################

print STDERR "[<$cps";
open FILE, $cps || die;
while($line=<FILE>) {
    chomp $line;
    ($chr, $pos, $str, $gene, $id, $type, $name, $biotype, $intern, $level, $altern) = split /\t/, $line;
    next unless($intern eq $POS_INTL);
    $pos{$id} = join("_", $chr, $pos, $str);
    $type{$id} = "$type$intern";
    $alt{$id} = join("\t", $altern, $biotype, $level);
}
close FILE;
print STDERR "]\n";

###################################################################################################################################

print STDERR "[<$sgn";
open FILE, $sgn || die;
while($line=<FILE>) {
    chomp $line;
    ($id, $chr, $pos, $len, $str, $totlen, $seq) = split /\t/, $line;
    $seq =~ tr/[a-z]/[A-Z]/;
    @arr = split //, $seq;
    for($i=0;$i<@arr;$i++) {
	next unless($arr[$i] =~ /[ACGT]/);
        $count{$type{$id}}{$i}{$arr[$i]}++;
    }
}
print STDERR "]\n";

foreach $t(keys(%count)) {
    for $i(sort{$a<=>$b} keys(%{$count{$t}})) {
	@a = ();
	foreach $z(sort keys(%{$count{$t}{$i}})) {
	    $score=log($count{$t}{$i}{$z});
	    push @a, $score;
	}
	@a = sort {$a<=>$b} @a;
	$s = 0;
	foreach $z(sort keys(%{$count{$t}{$i}})) {
            $score=log($count{$t}{$i}{$z});
	    $s+=($score-$a[0]);
	}
	foreach $z(sort keys(%{$count{$t}{$i}})) {
            $score=log($count{$t}{$i}{$z});
	    $PWM{$t}{$i}{$z} = int(100*(($score-$a[0])/$s)+0.5);
	}
    }
}

#foreach $t(keys(%count)) {
#    for $i(sort{$a<=>$b} keys(%{$count{$t}})) {
#	foreach $z(sort keys(%{$PWM{$t}{$i}})) {
#	    print STDERR "$t\t$i\t$z\t$PWM{$t}{$i}{$z}\n";
#	}
#    }
#}

print STDERR "[<$sgn, >stdout";
open FILE, $sgn || die;
while($line=<FILE>) {
    chomp $line;
    ($id, $chr, $pos, $len, $str, $totlen, $seq) = split /\t/, $line;
    next if($done{$id});
    $seq =~ tr/[a-z]/[A-Z]/;
    @arr = split //, $seq;
    $s = 0;
    for($i=0;$i<@arr;$i++) {
        $s+= $PWM{$type{$id}}{$i}{$arr[$i]};
    }
    print "$pos{$id}\t$type{$id}\t$alt{$id}\t$s\t",substr($seq,$type{$id} eq "52" ? -10 : 0 ,10),"\n";
    $done{$id}=1;
}
print STDERR "]\n";


