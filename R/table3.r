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
fields = c('Position','Boundary', 'Gene','Biotype', 'Internal', 'Level', 'Usage')
colnames(data) = c(paste(fields, '1', sep='.'), paste(fields, '2', sep='.'))

data$Boundary.1 = paste(data$Boundary.1, data$Internal.1, sep="")
data$Boundary.2 = paste(data$Boundary.2, data$Internal.2, sep="")
data$Boundary.1 = factor_ss(data$Boundary.1)
data$Boundary.2 = factor_ss(data$Boundary.2)
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
    colnames(tb) = c(as.character(name1), as.character(name2), "Boundary")
    formula = paste("(", as.character(name1), " + 1) * (", as.character(name2), " + 1)~", "Boundary")
    tblr <- tabular(formula,tb)
    capture.output(latex(tblr,file=""), file=file)
}

func2(data[,c('Level.1', 'Level.2', 'Boundary.1')], file=opt$out_b)
func2(data[,c('Usage.1', 'Usage.2', 'Boundary.1')], file=opt$out_c)

data1 = unique(data[,c('Gene.1', 'Gene.2', 'Biotype.1', 'Biotype.2')])
func1(data1[,c('Biotype.1','Biotype.2')], file=opt$out_d)

