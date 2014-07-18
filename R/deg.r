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
}

data1 = process(read.delim(opt$seta))
data2 = process(read.delim(opt$setb))

map   = read.delim(opt$orth)

merge(merge(data1, map, by.x=0, by.y='ensg'), data2, by.x='ensmusg', by.y=0) -> data

apply(data, 1, function(x){wilcox.test(as.numeric(x[colnames(data1)]),as.numeric(x[colnames(data2)]), alternative = "two.sided")$p.value}) -> W
print(length(W[W*nrow(data)<0.05]))

apply(data, 1, function(x){var(x[colnames(data1)])*var(x[colnames(data2)])}) -> v
data3 = data[v>0,]

apply(data3, 1, function(x){t.test(as.numeric(x[colnames(data1)]),as.numeric(x[colnames(data2)]), alternative = "two.sided", var.equal =T)$p.value}) -> T
print(length(T[T*nrow(data3)<0.05]))

data4 = log10(data3[,c(colnames(data1),colnames(data2))])
apply(data4, 1, function(x){t.test(as.numeric(x[colnames(data1)]),as.numeric(x[colnames(data2)]), alternative = "two.sided", var.equal =T)$p.value}) -> T
print(length(T[T*nrow(data4)<0.05]))

qn <- function(x){qnorm(rank(x,ties.method="random")/(1+length(x)))}
QN <- function(A){for(i in 1:ncol(A)) {A[,i] = qn(A[,i])}; A}







