suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library('plyr'))

option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-o", "--out"), help="pdf output"),
                    make_option(c("-p", "--species1"), help="species 1 name"),
                    make_option(c("-q", "--species2"), help="species 2 name"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

data = read.delim(opt$inp, header=F)

fields = c('chr_pos_str','type','gene','biotype', 'intern','level','alt')
colnames(data) = c(paste(fields, '1', sep='.'), paste(fields, '2', sep='.'))

data = subset(data, level.1==1 & level.2==1 & biotype.1!= 'other' & biotype.2!= 'other')

data$type.1 = paste(data$type.1, data$intern.1, sep="")
data$type.2 = paste(data$type.2, data$intern.2, sep="")

class1 = opt$species1
class2 = opt$species2

count(data,c('biotype.1', 'type.1', 'alt.1', 'alt.2')) -> B
count(data,c('biotype.1', 'type.1', 'alt.1')) -> B1
count(data,c('biotype.1', 'type.1', 'alt.2')) -> B2

func1  <- function(data, class, species) {
    aggregate(freq ~ type.1 + biotype.1, data=data, FUN=function(x){p=x[1]/sum(x);round(c(100*p,1.96*100*sqrt(p*(1-p)/sum(x))),digits=1)}) -> res
    res = as.data.frame(as.matrix(res))
    colnames(res) = c('Boundary','Biotype','Prop','SE')
    res$Probability   = class 
    res$Species = species
    res
}

rbind(func1(B1, 'Absolute', class1),func1(B2, 'Absolute', class2),func1(B[B$alt.2==0,], 'Conditional', class1),func1(B[B$alt.1==0,], 'Conditional', class2)) -> S

write.table(S, file=opt$out, row.names=F, col.names=T, quote=F, sep="\t")

