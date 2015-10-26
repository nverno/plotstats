### config.R --- 
## Filename: config.R
## Description: Make sure packages are installed and whatnot
## Author: Noah Peart
## Created: Fri Oct 23 06:00:03 2015 (-0400)
## Last-Updated: Mon Oct 26 17:41:59 2015 (-0400)
##           By: Noah Peart
######################################################################
source("utils.R")

required_packages <- findPacks(dirs="../", recursive = FALSE)
missed <- !(required_packages %in% rownames(installed.packages()))
if (any(missed))
    install.packages(required_packages[missed], dependencies = TRUE)

## Need to ensure data is available from github,
## Rscript is in the path
## and write a batch file to do all of this
