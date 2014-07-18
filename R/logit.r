suppressPackageStartupMessages(library(scales))

logit <- function(x){log10(x/(1-x))}
tigol <- function(x){1/(1+10^(-x))}

logit_trans = function() trans_new("logit", logit, tigol)
logit_breaks = c(0.01,0.1, 0.5, 0.9, 0.99)

decimal_places=5
epsilon = 10^(-decimal_places)

logit_e <- function(x){y=epsilon+(1-2*epsilon)*x; log10(y/(1-y))}
tigol_e <- function(x){y=1/(1+10^(-x));(y-epsilon)/(1-2*epsilon)}

logit_e_trans = function() trans_new("logit", logit_e, tigol_e)
logit_e_breaks = c(10^(-rev(seq(1,decimal_places,1))),0.5,1-10^(-seq(1,decimal_places,1)))

#scale_x_logit <- function(...){scale_x_continuous(...,trans = "logit",breaks = logit_e_breaks)}
#scale_y_logit <- function(...){scale_y_continuous(...,trans = "logit",breaks = logit_e_breaks)}

look_x_logit <- function(...){scale_x_continuous(..., breaks = logit(logit_e_breaks),labels=logit_e_breaks)}
look_y_logit <- function(...){scale_y_continuous(..., breaks = logit(logit_e_breaks),labels=logit_e_breaks)}


sd_breaks=seq(-4, -1,1)
look_x_sd <- function() {scale_x_continuous(limits=c(-4, log10(0.5)),breaks=sd_breaks, labels=10^sd_breaks)}
look_y_sd <- function() {scale_y_continuous(limits=c(-4, log10(0.5)),breaks=sd_breaks, labels=10^sd_breaks)}

ff = 0.5
