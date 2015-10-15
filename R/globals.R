### globals.R --- 
## Filename: globals.R
## Description: 
## Author: Noah Peart
## Created: Thu Aug 13 19:57:04 2015 (-0400)
## Last-Updated: Wed Oct 14 17:16:27 2015 (-0400)
##           By: Noah Peart
######################################################################

dataloc <- c("../../treedata/", "../treedata/")           # locations to look for data
datafiles <- c("pp.csv", "transect.csv")          # data files
temploc <- "../temp"                              # where to store temporary data

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
require(shinyjs)   # toggle/show/hid
require(devtools)  # install_github
require(RColorBrewer)

################################################################################
##
##                              Plotting stuff
##
################################################################################
mypal <- colorRampPalette(brewer.pal(6, "RdBu"))
defaults <- list(theme_bw(), scale_fill_brewer(palette='Spectral', drop=FALSE))
