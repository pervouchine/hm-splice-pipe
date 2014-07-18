include makefile

DATADIR=data/
OUTDIR=output/

execute :: ${OUTDIR}hg19-mm9-gene-scatter.pdf

${OUTDIR}hg19-mm9-gene-scatter.pdf : ${DATADIR}hg19.genes.log.rpkm ${DATADIR}mm9.genes.log.rpkm ${DATADIR}gene_orthologs.tab ${RDIR}gene_scatter.r
	Rscript ${RDIR}gene_scatter.r -a ${DATADIR}hg19.genes.log.rpkm -b ${DATADIR}mm9.genes.log.rpkm -m ${DATADIR}gene_orthologs.tab -o ${OUTDIR}hg19-mm9-gene-scatter.pdf

${DATADIR}hg19.genes.tab : ${DATADIR}hg19.exons
	cut -f3,4 ${DATADIR}hg19.exons | sort -u > ${DATADIR}hg19.genes.tab


${DATADIR}mm9.genes.tab : ${DATADIR}mm9.exons
	cut -f3,4 ${DATADIR}mm9.exons  | sort -u > ${DATADIR}mm9.genes.tab

execute :: ${OUTDIR}hg19-gene-rpkm.pdf ${OUTDIR}mm9-gene-rpkm.pdf

${OUTDIR}hg19-gene-rpkm.pdf : ${DATADIR}hg19.genes.log.rpkm ${DATADIR}hg19.genes.tab ${RDIR}gene_rpkm1.r
	Rscript ${RDIR}gene_rpkm1.r -i ${DATADIR}hg19.genes.log.rpkm -m ${DATADIR}hg19.genes.tab -o ${OUTDIR}hg19-gene-rpkm.pdf

${OUTDIR}mm9-gene-rpkm.pdf : ${DATADIR}mm9.genes.log.rpkm ${DATADIR}mm9.genes.tab ${RDIR}gene_rpkm1.r
	Rscript ${RDIR}gene_rpkm1.r -i ${DATADIR}mm9.genes.log.rpkm  -m ${DATADIR}mm9.genes.tab  -o ${OUTDIR}mm9-gene-rpkm.pdf

execute :: ${OUTDIR}hg19-mm9-gene-rpkm.pdf 

${OUTDIR}hg19-mm9-gene-rpkm.pdf : ${DATADIR}hg19.genes.log.rpkm ${DATADIR}hg19.genes.tab ${DATADIR}mm9.genes.log.rpkm ${DATADIR}mm9.genes.tab ${RDIR}gene_rpkm2.r
	Rscript ${RDIR}gene_rpkm2.r -a ${DATADIR}hg19.genes.log.rpkm -x ${DATADIR}hg19.genes.tab -b ${DATADIR}mm9.genes.log.rpkm -y ${DATADIR}mm9.genes.tab -o ${OUTDIR}hg19-mm9-gene-rpkm.pdf

execute :: ${OUTDIR}hg19-nexons.pdf ${OUTDIR}mm9-nexons.pdf

${OUTDIR}hg19-nexons.pdf : ${DATADIR}hg19.exons ${RDIR}nexons.r
	Rscript ${RDIR}nexons.r -i ${DATADIR}hg19.exons -t hg19 -o ${OUTDIR}hg19-nexons.pdf 

${OUTDIR}mm9-nexons.pdf : ${DATADIR}mm9.exons ${RDIR}nexons.r
	Rscript ${RDIR}nexons.r -i ${DATADIR}mm9.exons  -t mm9  -o ${OUTDIR}mm9-nexons.pdf
