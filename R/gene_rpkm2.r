suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library("optparse"))

option_list <- list(make_option(c("-a", "--seta"), help="table input"),
		    make_option(c("-b", "--setb"), help="table input"),
                    make_option(c("-x", "--mapa"), help="map a"),
		    make_option(c("-y", "--mapb"), help="map b"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))


source("R/definitions.r")
source("R/graphics.r")

set_ggplot_theme()

entropy <- function(x){s=sum(x);x[x==0]<-1; log(s)-sum(x*log(x))/s}

process <- function(x) {
    x[is.na(x)] <- -Inf
    x = 10^x
    avg = apply(x, 1, mean)
    sd  = apply(x, 1, sd)
    ent = apply(x, 1, entropy)
    cbind(x,avg,sd,ent)
}

func <- function(file1, file2, species) {
    data1 = process(read.delim(file1))
    map   = read.delim(file2, header=F)
    map$V1 = gsub("\\.\\d", "", map$V1)

    merge(data1, map, by.x=0, by.y=1) -> data
    data$Category = factor_biotype(data$V2)
    data$Species = species

    data[,c('avg','sd','ent','Category','Species')]
}

data1 = func(opt$seta, opt$mapa, 'Human')
data2 = func(opt$setb, opt$mapb, 'Mouse')

data = rbind(data1,data2)

log_breaks = seq(-3,3,1)

pdf(opt$out,width=normal_w+1, height=normal_h)
p = ggplot(data, aes(x=log10(avg),colour=Category,linetype=Species)) + stat_density(size=1,position="identity",geom="line")
p + scale_x_continuous(breaks = log_breaks, labels=10^log_breaks) + xlab("AVG gene RPKM") + ylab("Density") + my_colour_palette1()

dev.off()

