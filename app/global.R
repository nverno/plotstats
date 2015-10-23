### global.R --- 
## Filename: global.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 00:32:08 2015 (-0400)
## Last-Updated: Fri Oct 23 00:18:11 2015 (-0400)
##           By: Noah Peart
######################################################################

dataloc <- c("../data", "data",
             "../../treedata/", "../treedata/")           # locations to look for data
datafiles <- c("pp.csv", "transect.csv")                  # data files
temploc <- "../data"                                      # where to store temporary data

.debug <- TRUE

source("R/widgets.R", chdir = TRUE)
source("R/utils.R", chdir = TRUE)

## partial UIs that should source in plotting_ui
usePlot <- c("barplot", "scatter")

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
require(DT)
require(shinythemes)
## require(shinyjs)   # toggle/show/hid
## require(devtools)  # install_github

################################################################################
##
##                              Plotting stuff
##
################################################################################
mypal <- colorRampPalette(brewer.pal(6, "RdBu"))
defaults <- list(theme_bw(), scale_fill_brewer(palette='Spectral', drop=FALSE))

