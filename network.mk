include makefile
ORTH=~/public_html/export/human/gene_orthologs.tab

${METADIR}hs.glasso.500.tab ${METADIR}mm.glasso.500.tab : ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} ${RDIR}glasso.r 
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 500 ${METADIR}hs.glasso.500.tab ${METADIR}mm.glasso.500.tab < ${RDIR}glasso.r 

${METADIR}hs.glasso.1000.tab ${METADIR}mm.glasso.1000.tab : ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} ${RDIR}glasso.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 1000 ${METADIR}hs.glasso.1000.tab ${METADIR}mm.glasso.1000.tab < ${RDIR}glasso.r

${METADIR}hs.glasso.2000.tab ${METADIR}mm.glasso.2000.tab : ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} ${RDIR}glasso.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 2000 ${METADIR}hs.glasso.2000.tab ${METADIR}mm.glasso.2000.tab < ${RDIR}glasso.r

${METADIR}hs.glasso.3000.tab ${METADIR}mm.glasso.3000.tab : ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} ${RDIR}glasso.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 3000 ${METADIR}hs.glasso.3000.tab ${METADIR}mm.glasso.3000.tab < ${RDIR}glasso.r



${OUTDIR}net1000.pdf : ${METADIR}hs.glasso.1000.tab ${METADIR}mm.glasso.1000.tab ${RDIR}network.r 
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 1000 ${METADIR}hs.glasso.1000.tab ${METADIR}mm.glasso.1000.tab ${OUTDIR}net1000.pdf<${RDIR}network.r

${OUTDIR}net2000.pdf : ${METADIR}hs.glasso.2000.tab ${METADIR}mm.glasso.2000.tab ${RDIR}network.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 2000 ${METADIR}hs.glasso.2000.tab ${METADIR}mm.glasso.2000.tab ${OUTDIR}net2000.pdf<${RDIR}network.r

${OUTDIR}net3000.pdf : ${METADIR}hs.glasso.3000.tab ${METADIR}mm.glasso.3000.tab ${RDIR}network.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 3000 ${METADIR}hs.glasso.3000.tab ${METADIR}mm.glasso.3000.tab ${OUTDIR}net3000.pdf<${RDIR}network.r

${OUTDIR}net500.pdf : ${METADIR}hs.glasso.500.tab ${METADIR}mm.glasso.500.tab ${RDIR}network.r
	R ${RMODE} ${INPUTDIR}hg19.genes.log.rpkm.all ${INPUTDIR}mm9.genes.log.rpkm.all ${ORTH} 500 ${METADIR}hs.glasso.500.tab ${METADIR}mm.glasso.500.tab ${OUTDIR}net500.pdf < ${RDIR}network.r


all :: ${OUTDIR}net1000.pdf ${OUTDIR}net2000.pdf ${OUTDIR}net3000.pdf ${OUTDIR}net500.pdf
