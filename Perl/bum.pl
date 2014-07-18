#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

if(@ARGV==0) {
    print STDERR "This script takes two reciprocal pairwise mappings and returns unique bidirectional matches\n"; 
}

parse_command_line(src_cps => {description=>'species1 cps', ifunreadable=>'cps1 not specified'},
                   dst_cps => {description=>'species2 cps', ifunreadable=>'cps2 not specified'},
		   src_rel => {description=>'species1 rel', ifunreadable=>'rel1 not specified'},
                   dst_rel => {description=>'species2 rel', ifunreadable=>'rel2 not specified'},
		       map => {description=>'mapping', ifunreadable=>'map not specified'},
		   out_s   => {description=>'output cps', ifabsent=>"output cps not specified"},
		   out_r   => {description=>'output rel', ifabsent=>"output rel not specified"});


%one_rel = read_rel($src_rel);
%one_cps = read_cps($src_cps);

%two_rel = read_rel($dst_rel);
%two_cps = read_cps($dst_cps);

read_map($map);

print STDERR "[->$out_s";
open BUMS, ">$out_s" || die;
foreach $chr1(sort keys(%map12)) {
    foreach $pos1(sort {$a<=>$b} keys(%{$map12{$chr1}})) {
	foreach $str1(sort keys(%{$map12{$chr1}{$pos1}})) {
	    ($chr2, $pos2, $str2) = @{$map12{$chr1}{$pos1}{$str1}};
	    foreach $type(keys(%{$one_cps{$chr1}{$pos1}{$str1}})) {
		if($two_cps{$chr2}{$pos2}{$str2}{$type}) {
                    print BUMS join("\t",join("_",$chr1,$pos1,$str1), $type, @{$one_cps{$chr1}{$pos1}{$str1}{$type}}), "\t";
                    print BUMS join("\t",join("_",$chr2,$pos2,$str2), $type, @{$two_cps{$chr2}{$pos2}{$str2}{$type}}), "\n";
		}
	    }
	}
    }
} 
close BUMS;
print STDERR "]\n";

print STDERR "[->$out_r";
open BUMR, ">$out_r" || die;
foreach $chr1(sort keys(%map12)) {
    foreach $beg1(sort {$a<=>$b} keys(%{$map12{$chr1}})) {
        foreach $str1(sort keys(%{$map12{$chr1}{$beg1}})) {
            ($chr2, $beg2, $str2) = @{$map12{$chr1}{$beg1}{$str1}};
	    foreach $end1(sort {$a<=>$b} keys(%{$one_rel{$chr1}{$beg1}{$str1}})) {
		next unless($map12{$chr1}{$end1}{$str1});
		($chr2a, $end2, $str2a) = @{$map12{$chr1}{$end1}{$str1}};
                next unless($chr2a eq $chr2 && $str2a eq $str2);
		foreach $type(keys(%{$one_rel{$chr1}{$beg1}{$str1}{$end1}})) {
		    if($two_rel{$chr2}{$beg2}{$str2}{$end2}{$type}) {
                    	print BUMR join("\t", join("_",$chr1,$beg1,$end1,$str1), $type, @{$one_rel{$chr1}{$beg1}{$str1}{$end1}{$type}}), "\t";
                    	print BUMR join("\t", join("_",$chr2,$beg2,$end2,$str2), $type, @{$two_rel{$chr2}{$beg2}{$str2}{$end2}{$type}}), "\t$STATUS_121\n";
		    }
		    else {
			foreach $bound1(keys(%{$one_cps{$chr1}{$beg1}{$str1}})) {
			    foreach $bound2(keys(%{$one_cps{$chr1}{$end1}{$str1}})) {
				next if($bound1 eq $bound2);
				next unless($two_cps{$chr2}{$beg2}{$str2}{$bound1} && $two_cps{$chr2}{$end2}{$str2}{$bound2});
				($gene1, $biotype, $intern, $level1, $altern) = @{$two_cps{$chr2}{$beg2}{$str2}{$bound1}}; 
				($gene2, $biotype, $intern, $level2, $altern) = @{$two_cps{$chr2}{$end2}{$str2}{$bound2}};
				next unless($gene1 eq $gene2);
				my @arr =($gene1, $biotype, 1, $level1*$level2, 0);
				print BUMR join("\t", join("_",$chr1,$beg1,$end1,$str1), $type, @{$one_rel{$chr1}{$beg1}{$str1}{$end1}{$type}}), "\t";
				print BUMR join("\t", join("_",$chr2,$beg2,$end2,$str2), $type, @arr), "\t$STATUS_12X\n";
			    }
			}
		    }
		}
	    }
            foreach $end2(keys(%{$two_rel{$chr2}{$beg2}{$str2}})) {
                next unless($map21{$chr2}{$end2}{$str2});
                ($chr1a, $end1, $str1a) = @{$map21{$chr2}{$end2}{$str2}};
                next unless($chr1a eq $chr1 && $str1a eq $str1);
                foreach $type(keys(%{$two_rel{$chr2}{$beg2}{$str2}{$end2}})) {
                    if($one_rel{$chr1}{$beg1}{$str1}{$end1}{$type}) {
                    }
                    else {
                        foreach $bound2(keys(%{$two_cps{$chr2}{$beg2}{$str2}})) {
                            foreach $bound1(keys(%{$two_cps{$chr2}{$end2}{$str2}})) {
                                next if($bound2 eq $bound1);
                                next unless($one_cps{$chr1}{$beg1}{$str1}{$bound2} && $one_cps{$chr1}{$end1}{$str1}{$bound1});
                                ($gene1, $biotype, $intern, $level1, $altern) = @{$one_cps{$chr1}{$beg1}{$str1}{$bound2}};
                                ($gene2, $biotype, $intern, $level2, $altern) = @{$one_cps{$chr1}{$end1}{$str1}{$bound1}};
                                next unless($gene1 eq $gene2);
                                my @arr =($gene1, $biotype, 1, $level1*$level2, 0);
                                print BUMR join("\t", join("_",$chr1,$beg1,$end1,$str1), $type, @arr), "\t";
                                print BUMR join("\t", join("_",$chr2,$beg2,$end2,$str2), $type, @{$two_rel{$chr2}{$beg2}{$str2}{$end2}{$type}}), "\t$STATUS_X21\n";
                            }
                        }
                    }
                }
            }

	}
    }
}
close BUMR;
print STDERR "]\n";


sub read_map {
    print STDERR "[<-@_[0]";
    open FILE, @_[0];
    while($line=<FILE>) {
        chomp $line;
        ($chr1, $pos1, $str1, $chr2, $pos2, $str2) = split /\t/, $line;
        @{$map12{$chr1}{$pos1}{$str1}} = ($chr2, $pos2, $str2);
        @{$map21{$chr2}{$pos2}{$str2}} = ($chr1, $pos1, $str1);

    }
    close FILE;
    print STDERR "]\n";
}

sub read_rel {
    my %f=();
    print STDERR "[<-@_[0]";
    open FILE, @_[0];
    while($line=<FILE>) {
        chomp $line;
        ($chr, $beg, $end, $str, $type, $gene, $biotype, $intern, $level, $altern) = split /\t/, $line;
        @{$f{$chr}{$beg}{$str}{$end}{$type}} = ($gene, $biotype, $intern, $level, $altern);
    }
    close FILE;
    print STDERR "]\n";
    return(%f);
}

sub read_cps {
    my %f=();
    print STDERR "[<-@_[0]";
    open FILE, @_[0];
    while($line=<FILE>) {
        chomp $line;
        ($chr, $pos, $str, $gidx, $sidx, $type, $gene, $biotype, $intern, $level, $altern) = split /\t/, $line;
        @{$f{$chr}{$pos}{$str}{$type}} = ($gene, $biotype, $intern, $level, $altern);
    }
    close FILE;
    print STDERR "]\n";
    return(%f);
}










