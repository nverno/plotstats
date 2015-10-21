### global.R --- 
## Filename: global.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 00:32:08 2015 (-0400)
## Last-Updated: Wed Oct 21 15:10:37 2015 (-0400)
##           By: Noah Peart
######################################################################

dataloc <- c("../../treedata/", "../treedata/")           # locations to look for data
datafiles <- c("pp.csv", "transect.csv")          # data files
temploc <- "../temp"                              # where to store temporary data

.debug <- TRUE

## Return a list of controllers from subdirectories
findControllers <- function(name=c("controllers")) {
    dirs <- list.dirs(recursive=TRUE)
    inds <- basename(dirs) %in% name
    files <- list.files(dirs[inds], full.names=TRUE, no..=TRUE)
    sub("^\\.+[/\\]+", "", files)
}

################################################################################
##
##                                 Packages
##
################################################################################
require(shiny)
require(plyr)
require(dplyr)
require(ggplot2)
require(grid)      # arrows
require(RColorBrewer)
library(ggvis)
## require(shinyjs)   # toggle/show/hid
## require(devtools)  # install_github

################################################################################
##
##                              Plotting stuff
##
################################################################################
mypal <- colorRampPalette(brewer.pal(6, "RdBu"))
defaults <- list(theme_bw(), scale_fill_brewer(palette='Spectral', drop=FALSE))
