### dynamicPlotLayout.R --- 
## Filename: dynamicPlotLayout.R
## Description: Dynamic plot interface, to switch between sidebar/wellpanel
## Author: Noah Peart
## Created: Sun Oct 18 16:02:08 2015 (-0400)
## Last-Updated: Sun Oct 18 19:11:40 2015 (-0400)
##           By: Noah Peart
######################################################################
dynUiVals <- reactiveValues(currentUI='barSizeOpts', currentPlot='barSizeClass')

output$dynamicPlotUI <- renderUI({
    fluidPage(
        radioButtons('plotLayout', 'Layout:', choices=c('Sidebar', 'WellPanel'), inline=TRUE),
        uiOutput('general_ui')
    )
})

## General UI reacts to choice of layout
output$general_ui <- renderUI({
    if (input$plotLayout == 'Sidebar') {
        SidebarPanel(
            sidebarLayout(
                uiOutput('currentUI')
            ),
            mainPanel(
                plotOutput('currentPlot')
            )
        )
    } else if (input$plotLayout == 'WellPanel') {
        fluidRow(
            column(12, plotOutput('currentPlot')),
            column(12, wellPanel(uiOutput('currentUI')))
        )
    }
})
