### setup.R --- 
## Filename: setup.R
## Description: setup for vector growth interactive app
## Author: Noah Peart
## Created: Thu Aug 13 20:10:33 2015 (-0400)
## Last-Updated: Sat Oct 31 23:38:32 2015 (-0400)
##           By: Noah Peart
######################################################################
source("utils.R")

if (!file.exists(temploc))
    dir.create(temploc)

## Read transect/permanent plot data
if (!file.exists(file.path(temploc, "pp.rds")) |
    !file.exists(file.path(temploc, "tp.rds"))) {
    source("remake.R")
} 
pp <- readRDS(file.path(temploc, "pp.rds"))
tp <- readRDS(file.path(temploc, "tp.rds"))

## Location data:
## tp_loc.rds and pp_loc.rds have merged summary data
## locations.rds contains all the GPS
if (!file.exists(file.path(temploc, "pp_loc.rds")))
    source("prep/split_agg_locations.R")
pploc <- readRDS(file.path(temploc, "pp_loc.rds"))
tploc <- readRDS(file.path(temploc, "tp_loc.rds"))
mooseloc <- readRDS(file.path(temploc, "locations.rds"))

## Markers for get_googlemap()
## Convention seems to be long/lat for all the packages
ppmarks <- pploc[,c("lng", "lat"), with=FALSE]

