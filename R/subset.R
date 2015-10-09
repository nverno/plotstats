### subset.R --- 
## Filename: subset.R
## Description: Interface to subset the data
## Author: Noah Peart
## Created: Mon Aug 24 18:28:13 2015 (-0400)
## Last-Updated: Thu Oct  8 15:41:47 2015 (-0400)
##           By: Noah Peart
######################################################################

################################################################################
##
##                                  Testing
##
################################################################################
if (interactive()) {
    require(shiny)
    input <- list(vgSpec = "ABBA", vgX="DBH", vgY="HT", vgShowDied=TRUE)
    inds <- with(pp, {
        sum(PPLOT %in% 4 & !is.na(pp$DBH) & !is.na(pp$HT))
    })  # 414
    vgInds <- function() inds
}

################################################################################
##
##                                   Main
##
################################################################################
## Selections
source("R/subsetPermanent.R", local=TRUE)

output$chooser <- renderUI({
    div(id = "chooser",
        pplotPage
        )
})
