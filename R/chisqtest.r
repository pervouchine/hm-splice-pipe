suppressPackageStartupMessages(library('tables'))
suppressPackageStartupMessages(library('xtable'))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="input table"),
                    make_option(c("-x", "--species1"), help="species 1 name"),
                    make_option(c("-y", "--species2"), help="species 2 name"),
                    make_option(c("-s", "--symbol"),   help="symbol"),
                    make_option(c("-b", "--biotype"),  help="biotype"),
		    make_option(c("-t", "--threshold"),  help="threshold"),
                    make_option(c("-o", "--out"), help="tex output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

data = read.delim(opt$inp)
name1 = factor_Species(opt$species1)
name2 = factor_Species(opt$species2)

considered = strsplit(opt$biotype, ",")[[1]]
data = subset(data, biotype.1 == considered)

symb = opt$symbol
th = as.numeric(opt$threshold)


func <- function(df, th, cap="", file, append=F) {
    df1 = data.frame(x = factor(as.factor(df[,1] < th), levels=c(T,F), labels=paste(c("<","> ="), th, sep="")),
		     y = factor(as.factor(df[,2] < th), levels=c(T,F), labels=paste(c("<","> ="), th, sep="")))
    colnames(df1) = c(as.character(name1), as.character(name2))
    tabular(paste(as.character(name1), as.character(name2), sep="~"),df1) -> tab -> t
    chisq.test(table(df1)) -> chisq
    t[1:4] <- as.list(chisq$expected)
    paste(capture.output(latex(tab,file="")),collapse="") -> observed
    paste(capture.output(latex(t,file="")),collapse="") -> expected
    if(min(chisq$expected)<5) {
	pval = paste("p(fisher) =", fisher.test(table(df1))$p.value)
    } else {
    	pval = paste("p(chi-square) =", round(chisq$p.value,digits=5))
    }
    print(xtable(matrix(ncol=2,nrow=2,c('Observed',observed,'Expected',expected)), caption=paste(cap, symb, pval), align=c('c','c','c')), hline.after=c(0),
	  sanitize.text.function = function(x){x}, include.rownames = FALSE, include.colnames = FALSE, file=file, append=append)
    print(cor(df[,1], df[,2]))
}

func(data[,c('mean.x','mean.y')],th,	cap="Contigency table for mean", 		file = opt$out)
func(data[,c('uq.x','uq.y')],th, 	cap="Contigency table for upper quartile", 	file = opt$out, append=T)
func(data[,c('max.x','max.y')],th, 	cap="Contigency table for max",			file = opt$out, append=T)
