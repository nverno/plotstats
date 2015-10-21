### global.R --- 
## Filename: global.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 00:32:08 2015 (-0400)
## Last-Updated: Wed Oct 21 03:51:38 2015 (-0400)
##           By: Noah Peart
######################################################################
library(shiny)
library(ggvis)
library(dplyr)

.debug <- TRUE

## Return a list of controllers from subdirectories
findControllers <- function(name=c("controllers")) {
    dirs <- list.dirs(recursive=TRUE)
    inds <- basename(dirs) %in% name
    files <- list.files(dirs[inds], full.names=TRUE, no..=TRUE)
    sub("^\\.+[/\\]+", "", files)
}
