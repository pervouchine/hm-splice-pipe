data/gene_orthologs.tab : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/gene_orthologs.tab  -O data/gene_orthologs.tab  
output/hg19.mm9.orth1b.tex output/hg19.mm9.orth1a.tex : data/gene_orthologs.tab data/hg19.mm9.bum_s.tab
	mkdir -p output
	Rscript R/cmp_list_of_orthologs.r  -c data/gene_orthologs.tab -i data/hg19.mm9.bum_s.tab  -y output/hg19.mm9.orth1b.tex -x output/hg19.mm9.orth1a.tex  
data/hg19.gtf : 
	mkdir -p data
	curl http://genome.crg.eu/~dmitri/export/annotation/gen10.long.gncat.gtf.gz | gunzip | sed 's/gene_biotype/gene_type/g' > data/hg19.gtf  
data/hg19.exons : data/hg19.gtf
	mkdir -p data
	perl Perl/exons.pl  < data/hg19.gtf  > data/hg19.exons  
data/hg19.rel data/hg19.cps : data/hg19.exons data/hg19.counts.ssj.all
	mkdir -p data
	perl Perl/cps.pl  -exons data/hg19.exons -junctions data/hg19.counts.ssj.all  -rel data/hg19.rel -cps data/hg19.cps  
data/hg19.cps.srt : data/hg19.cps
	mkdir -p data
	cut -f1-3   data/hg19.cps | sort -u -k1,1 -k2,2n > data/hg19.cps.srt  
data/hg19.idx : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/hg19.idx  -O data/hg19.idx  
data/hg19.dbx : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/hg19.dbx  -O data/hg19.dbx  
data/hg19.genes.log.rpkm : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/RnaSeq.logrpkm.tsv  -O data/hg19.genes.log.rpkm  
execute :: data/hg19.genes.log.rpkm
rm-execute ::
	 rm -f data/hg19.genes.log.rpkm
data/hg19.psi5.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.psi5.tsv  -O data/hg19.psi5.all  
data/hg19.psi5.sts : data/hg19.psi5.all
	mkdir -p data
	Rscript R/stats.r  -i data/hg19.psi5.all  -o data/hg19.psi5.sts  
data/hg19.psi3.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.psi3.tsv  -O data/hg19.psi3.all  
data/hg19.psi3.sts : data/hg19.psi3.all
	mkdir -p data
	Rscript R/stats.r  -i data/hg19.psi3.all  -o data/hg19.psi3.sts  
data/hg19.cosi5.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.cosi5.tsv  -O data/hg19.cosi5.all  
data/hg19.cosi5.sts : data/hg19.cosi5.all
	mkdir -p data
	Rscript R/stats.r  -i data/hg19.cosi5.all  -o data/hg19.cosi5.sts  
data/hg19.cosi3.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.cosi3.tsv  -O data/hg19.cosi3.all  
data/hg19.cosi3.sts : data/hg19.cosi3.all
	mkdir -p data
	Rscript R/stats.r  -i data/hg19.cosi3.all  -o data/hg19.cosi3.sts  
data/hg19.psi.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.psi.tsv  -O data/hg19.psi.all  
data/hg19.psi.sts : data/hg19.psi.all
	mkdir -p data
	Rscript R/stats.r  -i data/hg19.psi.all  -o data/hg19.psi.sts  
data/hg19.counts.ssj.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/hg19/tx_paper.counts.ssj.tsv  -O data/hg19.counts.ssj.all  
data/hg19.sgn : data/hg19.dbx data/hg19.idx data/hg19.cps
	mkdir -p data
	maptools-1.0//bin/getwind  -dbx data/hg19.dbx -idx data/hg19.idx -in data/hg19.cps  -out data/hg19.sgn -we 3 -wi 15 -coord 1 -cis 
data/mm9.gtf : 
	mkdir -p data
	curl http://genome.crg.eu/~dmitri/export/annotation/mm65+lincRNA+pseudogenes.long.gncat.gtf.gz | gunzip | sed 's/gene_biotype/gene_type/g' > data/mm9.gtf  
data/mm9.exons : data/mm9.gtf
	mkdir -p data
	perl Perl/exons.pl  < data/mm9.gtf  > data/mm9.exons  
data/mm9.rel data/mm9.cps : data/mm9.exons data/mm9.counts.ssj.all
	mkdir -p data
	perl Perl/cps.pl  -exons data/mm9.exons -junctions data/mm9.counts.ssj.all  -rel data/mm9.rel -cps data/mm9.cps  
data/mm9.cps.srt : data/mm9.cps
	mkdir -p data
	cut -f1-3   data/mm9.cps | sort -u -k1,1 -k2,2n > data/mm9.cps.srt  
data/mm9.idx : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/mm9.idx  -O data/mm9.idx  
data/mm9.dbx : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/mm9.dbx  -O data/mm9.dbx  
data/mm9.genes.log.rpkm : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/RnaSeq.logrpkm.tsv  -O data/mm9.genes.log.rpkm  
execute :: data/mm9.genes.log.rpkm
rm-execute ::
	 rm -f data/mm9.genes.log.rpkm
data/mm9.psi5.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.psi5.tsv  -O data/mm9.psi5.all  
data/mm9.psi5.sts : data/mm9.psi5.all
	mkdir -p data
	Rscript R/stats.r  -i data/mm9.psi5.all  -o data/mm9.psi5.sts  
data/mm9.psi3.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.psi3.tsv  -O data/mm9.psi3.all  
data/mm9.psi3.sts : data/mm9.psi3.all
	mkdir -p data
	Rscript R/stats.r  -i data/mm9.psi3.all  -o data/mm9.psi3.sts  
data/mm9.cosi5.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.cosi5.tsv  -O data/mm9.cosi5.all  
data/mm9.cosi5.sts : data/mm9.cosi5.all
	mkdir -p data
	Rscript R/stats.r  -i data/mm9.cosi5.all  -o data/mm9.cosi5.sts  
data/mm9.cosi3.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.cosi3.tsv  -O data/mm9.cosi3.all  
data/mm9.cosi3.sts : data/mm9.cosi3.all
	mkdir -p data
	Rscript R/stats.r  -i data/mm9.cosi3.all  -o data/mm9.cosi3.sts  
data/mm9.psi.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.psi.tsv  -O data/mm9.psi.all  
data/mm9.psi.sts : data/mm9.psi.all
	mkdir -p data
	Rscript R/stats.r  -i data/mm9.psi.all  -o data/mm9.psi.sts  
data/mm9.counts.ssj.all : 
	mkdir -p data
	wget http://genome.crg.es/~dmitri/export-2.2/mm9/tx_paper.counts.ssj.tsv  -O data/mm9.counts.ssj.all  
data/mm9.sgn : data/mm9.dbx data/mm9.idx data/mm9.cps
	mkdir -p data
	maptools-1.0//bin/getwind  -dbx data/mm9.dbx -idx data/mm9.idx -in data/mm9.cps  -out data/mm9.sgn -we 3 -wi 15 -coord 1 -cis 
data/hg19.sss : data/hg19.sgn data/hg19.cps
	mkdir -p data
	perl Perl/pwm.pl  -sgn data/hg19.sgn -cps data/hg19.cps  > data/hg19.sss  
output/hg19.table1a.tex : data/hg19.cps
	mkdir -p output
	Rscript R/table1.r  -i data/hg19.cps  -o output/hg19.table1a.tex -n hg19 
output/hg19.table2a.tex : data/hg19.rel
	mkdir -p output
	Rscript R/table2.r  -i data/hg19.rel  -o output/hg19.table2a.tex -n hg19 
output/hg19-psi1.pdf : data/hg19.psi5.sts data/hg19.psi3.sts
	mkdir -p output
	Rscript R/psi1.r  -a data/hg19.psi5.sts -b data/hg19.psi3.sts  -o output/hg19-psi1.pdf  
output/hg19-cosi1.pdf : data/hg19.cosi5.sts data/hg19.cosi3.sts
	mkdir -p output
	Rscript R/psi1.r  -a data/hg19.cosi5.sts -b data/hg19.cosi3.sts  -o output/hg19-cosi1.pdf  
output/hg19-psi2.pdf : data/hg19.psi5.sts data/hg19.sss data/hg19.psi3.sts
	mkdir -p output
	Rscript R/psi2.r  -a data/hg19.psi5.sts -s data/hg19.sss -b data/hg19.psi3.sts  -o output/hg19-psi2.pdf -n hg19 -m psi 
output/hg19-cosi2.pdf : data/hg19.cosi5.sts data/hg19.sss data/hg19.cosi3.sts
	mkdir -p output
	Rscript R/psi2.r  -a data/hg19.cosi5.sts -s data/hg19.sss -b data/hg19.cosi3.sts  -o output/hg19-cosi2.pdf -n hg19 -m theta 
output/hg19-strength1.pdf : data/hg19.sss
	mkdir -p output
	Rscript R/strength1.r  -i data/hg19.sss  -o output/hg19-strength1.pdf  
data/mm9.sss : data/mm9.sgn data/mm9.cps
	mkdir -p data
	perl Perl/pwm.pl  -sgn data/mm9.sgn -cps data/mm9.cps  > data/mm9.sss  
output/mm9.table1a.tex : data/mm9.cps
	mkdir -p output
	Rscript R/table1.r  -i data/mm9.cps  -o output/mm9.table1a.tex -n mm9 
output/mm9.table2a.tex : data/mm9.rel
	mkdir -p output
	Rscript R/table2.r  -i data/mm9.rel  -o output/mm9.table2a.tex -n mm9 
output/mm9-psi1.pdf : data/mm9.psi5.sts data/mm9.psi3.sts
	mkdir -p output
	Rscript R/psi1.r  -a data/mm9.psi5.sts -b data/mm9.psi3.sts  -o output/mm9-psi1.pdf  
output/mm9-cosi1.pdf : data/mm9.cosi5.sts data/mm9.cosi3.sts
	mkdir -p output
	Rscript R/psi1.r  -a data/mm9.cosi5.sts -b data/mm9.cosi3.sts  -o output/mm9-cosi1.pdf  
output/mm9-psi2.pdf : data/mm9.psi5.sts data/mm9.sss data/mm9.psi3.sts
	mkdir -p output
	Rscript R/psi2.r  -a data/mm9.psi5.sts -s data/mm9.sss -b data/mm9.psi3.sts  -o output/mm9-psi2.pdf -n mm9 -m psi 
output/mm9-cosi2.pdf : data/mm9.cosi5.sts data/mm9.sss data/mm9.cosi3.sts
	mkdir -p output
	Rscript R/psi2.r  -a data/mm9.cosi5.sts -s data/mm9.sss -b data/mm9.cosi3.sts  -o output/mm9-cosi2.pdf -n mm9 -m theta 
output/mm9-strength1.pdf : data/mm9.sss
	mkdir -p output
	Rscript R/strength1.r  -i data/mm9.sss  -o output/mm9-strength1.pdf  
data/hg19.mm9.rBest.chain : 
	mkdir -p data
	wget http://bx.mathcs.emory.edu/~odenas/mapper_comparisons/UCSC/UCSC_reciprocal/hg19.mm9.rBest.chain  -O data/hg19.mm9.rBest.chain  
data/hg19.mm9.out : data/hg19.cps.srt data/hg19.mm9.rBest.chain
	mkdir -p data
	maptools-1.0//bin/map_agnostic  -in data/hg19.cps.srt -chain data/hg19.mm9.rBest.chain |sort -k1,1 -k2,2n  > data/hg19.mm9.out  
data/hg19.mm9.map : data/hg19.mm9.out data/mm9.hg19.out
	mkdir -p data
	perl Perl/map.pl  -src data/hg19.mm9.out -dst data/mm9.hg19.out  > data/hg19.mm9.map  
data/hg19.mm9.bum_r.tab data/hg19.mm9.bum_s.tab : data/mm9.rel data/hg19.mm9.map data/mm9.cps data/hg19.rel data/hg19.cps
	mkdir -p data
	perl Perl/bum.pl  -dst_rel data/mm9.rel -map data/hg19.mm9.map -dst_cps data/mm9.cps -src_rel data/hg19.rel -src_cps data/hg19.cps  -out_r data/hg19.mm9.bum_r.tab -out_s data/hg19.mm9.bum_s.tab  
output/hg19.mm9.table3a.tex output/hg19.mm9.table3c.tex output/hg19.mm9.table3b.tex output/hg19.mm9.table3d.tex : data/hg19.mm9.bum_s.tab
	mkdir -p output
	Rscript R/table3.r  -i data/hg19.mm9.bum_s.tab  -a output/hg19.mm9.table3a.tex -c output/hg19.mm9.table3c.tex -b output/hg19.mm9.table3b.tex -d output/hg19.mm9.table3d.tex -p hg19 -q mm9 
output/hg19.mm9.table4a.tex output/hg19.mm9.table4c.tex output/hg19.mm9.table4b.tex output/hg19.mm9.table4d.tex : data/hg19.mm9.bum_r.tab
	mkdir -p output
	Rscript R/table4.r  -i data/hg19.mm9.bum_r.tab  -a output/hg19.mm9.table4a.tex -c output/hg19.mm9.table4c.tex -b output/hg19.mm9.table4b.tex -d output/hg19.mm9.table4d.tex -p hg19 -q mm9 
data/hg19.mm9.plot3.tab : data/hg19.mm9.bum_s.tab
	mkdir -p data
	Rscript R/splicing3.r  -i data/hg19.mm9.bum_s.tab  -o data/hg19.mm9.plot3.tab -p hg19 -q mm9 
data/hg19.mm9.plot4.tab : data/hg19.mm9.bum_r.tab
	mkdir -p data
	Rscript R/splicing4.r  -i data/hg19.mm9.bum_r.tab  -o data/hg19.mm9.plot4.tab -p hg19 -q mm9 
output/hg19-mm9-plot3.pdf : data/hg19.mm9.plot3.tab
	mkdir -p output
	Rscript R/plot3.r  -i data/hg19.mm9.plot3.tab  -o output/hg19-mm9-plot3.pdf  
output/hg19-mm9-plot4.pdf : data/hg19.mm9.plot4.tab
	mkdir -p output
	Rscript R/plot4.r  -i data/hg19.mm9.plot4.tab  -o output/hg19-mm9-plot4.pdf  
data/hg19.mm9.hamming1 : data/hg19.mm9.bum_s.tab data/mm9.sss data/hg19.sss
	mkdir -p data
	perl Perl/hamming1.pl  -map data/hg19.mm9.bum_s.tab -in2 data/mm9.sss -in1 data/hg19.sss  > data/hg19.mm9.hamming1  
data/hg19.mm9.hamming2 : data/hg19.mm9.bum_r.tab data/mm9.sss data/hg19.sss
	mkdir -p data
	perl Perl/hamming2.pl  -map data/hg19.mm9.bum_r.tab -in2 data/mm9.sss -in1 data/hg19.sss  > data/hg19.mm9.hamming2  
output/hg19-mm9-strength2.pdf : data/hg19.sss data/hg19.mm9.bum_s.tab data/mm9.sss
	mkdir -p output
	Rscript R/strength2.r  -a data/hg19.sss -m data/hg19.mm9.bum_s.tab -b data/mm9.sss  -o output/hg19-mm9-strength2.pdf -x hg19 -y mm9 
data/hg19.mm9.psi.sts : data/hg19.psi5.sts data/mm9.psi5.sts data/hg19.mm9.bum_r.tab data/hg19.psi3.sts data/mm9.psi3.sts
	mkdir -p data
	Rscript R/join_pooled.r  -a data/hg19.psi5.sts -c data/mm9.psi5.sts -m data/hg19.mm9.bum_r.tab -b data/hg19.psi3.sts -d data/mm9.psi3.sts  -o data/hg19.mm9.psi.sts  
data/hg19.mm9.cosi.sts : data/hg19.cosi5.sts data/mm9.cosi5.sts data/hg19.mm9.bum_r.tab data/hg19.cosi3.sts data/mm9.cosi3.sts
	mkdir -p data
	Rscript R/join_pooled.r  -a data/hg19.cosi5.sts -c data/mm9.cosi5.sts -m data/hg19.mm9.bum_r.tab -b data/hg19.cosi3.sts -d data/mm9.cosi3.sts  -o data/hg19.mm9.cosi.sts  
data/hg19.mm9.psiex.sts : data/hg19.psi.sts data/hg19.mm9.bum_r.tab data/mm9.psi.sts
	mkdir -p data
	Rscript R/join_single.r  -a data/hg19.psi.sts -m data/hg19.mm9.bum_r.tab -b data/mm9.psi.sts  -o data/hg19.mm9.psiex.sts  
data/hg19.mm9.psi.all : data/hg19.psi5.all data/mm9.psi5.all data/hg19.mm9.bum_r.tab data/hg19.psi3.all data/mm9.psi3.all
	mkdir -p data
	Rscript R/join_pooled.r  -a data/hg19.psi5.all -c data/mm9.psi5.all -m data/hg19.mm9.bum_r.tab -b data/hg19.psi3.all -d data/mm9.psi3.all  -o data/hg19.mm9.psi.all  
data/hg19.mm9.cosi.all : data/hg19.cosi5.all data/mm9.cosi5.all data/hg19.mm9.bum_r.tab data/hg19.cosi3.all data/mm9.cosi3.all
	mkdir -p data
	Rscript R/join_pooled.r  -a data/hg19.cosi5.all -c data/mm9.cosi5.all -m data/hg19.mm9.bum_r.tab -b data/hg19.cosi3.all -d data/mm9.cosi3.all  -o data/hg19.mm9.cosi.all  
data/hg19.mm9.psiex.all : data/hg19.psi.all data/hg19.mm9.bum_r.tab data/mm9.psi.all
	mkdir -p data
	Rscript R/join_single.r  -a data/hg19.psi.all -m data/hg19.mm9.bum_r.tab -b data/mm9.psi.all  -o data/hg19.mm9.psiex.all  
output/hg19-mm9-long_non_coding-psiex-chi.tex : data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-long_non_coding-psiex-chi.tex -x hg19 -y mm9 -s psi -b long_non_coding -t 0.95 
output/hg19-mm9-multi_orth-psiex-chi.tex : data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-multi_orth-psiex-chi.tex -x hg19 -y mm9 -s psi -b multi_orth -t 0.95 
output/hg19-mm9-ortholog-psiex-chi.tex : data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-ortholog-psiex-chi.tex -x hg19 -y mm9 -s psi -b ortholog -t 0.95 
output/hg19-mm9-unique-psiex-chi.tex : data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-unique-psiex-chi.tex -x hg19 -y mm9 -s psi -b unique -t 0.95 
output/hg19-mm9-psiex.pdf : data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/plot7.r  -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-psiex.pdf -x hg19 -y mm9 -s psi 
output/hg19-mm9-psiex-hamming.pdf : data/hg19.mm9.hamming2 data/hg19.mm9.psiex.sts
	mkdir -p output
	Rscript R/hamming.r  -j data/hg19.mm9.hamming2 -i data/hg19.mm9.psiex.sts  -o output/hg19-mm9-psiex-hamming.pdf -s psi 
output/hg19-mm9-long_non_coding-psi-chi.tex : data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-long_non_coding-psi-chi.tex -x hg19 -y mm9 -s psi -b long_non_coding -t 0.95 
output/hg19-mm9-multi_orth-psi-chi.tex : data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-multi_orth-psi-chi.tex -x hg19 -y mm9 -s psi -b multi_orth -t 0.95 
output/hg19-mm9-ortholog-psi-chi.tex : data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-ortholog-psi-chi.tex -x hg19 -y mm9 -s psi -b ortholog -t 0.95 
output/hg19-mm9-unique-psi-chi.tex : data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-unique-psi-chi.tex -x hg19 -y mm9 -s psi -b unique -t 0.95 
output/hg19-mm9-psi.pdf : data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/plot7.r  -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-psi.pdf -x hg19 -y mm9 -s psi 
output/hg19-mm9-psi-hamming.pdf : data/hg19.mm9.hamming2 data/hg19.mm9.psi.sts
	mkdir -p output
	Rscript R/hamming.r  -j data/hg19.mm9.hamming2 -i data/hg19.mm9.psi.sts  -o output/hg19-mm9-psi-hamming.pdf -s psi 
output/hg19-mm9-long_non_coding-cosi-chi.tex : data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-long_non_coding-cosi-chi.tex -x hg19 -y mm9 -s theta -b long_non_coding -t 0.95 
output/hg19-mm9-multi_orth-cosi-chi.tex : data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-multi_orth-cosi-chi.tex -x hg19 -y mm9 -s theta -b multi_orth -t 0.95 
output/hg19-mm9-ortholog-cosi-chi.tex : data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-ortholog-cosi-chi.tex -x hg19 -y mm9 -s theta -b ortholog -t 0.95 
output/hg19-mm9-unique-cosi-chi.tex : data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/chisqtest.r  -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-unique-cosi-chi.tex -x hg19 -y mm9 -s theta -b unique -t 0.95 
output/hg19-mm9-cosi.pdf : data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/plot7.r  -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-cosi.pdf -x hg19 -y mm9 -s theta 
output/hg19-mm9-cosi-hamming.pdf : data/hg19.mm9.hamming2 data/hg19.mm9.cosi.sts
	mkdir -p output
	Rscript R/hamming.r  -j data/hg19.mm9.hamming2 -i data/hg19.mm9.cosi.sts  -o output/hg19-mm9-cosi-hamming.pdf -s theta 
data/mm9.hg19.rBest.chain : 
	mkdir -p data
	wget http://bx.mathcs.emory.edu/~odenas/mapper_comparisons/UCSC/UCSC_reciprocal/mm9.hg19.rBest.chain  -O data/mm9.hg19.rBest.chain  
data/mm9.hg19.out : data/mm9.cps.srt data/mm9.hg19.rBest.chain
	mkdir -p data
	maptools-1.0//bin/map_agnostic  -in data/mm9.cps.srt -chain data/mm9.hg19.rBest.chain |sort -k1,1 -k2,2n  > data/mm9.hg19.out  
output/summary.pdf : Latex/summary.tex Latex/main_legend_2.pdf output/hg19-mm9-cosi.pdf output/hg19.mm9.table4b.tex output/mm9-psi2.pdf output/hg19-mm9-plot4.pdf output/hg19.mm9.orth1b.tex output/hg19-psi2.pdf output/hg19.mm9.table4d.tex output/hg19.mm9.table4a.tex output/hg19-mm9-psiex.pdf output/hg19.mm9.orth1a.tex output/hg19.mm9.table4c.tex output/hg19.mm9.table3d.tex output/hg19.mm9.table3c.tex output/hg19-mm9-psi.pdf output/hg19.mm9.table3b.tex Latex/main_legend_1.pdf output/mm9-strength1.pdf Latex/psi_def_figure1.pdf output/hg19-mm9-strength2.pdf output/hg19-mm9-plot3.pdf output/mm9.table2a.tex Latex/psi_example.pdf Latex/psi_def_figure2.pdf output/hg19-strength1.pdf output/mm9-cosi2.pdf output/hg19.table2a.tex output/hg19.table1a.tex output/hg19-cosi2.pdf output/hg19.mm9.table3a.tex output/mm9.table1a.tex
	pdflatex -output-directory=output/ Latex/summary.tex
execute :: output/summary.pdf
output/integrative_paper_figure.pdf : Latex/integrative_paper_figure.tex output/hg19-mm9-psi.pdf
	pdflatex -output-directory=output/ Latex/integrative_paper_figure.tex
execute :: output/integrative_paper_figure.pdf
output/companion_paper_figure.pdf : Latex/companion_paper_figure.tex output/mm9-psi2.pdf output/hg19-mm9-cosi.pdf output/hg19-psi2.pdf output/mm9-strength1.pdf output/hg19-mm9-psi.pdf output/hg19-strength1.pdf output/mm9-cosi2.pdf output/hg19-cosi2.pdf
	pdflatex -output-directory=output/ Latex/companion_paper_figure.tex
execute :: output/companion_paper_figure.pdf
