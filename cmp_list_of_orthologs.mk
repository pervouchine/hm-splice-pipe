include makefile

${METADIR}gene_orthologs.tab :
	wget http://genome.crg.es/~dmitri/export/human/gene_orthologs.tab -O ${METADIR}gene_orthologs.tab

${METADIR}cmp_list_of_orthologs.tab : ${METADIR}gene_orthologs.tab ${METADIR}hg19.mm9.bum_s.tab ${RDIR}cmp_list_of_orthologs.r
	R ${RMODE} ${METADIR}gene_orthologs.tab ${METADIR}hg19.mm9.bum_s.tab < ${RDIR}cmp_list_of_orthologs.r > ${METADIR}cmp_list_of_orthologs.tab


execute :: ${METADIR}cmp_list_of_orthologs.tab
