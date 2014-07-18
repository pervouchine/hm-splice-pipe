suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-o", "--out"), help="sts output"))

opt <- parse_args(OptionParser(option_list=option_list))

print(opt$inp)
data = read.delim(opt$inp)
t(apply(data,1,function(x){c(fivenum(x),mean(x,na.rm=T),var(x,na.rm=T),length(x[!is.na(x)]))})) -> res

colnames(res) = c('min','lq','med','uq','max','mean','var','n')
print(opt$out)
write.table(res, file=opt$out, row.names=T, col.names=T, quote=F, sep="\t")

