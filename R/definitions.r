draw_legend<-function(a.gplot) { 
   tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
   leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
   legend <- tmp$grobs[[leg]] 
   plot.new()
   grid.draw(legend) 
} 

gamma = 0.00001
logit  <- function(x){log10(x/(1-x))}
logit_gamma <- function(x){x=gamma+(1-2*gamma)*x;log10(x/(1-x))}

STATUS_121 = 0;
STATUS_12X = 1;
STATUS_X21 = -1;

factor_boundary <- function(x) {factor(x,levels=c(51,32,52,33), labels=c('Start','Donor','Acceptor','Stop'))}
factor_ss 	<- function(x) {factor(x,levels=c(52,32), labels=c('Acceptor','Donor'))}
factor_segment  <- function(x) {factor(x,levels=c(11,12,13,22), labels=c('First exon','Exon','Last Exon','Intron'))}
factor_intsegm  <- function(x) {factor(x,levels=c(12,22), labels=c('Exon','Intron'))}
factor_Species  <- function(x) {factor(x,levels=c('hg19','mm9','canFam2','rheMac2','panTro3'), labels=c('Human','Mouse','Dog','Macaque','Chimp'))}
factor_species  <- function(x) {factor(x,levels=c('hg19','mm9'), labels=c('human','mouse'))}
factor_level    <- function(x) {factor(x,levels=c(1,0),labels=c('Annotated','Predicted'))}
factor_usage 	<- function(x) {factor(x,levels=c(0,1), labels=c('Alternative','Constitutive'))}
factor_status   <- function(x,name1,name2) {factor(x,levels=c(-1,0,1),labels=c(paste(name1, "novel"),"In both",paste(name2, "novel")))}

fcount <- function(x) {table(x)->y;factor(x,levels=names(y),labels=y)}

fsymbol <- function(x){y=NA; if(x=="psi") {y=bquote(psi)}; if(x=="theta") {y=bquote(theta)}; y}

btp = unique(read.delim("biotypes.dat",header=F)[,2:3])
factor_biotype <- function(x) {factor(x,levels=c(as.character(btp$V2),'other'), labels=c(as.character(btp$V3),'Other'))}
factor_biotype_abbr  <- function(x) {factor(x,levels=as.character(btp$V2))}

