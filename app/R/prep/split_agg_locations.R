### split_agg_locations.R --- 
## Filename: split_agg_locations.R
## Description: Split permanent/transect locations and merge more location data
## Author: Noah Peart
## Created: Sat Oct 31 22:37:24 2015 (-0400)
## Last-Updated: Sat Oct 31 23:35:30 2015 (-0400)
##           By: Noah Peart
######################################################################
if (!file.exists(file.path(temploc, "locations.rds")))
    source("moose_locations.R")
locs <- readRDS(file.path(temploc, "locations.rds"))

################################################################################
##
##                              Permanent Plots
##
################################################################################
## Add elevcl/aspcl/soilcl
if (!exists("pp")) stop( "Load permanent plot data first." )
agg <- setDT(pp)[,lapply(.SD, unique),by=PPLOT,
                 .SDcols=c("ELEVCL", "ASPCL", "SOILCL","ELEV","ASP")]
agg[, PPLOT:=as.character(PPLOT)]
locs[, PPLOT:=as.character(PPLOT)]
res <- left_join(locs, agg, by="PPLOT")
res[, PPLOT := factor(PPLOT, levels=levOrder(PPLOT))]
keeps <- c('PPLOT', 'lng', 'lat', 'DATE', 'INTERP', 'DEMSLOPE', 'ELEVCL',
           'ASPCL', 'SOILCL', 'ELEV', 'ASP', 'LABEL')
pploc <- res[!is.na(PPLOT), keeps, with=FALSE]
setorder(pploc, PPLOT)
saveRDS(pploc, file.path(temploc, "pp_loc.rds"))

################################################################################
##
##                              Transect Plots
##
################################################################################
## Add ELEVCL/ASPCL/SOILCL
if (!exists("tp")) stop( "Load transect data first." )
agg <- setDT(tp)[,lapply(.SD, unique), by=list(TRAN, TPLOT),
                 .SDcols=c('ELEVCL', 'ASPCL', 'ASP', 'ELEV')]
res <- left_join(locs, agg, by=c("TRAN", "TPLOT"))
keeps <- c("TRAN", "TPLOT", "lng", "lat", "DATE", "INTERP", "ELEVCL",
           "ASPCL", "ELEV", "ASP", "LABEL")
tploc <- res[!is.na(TRAN), keeps, with=FALSE]
saveRDS(tploc, file.path(temploc, "tp_loc.rds"))
