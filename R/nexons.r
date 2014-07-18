suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library("optparse"))

option_list <- list(make_option(c("-i", "--inp"), help=""),
                    make_option(c("-t", "--ttl"), help=""),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))


source("R/definitions.r")
source("R/graphics.r")

set_ggplot_theme()

data = read.delim(opt$inp, header=F)

data$Category = factor_biotype(data$V4)

name = factor_Species(opt$ttl)

pdf(opt$out, onefile=T)

count(data, c('V3','Category')) -> dist

p = ggplot(dist, aes(Category, freq)) + geom_boxplot(aes(fill=Category),outlier.shape=NA,notch=T) + coord_flip() + scale_y_log10() 
p + ggtitle(paste(name, 'genes')) + ylab("Number of exons") +  my_fill_palette1() + theme(legend.position="none") + xlab("")

dev.off()

