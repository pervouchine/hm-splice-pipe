suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library("optparse"))

option_list <- list(make_option(c("-i", "--inp"), help="table input"),
                    make_option(c("-m", "--map"), help="ortholog list"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r")
source("R/graphics.r")

set_ggplot_theme()

process <- function(x) {
    x[is.na(x)] <- -Inf
    x = 10^x
    avg = apply(x, 1, mean)
    sd  = apply(x, 1, sd)
    cbind(x,avg,sd)
}

data1 = process(read.delim(opt$inp))
map   = read.delim(opt$map, header=F)
map$V1 = gsub("\\.\\d", "", map$V1)


merge(data1, map, by.x=0, by.y=1) -> data
data$Category = factor_biotype(data$V2)

log_breaks = seq(-3,3,1)

pdf(opt$out,width=normal_w, height=normal_h)
p = ggplot(data, aes(x=log10(avg),colour=Category)) + stat_density(size=1,position="identity",geom="line")
p + scale_x_continuous(breaks = log_breaks, labels=10^log_breaks) + xlab("AVG gene RPKM, human") + ylab("Density") + my_colour_palette1()
dev.off()

