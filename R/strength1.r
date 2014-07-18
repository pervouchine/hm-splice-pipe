suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-o", "--out"), help="sts output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")

#suppressPackageStartupMessages(library(gridExtra))

set_ggplot_theme()

data=read.delim(opt$inp, col.names=c('chr_pos_str','Boundary','Usage','Biotype','Level','score','consensus'))

data = subset(data, Level==1 & Biotype!= 'other')

data$score[data$Boundary == "52"] = scale(data$score[data$Boundary == "52"])
data$score[data$Boundary == "32"] = scale(data$score[data$Boundary == "32"])

data$Usage = factor_usage(data$Usage)
data$Boundary	 = factor_boundary(data$Boundary)
data$Biotype	 = factor_biotype(data$Biotype)
data$Level	 = factor_level(data$Level)

data$UsageC = fcount(data$Usage)
data$BiotypeC = fcount(data$Biotype)

p1 <- ggplot(data, aes(x=score)) + xlab("Strength (z-score)") +ylab("") + facet_grid(Boundary ~ .)
p1 <- p1 + my_colour_palette1()

p2 <- ggplot(data, aes(x=score)) + xlab("Strength (z-score)") +ylab("") + facet_grid(Boundary ~ .)
p2 <- p2 + my_colour_palette1()

pdf(opt$out, width=narrow_w, height = normal_h)
p1 + geom_density(alpha=the_alpha, aes(colour=Usage), size=1) 
p2 + geom_density(alpha=the_alpha, aes(colour=Biotype), size=1)

p1 + geom_density(alpha=the_alpha, aes(colour=UsageC), size=1)
p2 + geom_density(alpha=the_alpha, aes(colour=BiotypeC), size=1)

dev.off()
