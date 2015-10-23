### setup.R --- 
## Filename: setup.R
## Description: setup for vector growth interactive app
## Author: Noah Peart
## Created: Thu Aug 13 20:10:33 2015 (-0400)
## Last-Updated: Wed Oct 21 18:56:02 2015 (-0400)
##           By: Noah Peart
######################################################################
source("utils.R", chdir = T)

if (!file.exists(temploc))
    dir.create(temploc)

## Read transect/permanent plot data
if (!file.exists(file.path(temploc, "pp.rds")) |
    !file.exists(file.path(temploc, "tp.rds"))) {
    source("remake.R")
} else {
    pp <- readRDS(file.path(temploc, "pp.rds"))
    tp <- readRDS(file.path(temploc, "tp.rds"))
}
