### subset.R --- 
## Filename: subset.R
## Description: Controllers for partials/subset_ui.R
## Author: Noah Peart
## Created: Thu Oct 22 19:25:37 2015 (-0400)
## Last-Updated: Tue Oct 27 18:58:13 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: ''

dat <- reactive({
    res <- if (!is.null(ppVals$ppDat) && input$data == 'pp') {
        if (.debug) print('Changed dat() to ppDat')
        ppDat()
    } else if (!is.null(tpVals$tpDat) && input$data == 'tp') {
        if (.debug) print('Changed dat() to tpDat')
        tpDat()
    } else blankDF(pp, tp)

    ## Set values related to ggvis inputs on data change
    lb$set_keys(seq_len(nrow(res)))
    
    res
})
