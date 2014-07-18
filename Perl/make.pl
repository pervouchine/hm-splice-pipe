#!/usr/bin/perl
use Perl::utils;
use Perl::definitions;

$DIR = "data/";
$OUT = "output/";
($trash, $MAP) = split /[\=\n]/, `grep "MAPTOOLSDIR=" makefile`;

@IDS = split /\,/, shift(@ARGV);

make(script=>"wget", before=>"http://genome.crg.es/~dmitri/export-2.2/gene_orthologs.tab", output=>{-O=>$DIR."gene_orthologs.tab"});
make(script=>"cmp_list_of_orthologs.r", input=>{-i=>$DIR."hg19.mm9.bum_s.tab",-c=>$DIR."gene_orthologs.tab"}, output=>{-x=>$OUT."hg19.mm9.orth1a.tex",-y=>$OUT."hg19.mm9.orth1b.tex"});

foreach $db(@IDS) {
    make(script=>"curl", before=>$annotation{$db}, between=>"| gunzip | sed 's/gene_biotype/gene_type/g'", output=>{'>'=>"$DIR$db.gtf"}, mkdir=>T);
    make(script=>"exons.pl", input=>{'<'=>"$DIR$db.gtf"}, output=>{'>'=>"$DIR$db.exons"}); 
    make(script=>"cps.pl",input=>{-exons=>"$DIR$db.exons", -junctions=>"$DIR$db.counts.ssj.all"}, output=>{-cps=>"$DIR$db.cps", -rel=>"$DIR$db.rel"});
    make(script=>"cut -f1-3", input=>{''=>"$DIR$db.cps"}, output=>{'>'=>"$DIR$db.cps.srt"}, between=>'| sort -u -k1,1 -k2,2n');

    foreach $suff("idx", "dbx") {
	make(script=>'wget', before=>"$genome{$db}.$suff", output=>{-O=>"$DIR$db.$suff"});
    }

    make(script=>"wget", before=>"$import{$db}RnaSeq.logrpkm.tsv",     output=>{-O=>"$DIR$db.genes.log.rpkm"}, endpoint=>'execute');

    foreach $suff("psi5", "psi3", "cosi5", "cosi3", "psi", "counts.ssj") {
	make(script=>'wget', before=>"$import{$db}tx_paper.$suff.tsv", output=>{-O=>"$DIR$db.$suff.all"}, mkdir=>T);
	make(script=>'stats.r', input=>{-i=>"$DIR$db.$suff.all"}, output=>{-o=>"$DIR$db.$suff.sts"}) unless($suff eq "counts.ssj");
    }

    make(script=>"$MAP/bin/getwind", input=>{-in=>"$DIR$db.cps", -dbx=>"$DIR$db.dbx", -idx=>"$DIR$db.idx"}, output=>{-out=>"$DIR$db.sgn"}, after=>"-we 3 -wi 15 -coord 1 -cis"); 
}

foreach $db(@IDS) {
    make(script=>"pwm.pl", input=>{-cps=>"$DIR$db.cps", -sgn=>"$DIR$db.sgn"}, output=>{'>'=>"$DIR$db.sss"});
    make(script=>'table1.r',input=>{-i=>"$DIR$db.cps"}, output=>{-o=>"$OUT$db.table1a.tex"}, after =>"-n $db",  mkdir=>T);
    make(script=>'table2.r',input=>{-i=>"$DIR$db.rel"}, output=>{-o=>"$OUT$db.table2a.tex"}, after =>"-n $db");
    make(script=>'psi1.r', input=>{-a=>"$DIR$db.psi5.sts", -b=>"$DIR$db.psi3.sts"},  output=>{-o=>"$OUT$db-psi1.pdf"});
    make(script=>'psi1.r', input=>{-a=>"$DIR$db.cosi5.sts",-b=>"$DIR$db.cosi3.sts"}, output=>{-o=>"$OUT$db-cosi1.pdf"});
    make(script=>'psi2.r', input=>{-a=>"$DIR$db.psi5.sts", -b=>"$DIR$db.psi3.sts", -s=>"$DIR$db.sss"}, output=>{-o=>"$OUT$db-psi2.pdf"}, after =>"-n $db -m psi", mkdir=>T);
    make(script=>'psi2.r', input=>{-a=>"$DIR$db.cosi5.sts",-b=>"$DIR$db.cosi3.sts",-s=>"$DIR$db.sss"}, output=>{-o=>"$OUT$db-cosi2.pdf"}, after =>"-n $db -m theta", mkdir=>T);
    make(script=>'strength1.r', input=>{-i=>"$DIR$db.sss"}, output=>{-o=>"$OUT$db-strength1.pdf"});
}

foreach $db1(@IDS) {
    foreach $db2(@IDS) {
	next if($db1 eq $db2);
	$src = "http://bx.mathcs.emory.edu/~odenas/mapper_comparisons/UCSC/UCSC_reciprocal/$db1.$db2.rBest.chain";
	make(script=>'wget', before=>$src, output=>{-O=>"$DIR$db1.$db2.rBest.chain"});
	make(script=>"$MAP/bin/map_agnostic",input=>{-in=>"$DIR$db1.cps.srt", -chain=>"$DIR$db1.$db2.rBest.chain"}, between=>'|sort -k1,1 -k2,2n ',output=>{'>'=>"$DIR$db1.$db2.out"});

	if($db1 le $db2) {
	    make(script=>"map.pl", input=>{-src=>"$DIR$db1.$db2.out", -dst=>"$DIR$db2.$db1.out"}, output=>{'>'=>"$DIR$db1.$db2.map"});
	    make(script=>"bum.pl", input=>{-src_cps=>"$DIR$db1.cps", -dst_cps=>"$DIR$db2.cps", -src_rel=>"$DIR$db1.rel", -dst_rel=>"$DIR$db2.rel", -map=>"$DIR$db1.$db2.map"}, 
				  output=>{-out_r=>"$DIR$db1.$db2.bum_r.tab",-out_s=>"$DIR$db1.$db2.bum_s.tab"});


	    make(script=>'table3.r', input=>{-i=>"$DIR$db1.$db2.bum_s.tab"}, output=>{-a=>"$OUT$db1.$db2.table3a.tex",-b=>"$OUT$db1.$db2.table3b.tex", -c=>"$OUT$db1.$db2.table3c.tex", 
		 -d=>"$OUT$db1.$db2.table3d.tex"}, after=>"-p $db1 -q $db2");
	    make(script=>'table4.r', input=>{-i=>"$DIR$db1.$db2.bum_r.tab"}, output=>{-a=>"$OUT$db1.$db2.table4a.tex",-b=>"$OUT$db1.$db2.table4b.tex", -c=>"$OUT$db1.$db2.table4c.tex", 
		 -d=>"$OUT$db1.$db2.table4d.tex"}, after=>"-p $db1 -q $db2");

	    make(script=>'splicing3.r', input=>{-i=>"$DIR$db1.$db2.bum_s.tab"}, output=>{-o=>"$DIR$db1.$db2.plot3.tab"}, after=>"-p $db1 -q $db2");
	    make(script=>'splicing4.r', input=>{-i=>"$DIR$db1.$db2.bum_r.tab"}, output=>{-o=>"$DIR$db1.$db2.plot4.tab"}, after=>"-p $db1 -q $db2");
	    make(script=>'plot3.r', input=>{-i=>"$DIR$db1.$db2.plot3.tab"}, output=>{-o=>"$OUT$db1-$db2-plot3.pdf"});
	    make(script=>'plot4.r', input=>{-i=>"$DIR$db1.$db2.plot4.tab"}, output=>{-o=>"$OUT$db1-$db2-plot4.pdf"});

	    make(script=>"hamming1.pl", input=>{-in1=>"$DIR$db1.sss", -in2=>"$DIR$db2.sss", -map=>"$DIR$db1.$db2.bum_s.tab"}, output=>{'>'=>"$DIR$db1.$db2.hamming1"});
            make(script=>"hamming2.pl", input=>{-in1=>"$DIR$db1.sss", -in2=>"$DIR$db2.sss", -map=>"$DIR$db1.$db2.bum_r.tab"}, output=>{'>'=>"$DIR$db1.$db2.hamming2"});
	    make(script=>"strength2.r", input=>{-a=>"$DIR$db1.sss", -b=>"$DIR$db2.sss", -m=>"$DIR$db1.$db2.bum_s.tab"}, output=>{-o=>"$OUT$db1-$db2-strength2.pdf"}, after=>"-x $db1 -y $db2");

	    foreach $ext('sts', 'all') {
		make(script=>'join_pooled.r', input=>{-a=>"$DIR$db1.psi5.$ext", -b=>"$DIR$db1.psi3.$ext", -c=>"$DIR$db2.psi5.$ext", -d=>"$DIR$db2.psi3.$ext",  -m=>"$DIR$db1.$db2.bum_r.tab"}, 
					     output=>{-o=>"$DIR$db1.$db2.psi.$ext"});
		make(script=>'join_pooled.r', input=>{-a=>"$DIR$db1.cosi5.$ext",-b=>"$DIR$db1.cosi3.$ext",-c=>"$DIR$db2.cosi5.$ext",-d=>"$DIR$db2.cosi3.$ext", -m=>"$DIR$db1.$db2.bum_r.tab"}, 
					     output=>{-o=>"$DIR$db1.$db2.cosi.$ext"});
		make(script=>'join_single.r', input=>{-a=>"$DIR$db1.psi.$ext", -b=>"$DIR$db2.psi.$ext", -m=>"$DIR$db1.$db2.bum_r.tab"}, output=>{-o=> "$DIR$db1.$db2.psiex.$ext"});
	    }

	    %symbol = ('psi'=>'psi', 'cosi'=>'theta', 'psiex'=>'psi');
	    foreach $s(keys(%symbol)) {
		foreach $b(@BIOTYPES) {
		    make(script=>'chisqtest.r', input=>{-i=>"$DIR$db1.$db2.$s.sts"}, output=>{-o=>"$OUT$db1-$db2-$b-$s-chi.tex"}, after=>"-x $db1 -y $db2 -s $symbol{$s} -b $b -t 0.95");
		} 
		make(script=>"plot7.r",   input=>{-i=>"$DIR$db1.$db2.$s.sts"}, output=>{-o=>"$OUT$db1-$db2-$s.pdf"}, after=>"-x $db1 -y $db2 -s $symbol{$s}", mkdir=>T);
		make(script=>"hamming.r", input=>{-i=>"$DIR$db1.$db2.$s.sts", -j=>"$DIR$db1.$db2.hamming2"}, output=>{-o=>"$OUT$db1-$db2-$s-hamming.pdf"}, after=>"-s $symbol{$s}");
	    }
	}
    }
}

foreach $endpoint(@ARGV) {
    latex_file($endpoint);
}

sub latex_file {
    my $filename = @_[0];
    my $content =`cat $filename`;
    my %depend = ();
    while($content=~/\\includegraphics\[(.*)\]\{([\w\d\.\-\/]*)\}/g) {
	$depend{$2}++;
    }
    while($content=~/\\includegraphics\{([\w\d\.\-\/]*)\}/g) {
        $depend{$1}++;
    }
    while($content=~/\\input\{([\w\d\.\-\/]*)\}/g) {
        $depend{$1}++;
    }
    while($content=~/\\diagram\{([\w\d\.\-\/]*)\}/g) {
        $depend{$1}++;
    }
    my @arr =  split /\//, $filename;
    my $outname = pop(@arr);
    $outname=~s/tex$/pdf/;
print STDERR "[",join(" ", keys(%depend)), "] ";
    print "$OUT$outname : $filename ", join(" ", keys(%depend)), "\n\tpdflatex -output-directory=$OUT $filename\n";
    print "execute :: $OUT$outname\n";
}


