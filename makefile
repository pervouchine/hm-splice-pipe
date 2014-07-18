PDIR=Perl/
LDIR=Latex/
RDIR=R/
MAPTOOLSDIR=maptools-1.0/

include special.mk

${MAPTOOLSDIR}bin/getsegm :
	wget https://github.com/pervouchine/maptools/archive/v1.0.tar.gz -O v1.0.tar.gz
	tar -xf v1.0.tar.gz
	rm -f v1.0.tar.gz
	mkdir -p ${MAPTOOLSDIR}bin/
	make -C ${MAPTOOLSDIR} all

all     :: ${MAPTOOLSDIR}bin/getsegm hg19.mm9.mk

hg19.mm9.mk : $(PDIR)make.pl ${LDIR}summary.tex ${LDIR}integrative_paper_figure.tex makefile
	perl $(PDIR)make.pl hg19,mm9 ${LDIR}summary.tex ${LDIR}integrative_paper_figure.tex ${LDIR}companion_paper_figure.tex > hg19.mm9.mk
	sleep 0.1

EXPORT=human-mouse-2.2

export:
	mkdir ${EXPORT}/
	cp -r ${PDIR} ${EXPORT}/
	cp -r ${LDIR} ${EXPORT}/
	cp -r ${RDIR} ${EXPORT}/
	cp *.mk ${EXPORT}/
	cp makefile ${EXPORT}/
	cp README ${EXPORT}/
	cp *.dat ${EXPORT}/
	tar -cf ${EXPORT}.tar ${EXPORT}/
	gzip ${EXPORT}.tar


