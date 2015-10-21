### debug.R --- 
## Filename: debug.R
## Description: Output debugging information
## Author: Noah Peart
## Created: Wed Oct 21 01:30:37 2015 (-0400)
## Last-Updated: Wed Oct 21 02:50:45 2015 (-0400)
##           By: Noah Peart
######################################################################

## Print out debug info
debugShiny <- function(session) {
    ## inps <- lapply(session$input, reactiveValuesToList)
    ## outs <- lapply(session$output, reactiveValuesToList)
    ## list(inps=inps)
    str(session)
}

output$debugShiny <- renderPrint({
    if (!is.null(input$debug) && input$debug > 0) {
        isolate(eval(parse(text=input$debugInput)))
        ## debugShiny(session)
    }
})
