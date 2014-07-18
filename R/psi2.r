suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("plyr"))

option_list <- list(make_option(c("-a", "--inp1"), help="tsv input 1"),
                    make_option(c("-b", "--inp2"), help="tsv input 2"),
		    make_option(c("-s", "--sss"), help="strength"),
		    make_option(c("-n", "--name"), help="name"),
		    make_option(c("-m", "--symb"),  help="symbol"),
                    make_option(c("-o", "--out"), help="sts output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/logit.r")
source("R/graphics.r")

set_ggplot_theme()

data1 = read.delim(opt$inp1)
data2 = read.delim(opt$inp2)

rbind(data1, data2) -> data

unlist(lapply(strsplit(rownames(data),"_"),function(x){paste(x[1],x[2],x[4],sep="_")})) -> data$don
unlist(lapply(strsplit(rownames(data),"_"),function(x){paste(x[1],x[3],x[4],sep="_")})) -> data$acc

strength = read.delim(opt$sss, col.names=c('chr_pos_str','Boundary','Usage','Biotype','Level','score','cons'))
strength$score[strength$Boundary == "52"] = scale(strength$score[strength$Boundary == "52"])
strength$score[strength$Boundary == "32"] = scale(strength$score[strength$Boundary == "32"])

merge(merge(data, strength, by.x='don', by.y='chr_pos_str'),  strength[,c('chr_pos_str','score')], by.x='acc', by.y='chr_pos_str') -> df1
df = subset(df1, Biotype!='other' & Level==1 & mean>0 & mean<1)

df$Biotype     = factor_biotype(df$Biotype)

name   = factor_species(opt$name)
symbol = fsymbol(opt$symb)

pdf(opt$out, onefile=T, width=normal_w, height = normal_h)

p <- ggplot(df,aes(x=logit(mean), colour=Biotype)) + xlab(bquote(paste('logit AVG ',.(symbol), ', ', .(as.character(name))))) + ylab("")
p <- p + my_colour_palette1()
p + geom_density(alpha=the_alpha, size=1, adjust=2) #+ look_x_logit() + theme(axis.text.x = element_text(angle=-90,hjust=0)) 

print(count(df,c('Biotype')))

p <- ggplot(df,aes(x=ff*log10(var), colour=Biotype))  + xlab(bquote(paste('SD ',.(symbol), ', ', .(as.character(name))))) + ylab("") 
p <- p + my_colour_palette1()
p + geom_density(alpha=the_alpha, size=1, adjust=2) + look_x_sd()

q <- ggplot(df,aes(x=logit(mean), y=score.x+score.y)) + xlab(bquote(paste('logit AVG ',.(symbol), ', ', .(as.character(name))))) + ylab(bquote(S[D]+S[A])) #+ look_x_logit() + theme(axis.text.x = element_text(angle=-90,hjust=0))
cf <- coef(lm(score.x+score.y~logit(mean),data=subset(df,mean>0 & mean<1)))
q + stat_density2d(size=1) + geom_abline(intercept=cf[1], slope=cf[2], linetype="dashed",colour='red')

q <- ggplot(df,aes(x=ff*log10(var),    y=score.x+score.y)) + xlab(bquote(paste('SD ',.(symbol), ', ', .(as.character(name))))) + ylab(bquote(S[D]+S[A]))
cf <- coef(lm(score.x+score.y~log10(var),data=subset(df,var>0)))
q + stat_density2d(size=1) + geom_abline(intercept=cf[1], slope=cf[2]/ff, linetype="dashed",colour='red') + look_x_sd()

dev.off()



