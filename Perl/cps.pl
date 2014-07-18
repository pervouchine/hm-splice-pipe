#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

if(@ARGV==0) {
}

parse_command_line(exons     => {description=>'the exons file', ifunreadable=>'exons not specified'},
		   junctions =>{description=>'the SJ counts tsv file', ifunreadable=>'SJ counts not specified'},
                   cps       => {description=>'cps output', ifabsent=>'cps not specified'},
		   rel       => {description=>'rel output', ifabsent=>'rel not specified'});

$cutoff = 0.25;

#################################################################################################################
print STDERR "[<$exons";
open FILE, $exons || die();
while($line=<FILE>) {
    chomp $line;
    ($exon, $transcript, $gene, $biotype) = split /\t/, $line;
    $GT{$gene}{$transcript}++;				# gene-transcript relation
    $TE{$transcript}{$exon}++;				# transcript-exon relation
    $BT{$biotype}{$gene}++;
}
close FILE;
print STDERR "]\n";

print STDERR "[<$junctions";
open FILE, $junctions || die;
$line=<FILE>;
while($line=<FILE>) {
	chomp $line;
	@array = split /\t/, $line;
	($chr, $beg, $end, $str) = split /\_/, shift(@array);
	next unless($str);
	$sum=0;
        foreach $value(@array) {
            $sum++ if($value>0);
        }
        next unless($sum>=$cutoff*@array);
	$str = strand_c2i($str);
	$acc{$chr}{$beg}{$str}{$end} = 1;
	$don{$chr}{$end}{$str}{$beg} = 1;
}
close FILE;
print STDERR "]\n";

open CPS, ">$cps" || die;
open REL, ">$rel" || die;

#################################################################################################################

foreach $biotype(@BIOTYPES) {
  $N = 0+keys(%{$BT{$biotype}});
  $n=0;
  foreach $gene(sort keys(%{$BT{$biotype}})) {
    progressbar(++$n,$N,"$biotype\t");

    $chr = $str = undef;
    %site_count = %site_inter = %site_level = %site_total = ();
    %segm_count = %segm_inter = %segm_level = %segm_total = ();
    %range = ();
    foreach $transcript(keys(%{$GT{$gene}})) {			# for each transcript within this gene
	@pos = ();						# 
	foreach $exon(keys(%{$TE{$transcript}})) {		# for all its exons 
	    ($chr, $beg, $end, $str) = split /\_/, $exon;	#
	    $str = strand_c2i($str);				#
	    next unless($beg<$end);				#
	    ($beg, $end) = reverse ($beg, $end) if($str<0);	# 
	    push @pos, [$beg, $end];				#
	}							#
	next unless(@pos>0);					#
	@pos = sort {$a->[0]<=>$b->[0]} @pos;			#
	@pos = reverse @pos if($str<0);				# @pos consists of exons in 5'-3' order

	@{$range{$transcript}} = sort {$a<=>$b} ($pos[0]->[0], $pos[@pos-1]->[1]);


	for($i=0;$i<@pos;$i++) {
		($beg, $end) = @{$pos[$i]};
                $site_count{$beg}{$SITE_ACC}++;
                $site_inter{$beg}{$SITE_ACC} = $i>0 	 ? $POS_INTL : $POS_INIT;
		$site_level{$beg}{$SITE_ACC} = $LEV_CONF;

                $site_count{$end}{$SITE_DON}++;
		$site_inter{$end}{$SITE_DON} = $i<@pos-1 ? $POS_INTL : $POS_TERM;
		$site_level{$end}{$SITE_DON} = $LEV_CONF;

		$segm_count{$beg}{$end}{$SEGM_EXON}++;
		$segm_inter{$beg}{$end}{$SEGM_EXON} = $i>0 ? ($i<@pos-1 ? $POS_INTL : $POS_TERM) : $POS_INIT;
		$segm_level{$beg}{$end}{$SEGM_EXON} = $LEV_CONF;
		
		if($i>0) {
		    $end = $pos[$i-1]->[1];
		    $segm_count{$end}{$beg}{$SEGM_INTR}++;  
		    $segm_inter{$end}{$beg}{$SEGM_INTR} = $POS_INTL;  
		    $segm_level{$end}{$beg}{$SEGM_INTR} = $LEV_CONF;
		}
	    }
	}

	foreach $x(keys(%site_count)) {
	    foreach $y(keys(%{$acc{$chr}{$x}{$str}})) {
		next if($site_count{$y}{$SITE_ACC});
		$site_count{$y}{$SITE_ACC}+=0; 
		$site_inter{$y}{$SITE_ACC} = $POS_INTL;
		$site_level{$y}{$SITE_ACC} = $LEV_PRED unless($site_level{$y}{$SITE_ACC});

		$segm_count{$x}{$y}{$SEGM_INTR}+=0;
		$segm_inter{$x}{$y}{$SEGM_INTR} = $POS_INTL;
		$segm_level{$x}{$y}{$SEGM_INTR} = $LEV_PRED unless($segm_level{$x}{$y}{$SEGM_INTR});
	    }
            foreach $y(keys(%{$don{$chr}{$x}{$str}})) {
                next if($site_count{$y}{$SITE_DON});
                $site_count{$y}{$SITE_DON}+=0;
                $site_inter{$y}{$SITE_DON} = $POS_INTL;
		$site_level{$y}{$SITE_DON} = $LEV_PRED unless($site_level{$y}{$SITE_DON});

                $segm_count{$y}{$x}{$SEGM_INTR}+=0;
                $segm_inter{$y}{$x}{$SEGM_INTR} = $POS_INTL;
		$segm_level{$y}{$x}{$SEGM_INTR} = $LEV_PRED unless($segm_level{$y}{$x}{$SEGM_INTR});
            }
	}

	foreach $transcript(keys(%{$GT{$gene}})) {
	    foreach $x(keys(%site_count)) {
		$site_total{$x}++ if($range{$transcript}[0]<= $x && $x<=$range{$transcript}[1]);
	    }
	    foreach $x(keys(%segm_count)) {
		foreach $y(keys(%{$segm_count{$x}})) {
		    $segm_total{$x}{$y}++ if($range{$transcript}[0]<= $x && $x<=$range{$transcript}[1] && $range{$transcript}[0]<= $y && $y<=$range{$transcript}[1]);
		}
	    }
	}

	if($chr && $str) {
	    @pos = keys(%site_count);
	    @pos = reverse @pos if($str<0);
	    ++$gene_index;
	    foreach $x(@pos) {
		foreach $t(keys(%{$site_count{$x}})) {
		    next if($done{$chr}{$x}{$str}{$t});
		    next unless($site_inter{$x}{$t} eq $POS_INTL);
		    print CPS join("\t",($chr, $x, strand_i2c($str), $gene_index, ++$site_index, $t, $gene, $biotype, $site_inter{$x}{$t}, $site_level{$x}{$t}, 
				($site_count{$x}{$t} < $site_total{$x} ? 0 : 1))), "\n" unless($site_count{$x}{$t} > $site_total{$x});
		    $done{$chr}{$x}{$str}{$t}++;
		}
	    }
	    foreach $x(keys(%segm_count)) {
		foreach $y(keys(%{$segm_count{$x}})) {
		    foreach $t(keys(%{$segm_count{$x}{$y}})) {
			next if($done{$chr}{$x}{$y}{$str}{$t});
			next unless($segm_inter{$x}{$y}{$t} eq $POS_INTL);
		    	print REL join("\t",($chr, $x, $y, strand_i2c($str), $t, $gene, $biotype, $segm_inter{$x}{$y}{$t}, $segm_level{$x}{$y}{$t},
				($segm_count{$x}{$y}{$t} < $segm_total{$x}{$y} ? 0 : 1),"$chr\_$x\_$y\_".strand_i2c($str))),"\n" unless($segm_count{$x}{$y}{$t}>$segm_total{$x}{$y});
			$done{$chr}{$x}{$y}{$str}{$t}++;
		    }
		}
	    }
	}
    }
}
