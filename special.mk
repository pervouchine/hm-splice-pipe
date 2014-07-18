${METADIR}gene_orthologs.tab :
	wget http://genome.crg.es/~dmitri/export/human/gene_orthologs.tab -O ${METADIR}gene_orthologs.tab

${OUTDIR}hg19.mm9.orth1a.tex ${OUTDIR}hg19.mm9.orth1b.tex : ${METADIR}gene_orthologs.tab ${METADIR}hg19.mm9.bum_s.tab ${RDIR}cmp_list_of_orthologs.r
	R ${RMODE} ${METADIR}gene_orthologs.tab ${METADIR}hg19.mm9.bum_s.tab ${OUTDIR}hg19.mm9.orth1a.tex ${OUTDIR}hg19.mm9.orth1b.tex  < ${RDIR}cmp_list_of_orthologs.r

#execute :: ${METADIR}cmp_list_of_orthologs.tab
