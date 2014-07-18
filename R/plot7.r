suppressPackageStartupMessages(library('ggplot2'))
suppressPackageStartupMessages(library('plyr'))
suppressPackageStartupMessages(library("optparse"))
option_list <- list(make_option(c("-i", "--inp"), help="input table"),
                    make_option(c("-x", "--species1"), help="species 1 name"),
                    make_option(c("-y", "--species2"), help="species 2 name"),
                    make_option(c("-s", "--symbol"),   help="symbol"),
                    make_option(c("-o", "--out"), help="pdf output"))

opt <- parse_args(OptionParser(option_list=option_list))

source("R/definitions.r");
source("R/graphics.r")
source("R/logit.r")

data = read.delim(opt$inp)
name1 = factor_Species(opt$species1)
name2 = factor_Species(opt$species2)

symbol = fsymbol(opt$symbol)

print(count(data,c('alt.1','alt.2')))
print(cor(data$mean.x,data$mean.y,use="pairwise.complete.obs"))
print(cor(logit(data$mean.x),logit(data$mean.y),use="pairwise.complete.obs"))
print(cor(data$var.x,data$var.y,use="pairwise.complete.obs"))
print(cor(log10(data$var.x),log10(data$var.y),use="pairwise.complete.obs"))

data = subset(data, var.x>0 & var.y>0)

print(count(data,c('alt.1','alt.2'))) 
print(cor(data$mean.x,data$mean.y,use="pairwise.complete.obs"))
print(cor(logit(data$mean.x),logit(data$mean.y),use="pairwise.complete.obs"))
print(cor(data$var.x,data$var.y,use="pairwise.complete.obs"))
print(cor(log10(data$var.x),log10(data$var.y),use="pairwise.complete.obs"))

df1 = with(data, data.frame(mean = mean.x, var = var.x, Usage = factor_usage(alt.1), biotype = factor_biotype(biotype.1), species=name1))
df2 = with(data, data.frame(mean = mean.y, var = var.y, Usage = factor_usage(alt.2), biotype = factor_biotype(biotype.2), species=name2))
df = rbind(df1,df2)

p1 <- ggplot(df, aes(x=logit(mean),  fill=Usage)) + facet_grid(species ~ .) + xlab(bquote(paste('logit AVG ',.(symbol)))) + ylab("") #+ look_x_logit() + theme(axis.text.x = element_text(angle=-90,hjust=0))
p2 <- ggplot(df, aes(x=ff*log10(var), fill=Usage)) + facet_grid(species ~ .) + xlab(bquote(paste('SD ',.(symbol))))  + ylab("") + look_x_sd()

p1 <- p1 + my_fill_palette1()
p2 <- p2 + my_fill_palette1()

df1 = with(data, data.frame(mean = mean.x, var = var.x, Usage = paste(alt.1,alt.2), biotype = factor_biotype(biotype.1), species=name1))
df2 = with(data, data.frame(mean = mean.y, var = var.y, Usage = paste(alt.1,alt.2), biotype = factor_biotype(biotype.2), species=name2))
df = rbind(df1,df2)

df$Usage = factor(df$Usage,levels=c('0 0','1 0','0 1','1 1'),labels=c('Alt. in Both',paste('Alt. in', species=name2), paste('Alt. in',species=name1), 'Const. in Both'))

q1 <- ggplot(df, aes(x=logit(mean),  fill=Usage)) + facet_grid( species ~ .) + xlab(bquote(paste('logit AVG ',.(symbol)))) + ylab("") #+ look_x_logit() + theme(axis.text.x = element_text(angle=-90,hjust=0))
q2 <- ggplot(df, aes(x=ff*log10(var), fill=Usage)) + facet_grid( species ~ .) + xlab(bquote(paste('SD ',.(symbol))))  + ylab("") + look_x_sd()

q1 <- q1 + my_fill_palette1()
q2 <- q2 + my_fill_palette1()

data$Usage = as.factor(1-(1-data$alt.1)*(1-data$alt.2))
data$Usage = factor(data$Usage, levels=c(0,1), labels=c('Alternative','Other'))

r1 <- ggplot(data, aes(x=logit(mean.x),y=logit(mean.y))) #+ look_x_logit() + look_y_logit() + theme(axis.text.x = element_text(angle=-90,hjust=0)) + theme(axis.text.y = element_text(hjust=1))
r1 <- r1 + xlab(bquote(paste('logit AVG ',.(symbol), ', ', .(as.character(name1)),sep=''))) + ylab(bquote(paste('logit AVG ',.(symbol), ', ', .(as.character(name2)), sep='')))

r2 <- ggplot(data, aes(x=ff*log10(var.x), y=ff*log10(var.y))) + look_x_sd() + look_y_sd()
r2 <- r2 + xlab(bquote(paste("SD ",.(symbol), ', ', .(as.character(name1))))) + ylab(bquote(paste("SD ",.(symbol), ', ', .(as.character(name2)))))

r1 <- r1 + my_colour_palette1()
r2 <- r2 + my_colour_palette1()

pdf(opt$out, onefile=T, width=normal_w, height = normal_h)

p1 + geom_density(alpha=the_alpha) 
p1 + geom_bar(position="dodge") 
p1 + geom_bar(position="stack") 
p1 + geom_bar(position="fill") 

p2 + geom_density(alpha=the_alpha)
p2 + geom_bar(position="dodge")
p2 + geom_bar(position="stack")
p2 + geom_bar(position="fill")

q1 + geom_density(alpha=the_alpha) 
q1 + geom_bar(position="dodge") 
q1 + geom_bar(position="stack") 
q1 + geom_bar(position="fill") 

q2 + geom_density(alpha=the_alpha)
q2 + geom_bar(position="dodge")
q2 + geom_bar(position="stack")
q2 + geom_bar(position="fill")

r1 + stat_density2d(aes(colour=Usage))
r2 + stat_density2d(aes(colour=Usage))

r1 + stat_bin2d(bins=100) + scale_fill_gradientn("# of SJ pairs",colours=terrain.colors(20))
r2 + stat_bin2d(bins=100) + scale_fill_gradientn("# of SJ pairs",colours=c(rep("#FFFFFF",2), terrain.colors(18)))
dev.off()





