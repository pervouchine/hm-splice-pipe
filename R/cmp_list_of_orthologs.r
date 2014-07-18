suppressPackageStartupMessages(library(xtable))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-c", "--orthologs"), help="orthologs list"),
                    make_option(c("-x", "--out1"), help="tex output 1"),
		    make_option(c("-y", "--out2"), help="tex output 2"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

data1 = read.delim(opt$orthologs)
data2 = read.delim(opt$inp, header=F)

list1 = unique(data1[,c('ensg','ensmusg')])
list2 = unique(data2[,c(3,10)])
colnames(list2) = c('ensg','ensmusg')

list1a = subset(list1, ensg %in% list2$ensg & ensmusg %in% list2$ensmusg)
list2a = subset(list2, ensg %in% list1$ensg & ensmusg %in% list1$ensmusg) 

func <- function(x,caption="") {
    df = data.frame(x[,1])
    rownames(df) = c('Reference list','Test list','Common')
    df$V2 = round(c(100*x[3,1]/x[1,1], 100*x[3,1]/x[2,1],NA),digits=1)
    colnames(df) = c('Number of pairs',"%")
    xtable(df,caption=caption)
}

print(func(rbind(dim(list1),  dim(list2),  dim(merge(list1,list2))),caption="Ortholog list, all genes"),   table.placement="h!", file=opt$out1)
print(func(rbind(dim(list1a), dim(list2a), dim(merge(list1a,list2a))),caption="Ortholog list, common genes"), table.placement="h!",file=opt$out2)

