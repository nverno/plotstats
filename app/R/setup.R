### setup.R --- 
## Filename: setup.R
## Description: setup for vector growth interactive app
## Author: Noah Peart
## Created: Thu Aug 13 20:10:33 2015 (-0400)
## Last-Updated: Sat Nov 21 11:55:22 2015 (-0500)
##           By: Noah Peart
######################################################################
source("utils.R")

if (!file.exists(temploc))
    dir.create(temploc)

## Read transect/permanent plot data
if (!file.exists(file.path(temploc, "pp.rda")) |
    !file.exists(file.path(temploc, "tp.rda"))) {
    source("remake.R")
} 
load(file.path(temploc, "pp.rda"))
load(file.path(temploc, "tp.rda"))

## Location data:
## tp_loc.rda and pp_loc.rda have merged summary data
## locations.rda contains all the GPS
if (!file.exists(file.path(temploc, "pp_loc.rda")))
    source("prep/split_agg_locations.R")
load(file.path(temploc, "pp_loc.rda"))
pploc <- pp_loc
load(file.path(temploc, "tp_loc.rda"))
tploc <- tp_loc
load(file.path(temploc, "other_loc.rda"))
otherloc <- other_loc
load(file.path(temploc, "contour_loc.rda"))
contloc <- contour_loc
load(file.path(temploc, "locations.rda"))

## Markers for get_googlemap()
## Convention seems to be long/lat for all the packages
ppmarks <- pploc[,c("lng", "lat"), with=FALSE]

