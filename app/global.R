### global.R --- 
## Filename: global.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 00:32:08 2015 (-0400)
## Last-Updated: Sat Oct 31 23:57:18 2015 (-0400)
##           By: Noah Peart
######################################################################
tree_data <- c('pp'="pp.csv", 'tp'="transect.csv")
location_data <- c('pp'="PP_DEMSLOPE.csv",
                   'moose'='GPS_ALL.xlsx')                # moose has tp/pp/contours/more
dataloc <- c("../data", "data",
             "../../treedata/", "../treedata/")           # locations to look for data
datafiles <- c(tree_data, location_data)                  # data files
temploc <- "../data"                                      # where to store temporary data

.debug <- TRUE

## partial UIs that should source in plotting_ui
usePlot <- c("barplot", "scatter")

################################################################################
##
##                           Packages/sources
##
################################################################################
## Shiny/web
require(shiny)
require(shinythemes)  # flatly
require(markdown)     # includeMarkdown
require(shinyAce)     #!

## Data
require(xlsx)         # read.xlsx2 for GPS locs
require(data.table)
require(plyr)
require(dplyr)

## Charts
require(ggplot2)
library(ggvis)
require(DT)

## Mapping
require(ggmap)
require(googleVis)
require(leaflet)

require(grid)         # arrows
require(RColorBrewer) # brewer.pal
## require(shinyjs)   # toggle/show/hid
require(devtools)     # install_github

source("R/widgets.R", chdir = TRUE)
source("R/utils.R", chdir = TRUE)
################################################################################
##
##                              Plotting stuff
##
################################################################################
mypal <- colorRampPalette(brewer.pal(6, "RdBu"))
defaults <- list(theme_bw(), scale_fill_brewer(palette='Spectral', drop=FALSE))

