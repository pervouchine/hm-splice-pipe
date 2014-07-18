entropy <- function(x){s=sum(x);x[x==0]<-1; log2(s)-sum(x*log2(x))/s}
pseudocount = 1E-3

cmd_args = commandArgs();

process <- function(data) {
    data[is.na(data)] <- -Inf
    10^data + pseudocount
}


data1 = process(read.delim(cmd_args[4]))
data2 = process(read.delim(cmd_args[5]))
map   = read.delim(cmd_args[6])

merge(merge(map, data1, by.x='ensg', by.y=0), data2, by.x='ensmusg', by.y=0) -> expression
rownames(expression) = expression$ensg
expression = expression[,-(1:6)]
#expression = log10(expression)

expression = expression[sample(nrow(expression),1000),]

library(reshape)

vm <- function(x) {y = melt(as.matrix(x))$value;var(y)*(length(y)-1)}

my_aov <- function(data) {
    TSS = vm(data)
    X = matrix(ncol=ncol(data),nrow=nrow(data),apply(data,1,mean))
    SSX = vm(X)
    Y = matrix(ncol=ncol(data),nrow=nrow(data),apply(data,2,mean),byrow=T)
    SSY = vm(Y)
    XY = data - X - Y + mean(as.matrix(data))
    SSXY = vm(XY)
    res = c(TSS,SSX,SSY,SSXY,TSS-SSX-SSY-SSXY)
    print(dim(data))
    print(res)
    print(round(100*res/res[1],digits=1))
}

H = expression[,intersect(colnames(expression),colnames(data1))]
M = expression[,intersect(colnames(expression),colnames(data2))]

my_aov(H)
my_aov(M)


