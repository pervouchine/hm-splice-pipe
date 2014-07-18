suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-a", "--one5"), help="5' table input 1"),
                    make_option(c("-b", "--one3"), help="3' table input 1"),
		    make_option(c("-c", "--two5"), help="5' table input 2"),
                    make_option(c("-d", "--two3"), help="3' table input 2"),
		    make_option(c("-m", "--map"), help="map file"),
                    make_option(c("-o", "--out"), help="joined output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

one5 = read.delim(opt$one5)
one3 = read.delim(opt$one3)

two5 = read.delim(opt$two5)
two3 = read.delim(opt$two3)

map = read.delim(opt$map, header=F)
fields = c('segm','type', 'gene','biotype', 'intern', 'level', 'alt')
colnames(map) = c(paste(fields, '1', sep='.'), paste(fields, '2', sep='.'), 'status')

map = subset(map,level.1==1 & level.2==1 & status==STATUS_121)

merge(merge(map, two5, by.x='segm.2', by.y=0), one5, by.x='segm.1', by.y=0) -> intr5
merge(merge(map, two3, by.x='segm.2', by.y=0), one3, by.x='segm.1', by.y=0) -> intr3

intr5$ind = '5'
intr3$ind = '3'

data = rbind(intr5, intr3)

write.table(data, file=opt$out, row.names=F, col.names=T, quote=F, sep="\t")
