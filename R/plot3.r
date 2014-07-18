suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
#suppressPackageStartupMessages(library(gridExtra))

option_list <- list(make_option(c("-i", "--inp"), help="tsv input"),
                    make_option(c("-o", "--out"), help="pdf output"));

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")

set_ggplot_theme()

data = read.delim(opt$inp)

data$Boundary = factor_boundary(data$Boundary)
data$Species  = factor_Species(data$Species)
data$Biotype  = factor_biotype(data$Biotype)
data$LB = data$Prop - data$SE
data$UB = data$Prop + data$SE
data$LB[data$LB<0] <- 0
data$UB[data$UB>100] <- 100

print(data)


pdf(opt$out, width=narrow_w, height = normal_h)
a <- ggplot(data, aes(x = Boundary, y = Prop, fill=Probability))
a <- a + geom_bar(stat = "identity", position = "dodge") + geom_errorbar(aes(ymin=LB, ymax=UB),width=.5,position=position_dodge(.9),alpha=the_alpha) + facet_grid(Species ~ Biotype)
a <- a + ylab("% Alternative") + xlab("") + my_fill_palette1()
a 
dev.off()

