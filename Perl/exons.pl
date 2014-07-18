#!/usr/bin/perl
use Perl::definitions;
use Perl::utils;

@fields=('transcript_id', 'gene_id');

while($line=<STDIN>) {
    ($chr, $source, $feature, $beg, $end, $score, $strand, $trash, $attr) = split /\t/, $line;
    next unless($feature eq "exon");
    $chr = "chr$chr" unless($chr=~/^chr/);
    %attr = get_attributes($attr);
    $biotype = GET_BIOTYPE($attr{'gene_category'});
    next if($biotype eq "other");
    print join("\t", (join("_", ($chr,$beg, $end, $strand)), @attr{@fields}, $biotype)),"\n" if($attr{'gene_id'}=~/^[A-Z]/ || $attr{'gene_id'}=~/\=/);
}


