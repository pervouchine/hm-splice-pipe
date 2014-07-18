suppressPackageStartupMessages(library('ggplot2'))
suppressPackageStartupMessages(library('plyr'))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="input table"),
                    make_option(c("-j", "--hamming"), help="hamming distance table"),
                    make_option(c("-s", "--symbol"),   help="symbol"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")
source("R/logit.r")

data1 = read.delim(opt$hamming, header=F)
data2 = read.delim(opt$inp)

merge(data1,data2,by=1:2) -> data
data$id = (1-data$V7/20)*100
data = na.omit(subset(data, id>50))
data$id = cut(data$id,breaks=seq(50,100,10))
#data$id = cut_number(data$id, 5)

palette = rev(rainbow(6)[1:5])

symbol = fsymbol(opt$symbol)

pdf(opt$out, onefile=T, width=normal_w, height = normal_h)
set_ggplot_theme()


p = ggplot(data,aes(id, logit(mean.x)-logit(mean.y))) + geom_boxplot(notch=T,outlier.size=0) + scale_fill_manual(values = palette)
p + xlab("range of % identity") + ylab(bquote(paste(Delta, 'logit AVG', .(symbol)))) + ylim(c(-3,3)) + guides(fill = guide_legend(reverse=TRUE))

p = ggplot(data,aes(id, abs(logit(mean.x)-logit(mean.y)))) + geom_boxplot(notch=T,outlier.size=0) + scale_fill_manual(values = palette)
p + xlab("range of % identity") + ylab(bquote(paste('|',Delta, 'logit AVG', .(symbol),'|, human - mouse'))) + ylim(c(0,2.5)) + guides(fill = guide_legend(reverse=TRUE))

dev.off()
