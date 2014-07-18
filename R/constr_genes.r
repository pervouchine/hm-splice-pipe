suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library("optparse"))

option_list <- list(make_option(c("-a", "--seta"), help="table input A"),
                    make_option(c("-b", "--setb"), help="table input B"),
                    make_option(c("-m", "--orth"), help="ortholog list"),
                    make_option(c("-o", "--out"), help="tsv output"))

opt <- parse_args(OptionParser(option_list=option_list))

set_ggplot_theme()

process <- function(x) {
    x[is.na(x)] <- -Inf
    10^x
}

data1 = process(read.delim(opt$seta))
data2 = process(read.delim(opt$setb))

map   = read.delim(opt$orth)

merge(merge(data1, map, by.x=0, by.y='ensg'), data2, by.x='ensmusg', by.y=0) -> data

rownames(data) = data$Row.names
data = data[,c(colnames(data1),colnames(data2))]

DNR <- function(x){
    y = x[!is.na(x) & x>0]
    if(length(y)>=2) {
        log10(max(y))-log10(min(y))
    }
    else {
        +Inf
    }
}

apply(data, 1, DNR) -> res




