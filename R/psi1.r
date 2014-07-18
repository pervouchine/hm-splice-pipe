suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-a", "--inp1"), help="tsv input 1"),
                    make_option(c("-b", "--inp2"), help="tsv input 2"),
                    make_option(c("-o", "--out"), help="sts output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")

set_ggplot_theme()

cmd_args = commandArgs();

data1 = read.delim(opt$inp1)
data2 = read.delim(opt$inp2)

pdf(opt$out, onefile=T, width=normal_w, height = normal_h)
merge(data1,data2, by=0) -> data
p <- ggplot(data, aes(x=logit(mean.x), y=logit(mean.y))) + xlab(bquote(logitMean(psi[5]))) + ylab(bquote(logitMean(psi[5])))
p + stat_density2d()

p <- ggplot(data, aes(x=log10(var.x), y=log10(var.y))) + xlab(bquote(logVar(psi[5]))) + ylab(bquote(logVar(psi[3]))) 
p + stat_density2d() 
dev.off()



