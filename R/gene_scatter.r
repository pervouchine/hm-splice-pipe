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
    dr = apply(x,1 , function(x){max(x,na.rm=T) - min(x,na.rm=T)})
    n = apply(x,1 , function(x){length(x[!is.na(x)])})
    x[is.na(x)] <- -Inf
    x = 10^x + pseudocount
    avg = apply(x, 1, mean)
    sd  = apply(x, 1, sd)
    ent = apply(x, 1, entropy)
    cbind(x,avg,sd,ent,dr,n)
}

data1 = process(read.delim(opt$seta))
data2 = process(read.delim(opt$setb))

map   = read.delim(opt$orth)

log_breaks1 =   c(-3, -2, -1, 0, 1, 2, 3)
log_breaks2 = c(-Inf, -2, -1, 0, 1, 2, 3)

merge(merge(data1, map, by.x=0, by.y='ensg'), data2, by.x='ensmusg', by.y=0) -> data

pdf(opt$out, width=normal_w, height=normal_h)

df = subset(data, avg.x>0 & avg.y>0)
p = ggplot(df, aes(x=log10(avg.x), y=log10(avg.y))) + stat_bin2d(bins=100) + scale_fill_gradientn("# of genes",colours=terrain.colors(20),trans="log10")
p <- p + xlab("AVG gene RPKM, human") + ylab("AVG gene RPKM, mouse") + scale_x_continuous(breaks = log_breaks1, labels=10^log_breaks2) + scale_y_continuous(breaks = log_breaks1, labels=10^log_breaks2)
p + ggtitle(paste('r =',cor(log10(df$avg.x), log10(df$avg.y))))
p

res=data.frame()
for(base in c(2,2.71828,3,4,10)) {
    for(delta in c(1,2,3)) {
    	res = rbind(res,(c(base, delta, dim(subset(data,abs(log(avg.x) - log(avg.y))/log(base)>=delta))[1]/dim(data)[1])))
    }
}
colnames(res) = c('base','delta','value')
library(reshape)
cast(res, base~delta) -> A
print(A, digits=2)

data3 = subset(data, n.x==18 & n.y==30)
print(dim(data3))
print(dim(subset(data3,dr.x<2)))
print(dim(subset(data3,dr.y<2)))
print(dim(subset(data3,dr.x<2 & dr.y<2)))

log_breaks = c(-2, -1, 0, 1, 2, 3)
df = subset(data, sd.x>0 & sd.y>0)
p = ggplot(df, aes(x=log10(sd.x), y=log10(sd.y))) + stat_bin2d(bins=100) + scale_fill_gradientn("# of genes",colours=terrain.colors(20),trans="log10") 
p <- p + xlab("SD gene RPKM, human") + ylab("SD gene RPKM, mouse") + scale_x_continuous(breaks = log_breaks, labels=10^log_breaks) + scale_y_continuous(breaks = log_breaks, labels=10^log_breaks)
p + ggtitle(paste('r =',cor(log10(df$sd.x), log10(df$sd.y))))


p = ggplot(df, aes(x=avg.x/sd.x, y=avg.y/sd.y)) + stat_bin2d(bins=100) + scale_fill_gradientn("# of genes",colours=terrain.colors(20),trans="log10")
p <- p + xlab("CV gene RPKM, human") + ylab("CV gene RPKM, mouse")
p + ggtitle(paste('r =',with(df,cor(avg.x/sd.x, avg.y/sd.y))))


p = ggplot(data, aes(x=ent.x, y=ent.y)) + stat_bin2d(bins=100) + scale_fill_gradientn("# of genes",colours=terrain.colors(20),trans="log10") 
p <- p + xlab("Entropy of gene RPKM, human") + ylab("Entropy of gene RPKM, mouse")
p + ggtitle(paste('r =',cor(df$ent.x, df$ent.y)))

