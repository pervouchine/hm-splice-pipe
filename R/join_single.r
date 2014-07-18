suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-a", "--one"), help="table input 1"),
                    make_option(c("-b", "--two"), help="table input 2"),
                    make_option(c("-m", "--map"), help="map file"),
                    make_option(c("-o", "--out"), help="joined output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

one = read.delim(opt$one)
two = read.delim(opt$two)
map = read.delim(opt$map, header=F)
fields = c('segm','type', 'gene','biotype', 'intern', 'level', 'alt')
colnames(map) = c(paste(fields, '1', sep='.'), paste(fields, '2', sep='.'), 'status')
map = subset(map,level.1==1 & level.2==1)
merge(merge(map, two, by.x='segm.2', by.y=0), one, by.x='segm.1', by.y=0) -> exon

write.table(exon, file=opt$out, row.names=F, col.names=T, quote=F, sep="\t")
