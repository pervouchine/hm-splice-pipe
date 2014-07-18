suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library(tables))
suppressPackageStartupMessages(library(xtable))

option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-a", "--out_a"), help="tex table a"),
                    make_option(c("-b", "--out_b"), help="tex table b"),
                    make_option(c("-c", "--out_c"), help="tex table c"),
                    make_option(c("-d", "--out_d"), help="tex table d"),
                    make_option(c("-p", "--species1"), help="species 1 name"),
                    make_option(c("-q", "--species2"), help="species 2 name"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

data = read.delim(opt$inp, header=F)
fields = c('Position','Segment', 'Gene','Biotype', 'Internal', 'Level', 'Usage')
colnames(data) = c(paste(fields, '1', sep='.'), paste(fields, '2', sep='.'),'Status')

data$Segment.1 = paste(data$Segment.1, '2', sep="")
data$Segment.1 = factor_intsegm(data$Segment.1)

data$Biotype.1 = factor_biotype(data$Biotype.1)
data$Biotype.2 = factor_biotype(data$Biotype.2)

data$Level.1 = factor_level(data$Level.1)
data$Level.2 = factor_level(data$Level.2)

data$Usage.1 = factor_usage(data$Usage.1)
data$Usage.2 = factor_usage(data$Usage.2)

name1 = factor_Species(opt$species1)
name2 = factor_Species(opt$species2)

func1 <- function(tb, file) {
    colnames(tb) = c(as.character(name1),as.character(name2))
    formula = paste(as.character(name1),as.character(name2), sep="~")
    tblr <- tabular(formula,tb)
    capture.output(latex(tblr,file=""), file=file)
}

func1(data[,c('Biotype.1','Biotype.2')], file=opt$out_a)

func2 <- function(tb, file) {
    colnames(tb) = c(as.character(name1),as.character(name2),"Segment")
    formula = paste("(", as.character(name1), " + 1) * (", as.character(name2), " + 1)~", "Segment")
    tblr <- tabular(formula,tb)
    capture.output(latex(tblr,file=""), file=file)
}

func2(data[,c('Level.1',   'Level.2',   'Segment.1')], file=opt$out_b)
func2(data[,c('Usage.1',   'Usage.2',   'Segment.1')], file=opt$out_c)

data$Status = factor_status(data$Status,name1,name2)
tb = data[,c('Biotype.1','Status','Segment.1')]
colnames(tb) = c('Biotype','Status','Segment')
tblr <- tabular((Biotype + 1) * Status ~ Segment, tb)
capture.output(latex(tblr,file=""), file=opt$out_d)

