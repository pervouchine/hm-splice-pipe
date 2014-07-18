suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library("optparse"))

option_list <- list(make_option(c("-a", "--seta"), help="table input A"),
                    make_option(c("-b", "--setb"), help="table input B"),
                    make_option(c("-m", "--orth"), help="ortholog list"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r")
source("R/graphics.r")

set_ggplot_theme()

entropy <- function(x){s=sum(x);x[x==0]<-1; log2(s)-sum(x*log2(x))/s}
pseudocount = 1E-3

process <- function(x) {
    x[is.na(x)] <- -Inf
    x = 10^x + pseudocount
    avg = apply(x, 1, mean)
    fn  = as.matrix(t(apply(log10(x), 1, fivenum)))
    cbind(x,avg=log10(avg),med=fn[,3],lq=fn[,2],uq=fn[,4],iqr=fn[,4]-fn[,2],dr=fn[,5]-fn[,1])
}

data1 = process(read.delim(opt$seta))
data2 = process(read.delim(opt$setb))

map   = read.delim(opt$orth)

log_breaks1 =   c(-3, -2, -1, 0, 1, 2, 3)
log_breaks2 = c(-Inf, -2, -1, 0, 1, 2, 3)

merge(merge(data1, map, by.x=0, by.y='ensg'), data2, by.x='ensmusg', by.y=0) -> data

pdf(opt$out,width=normal_w, height=normal_h)
ggplot(data[sample(rownames(data),1000),], aes(x=med.x, y=med.y)) + geom_point(size=1) + geom_errorbar(aes(ymin=lq.y,ymax=uq.y)) + geom_errorbarh(aes(xmin=lq.x,xmax=uq.x)) + scale_x_continuous(breaks = log_breaks1, labels=10^log_breaks2) + scale_y_continuous(breaks = log_breaks1, labels=10^log_breaks2)

suppressPackageStartupMessages(library(reshape))

t = 1
data$r1 = cut(data$iqr.x, breaks=c(0,t,+Inf), include.lowest=T)
data$r2 = cut(data$iqr.y, breaks=c(0,t,+Inf), include.lowest=T)
data$r = paste(data$r1, data$r2, sep="_")
print(count(data,c('r1','r2')))


p = ggplot(data, aes(x=avg.x, y=avg.y, color=r)) + geom_point(size=1) + scale_colour_brewer(palette="Set1",name="IQR")
p + xlab("AVG gene RPKM, human") + ylab("AVG gene RPKM, mouse") + scale_x_continuous(breaks = log_breaks1, labels=10^log_breaks2) + scale_y_continuous(breaks = log_breaks1, labels=10^log_breaks2)


t=2
data$r1 = cut(data$dr.x, breaks=c(0,t,+Inf), include.lowest=T)
data$r2 = cut(data$dr.y, breaks=c(0,t,+Inf), include.lowest=T)
data$r = paste(data$r1, data$r2, sep="_")
print(count(data,c('r1','r2')))


p = ggplot(data, aes(x=avg.x, y=avg.y, color=r)) + geom_point(size=1) + scale_colour_brewer(palette="Set1",name="DR")
p + xlab("AVG gene RPKM, human") + ylab("AVG gene RPKM, mouse") + scale_x_continuous(breaks = log_breaks1, labels=10^log_breaks2) + scale_y_continuous(breaks = log_breaks1, labels=10^log_breaks2)

dev.off()







