### locations.R --- 
## Filename: locations.R
## Description: Load/format location data 
## Author: Noah Peart
## Created: Wed Oct 28 14:08:29 2015 (-0400)
## Last-Updated: Fri Oct 30 23:36:39 2015 (-0400)
##           By: Noah Peart
######################################################################
## Will use naming convention: lat/lng

################################################################################
##
##                         Permanent plot locations
##
################################################################################
## Initial setup
pploc <- if (!file.exists(file.path(temploc, "pp_loc.rds"))) {
    local({
        ## Read data
        locs <- findData(dataloc, location_data)
        pploc <- data.table::fread(locs$found[basename(locs$found) == location_data['pp']])

        ## Add elevcl/aspcl/soilcl
        if (!exists("pp")) stop( "Load permanent plot data first." )
        agg <- setDT(pp)[,lapply(.SD, unique),by=PPLOT, .SDcols=c("ELEVCL", "ASPCL", "SOILCL")]
        agg[, PPLOT:=as.character(PPLOT)]
        pploc[, PPLOT:=as.character(PPLOT)]
        res <- left_join(pploc, agg, by="PPLOT")
        setorder(res[, PPLOT := as.numeric(PPLOT)], PPLOT)

        ## PPLOT as factor?  different levels than in 'pp'
        res[, PPLOT := factor(PPLOT)]
        setnames(res, c("LONG", "LAT"), c("lng", "lat"))
        saveRDS(res, file.path(temploc, "pp_loc.rds"))
        res
    })
} else readRDS(file.path(temploc, "pp_loc.rds"))

## Markers for get_googlemap()
## Convention seems to be long/lat for all the packages
ppmarks <- pploc[,c("lng", "lat"), with=FALSE]

