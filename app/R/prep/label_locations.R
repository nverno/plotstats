### label_locations.R --- 
## Filename: label_locations.R
## Description: 
## Author: Noah Peart
## Created: Mon Nov  2 14:54:10 2015 (-0500)
## Last-Updated: Mon Nov  2 14:54:25 2015 (-0500)
##           By: Noah Peart
######################################################################

################################################################################
##
##                               Labels/Popups
##
################################################################################
## Create popup labels (wrap in HTML when used)
## Generic popup, variables must be in mooseloc data
## Not actually using this anymore
popFn <- function(dt) {
    pps <- sprintf("Plot: %s<br/>Slope: %.2f", dt$VALUE, dt$DEMSLOPE)
    tps <- sprintf("Transect: %s<br/>Plot: %g", dt$VALUE, dt$TPLOT)
    conts <- sprintf("Contour: %s<br/>Pace: %g", dt$VALUE, dt$STPACE)
    other <- sprintf("Other: %s", dt$VALUE)
    switch(unique(as.character(dt$TYPE)),
           'PPLOT'=pps,
           'TRAN'=tps,
           'CONTNAM'=conts,
           'OTHER'=other)
}
## mooseloc[, popup := popFn(.SD), by=TYPE,
##          .SDcols=c("TYPE","DEMSLOPE","TPLOT","STPACE","LABEL","VALUE")]

## Permanent plot
ppPopFn <- function(dat) {
    sprintf("Plot: %s<br/>Elev: %g<br/>Soil: %s", as.character(dat$PPLOT),
            dat$ELEV, as.character(dat$SOILCL))
}

## Transect
tpPopFn <- function(dat) {
    sprintf("Tran: %s<br/>Plot: %g<br/>Elev: %g", as.character(dat$TRAN),
            dat$TPLOT, dat$ELEV)
}

## Contours
contPopFn <- function(dat) {
    sprintf("Contour: %s<br/>Pace: %g", dat$VALUE, dat$STPACE)
}

## Other locations
otherPopFn <- function(dat) {
    sprintf("Other: %s", dat$VALUE)
}

## Non-reactive location data:
## `id` column is going to used to assign layerIds I guess, I was
## having weird problems with rownames and data.tables (or something)
## otherloc will be non permanent/transect data for now
otherloc <- mooseloc[!(TYPE %in% c('TRAN', 'PPLOT', 'CONTNAM')),]
otherloc[, otherLab := otherPopFn(.SD), .SDcols = c('VALUE')]
otherloc[,id := seq.int(.N)]

contloc <- mooseloc[TYPE == 'CONTNAM',]
contloc[, contLab := contPopFn(.SD), .SDcols = c('VALUE', 'STPACE')]
contloc[, id := seq.int(seq.int(.N))]

pploc[, ppLab := ppPopFn(.SD), .SDcols = c('PPLOT', 'ELEV', 'SOILCL')]
pploc[, id := seq.int(.N)]

tploc[, tpLab := tpPopFn(.SD), .SDcols=c('TRAN', 'TPLOT', 'ELEV')]
tploc[, id := seq.int(.N)]
