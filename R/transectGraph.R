### graphTransect.R --- 
## Filename: graphTransect.R
## Description: Widgets to help with interactive transect visuals
## Author: Noah Peart
## Created: Wed Oct 14 18:29:23 2015 (-0400)
## Last-Updated: Wed Oct 14 18:58:44 2015 (-0400)
##           By: Noah Peart
######################################################################
## prefix: tpVis
tpVisVals <- reactiveValues(
    splitOpts = c('Transects'='TRAN', 'Plots'='TPLOT', 'Years'='YEAR')
)

################################################################################
##
##                             Splitting Panels
##
################################################################################
output$tpVisSplit <- renderUI({
    splitChoices <- names(tpVisVals$splitOpts)

    list(
        checkboxGroupInput('tpVisSplit', 'Split Panels:',
                           choices=splitChoices,
                           selected = 'Transects', inline=TRUE),
        conditionalPanel(
            condition = "input.tpVisSplit.length > 0 && input.tpVisSplit.length != 3",
            checkboxGroupInput('tpVisSplitBy', 'By:',
                               choices=splitChoices,
                               selected = c('Plots', 'Years'), inline=TRUE)
        )
    )
})

## Update splitting options
observeEvent(input$tpVisSplit, {
    choices <- names(tpVisVals$splitOpts)[!(names(tpVisVals$splitOpts) %in% input$tpVisSplit)]
    updateCheckboxGroupInput(
        session,
        inputId='tpVisSplitBy',
        choices=choices,
        selected=input[['tpVisSplitBy']],
        inline=TRUE
    )
}, ignoreNULL = FALSE)

## Create formula from splitting input for facet_grid with ggplot
splitForm <- function() {
    if (length(input$tpVisSplit) > 0) {
        lhs <- paste(tpVisVals$splitOpts[input$tpVisSplit], collapse="+")
        rhs <- if (length(input$tpVisSplit < 3) && length(input$tpVisSplitBy) > 0) {
            paste(tpVisVals$splitOpts[input$tpVisSplitBy], collapse="+")
        } else '.'
        return ( facet_grid(sprintf("%s ~ %s", lhs, rhs)) )
    }
    return ( list( ) )
}
