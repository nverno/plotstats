### subset.R --- 
## Filename: subset.R
## Description: Controllers for partials/subset_ui.R
## Author: Noah Peart
## Created: Thu Oct 22 19:25:37 2015 (-0400)
## Last-Updated: Fri Oct 23 01:19:50 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: ''

dat <- reactive({
    res <- if (!is.null(input$tpMake) && input$tpMake > 0 ||
        !is.null(input$ppMake) && input$ppMake > 0) {
        if (.debug) print('Changed dat()')
        if (input$data == 'tp') {
            tpDat()
        } else ppDat()
    } else blankDF(pp, tp)
    lb$set_keys(seq_len(nrow(res)))
    res
})
