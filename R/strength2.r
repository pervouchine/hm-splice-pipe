suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-a", "--inp1"), help="input table 1"),
		    make_option(c("-b", "--inp2"), help="input table 2"),
                    make_option(c("-x", "--species1"), help="species 1 name"),
                    make_option(c("-y", "--species2"), help="species 2 name"),
                    make_option(c("-m", "--map"),   help="map"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")

set_ggplot_theme()

fields =  c('chr_pos_str','Boundary','Alternative','Biotype','Level','score','consensus')
data1 = read.delim(opt$inp1, col.names=fields)

data1 = subset(data1, Biotype!= 'other')
data1$score[data1$Boundary == "52"] = scale(data1$score[data1$Boundary == "52"])
data1$score[data1$Boundary == "32"] = scale(data1$score[data1$Boundary == "32"])
colnames(data1) = paste(colnames(data1), "1", sep=".")

data2 = read.delim(opt$inp2, col.names=fields)
data2 = subset(data2, Biotype!= 'other')
data2$score[data2$Boundary == "52"] = scale(data2$score[data2$Boundary == "52"])
data2$score[data2$Boundary == "32"] = scale(data2$score[data2$Boundary == "32"])
colnames(data2) = paste(colnames(data2), "2", sep=".")

map = read.delim(opt$map, header=F)[,c(1,8)]
colnames(map) = c('chr_pos_str.1','chr_pos_str.2')

merge(data1,merge(map,data2)) -> data

name1 = factor_Species(opt$species1)
name2 = factor_Species(opt$species2)

df1 = with(data, data.frame(score = score.1, Usage = paste(paste(Alternative.1,Alternative.2)), Boundary = Boundary.1, Species=name1))
df2 = with(data, data.frame(score = score.2, Usage = paste(paste(Alternative.1,Alternative.2)), Boundary = Boundary.1, Species=name2))
df = rbind(df1,df2)

df$Usage    = factor(df$Usage,levels=c('0 0','1 0','0 1','1 1'),labels=c('Alt. in Both',paste('Alt. in', species=name2), paste('Alt. in',species=name1), 'Const. in Both'))
df$Boundary = factor_boundary(df$Boundary)

p <- ggplot(df,aes(x=score,colour=Usage)) + geom_density(alpha=the_alpha) + facet_grid(Species ~ Boundary) + xlab("Strength (z-score)") +ylab("")

pdf(opt$out, width=2*narrow_w, height = normal_h)
p + my_colour_palette1()
dev.off()
