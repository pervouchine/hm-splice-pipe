suppressPackageStartupMessages(library(reporttools))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
		    make_option(c("-n", "--name"), help="species"),
                    make_option(c("-o", "--out"), help="sts output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");

data = read.delim(opt$inp, header=F)
colnames(data) = c('chr','pos','str','gn','sn','type','gene','biotype', 'intern','level','alt')
data$type = paste(data$type, data$intern, sep="")

B = data[,c('type','biotype', 'level','alt')]
B = subset(B, biotype !="other")

colnames(B) = c('Boundary','Biotype','Level','Usage');

B$Boundary = factor_ss(B$Boundary)
B$Biotype  = factor_biotype(B$Biotype)
B$Level    = factor_level(B$Level)
B$Usage	   = factor_usage(B$Usage)

species = factor_Species(opt$name)

capture.output(tableNominal(B[,2:4], longtable = F, cumsum = F, group=B$Boundary, cap=paste(species, " splice sites"), lab=paste(species, "ss", sep="::")), file=opt$out)





