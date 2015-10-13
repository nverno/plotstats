### widgets.R --- 
## Filename: widgets.R
## Description: Modified shiny widgets
## Author: Noah Peart
## Created: Mon Oct 12 13:11:02 2015 (-0400)
## Last-Updated: Mon Oct 12 13:17:17 2015 (-0400)
##           By: Noah Peart
######################################################################
## Spaces between buttons in input panel
buttonSeparator <- hr(style="margin-top: 0.2em; margin-bottom: 0.2em;")

## Make options appear inline with label
inlineLabel <- function(widget, sep)
    gsub("class=\"shiny-options-group\"",
         sprintf("style=\"display:inline;margin-left:%spx\"", sep), widget)


