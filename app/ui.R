### ui.R --- 
## Filename: ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:10:44 2015 (-0400)
## Last-Updated: Fri Oct 23 00:19:11 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidPage(
    theme=shinytheme("flatly"),
    tags$head(tags$link(
        rel="stylesheet", type="text/css", href="styles.css"
    )),
    headerPanel('Moose Plots', h2, 'Moosilauke Data'),

    ## Conditional panels to render partial interfaces
    tabsetPanel(
        id = 'partial',
        tabPanel('Subset', value="subset"),
        tabPanel('Barplot', value="barplot"),
        tabPanel('Scatterplot', value='scatter'),
        tabPanel('GGvis', value="ggvis")
    ),
    
    uiOutput("container"),

    ## Debug info
    if (.debug) source("partials/debug_ui.R", local=TRUE)$value,
    
    fluidRow(
        hr(style='border:thin solid #1D1A1A;'),
        DT::dataTableOutput('dataTable')
    )
)
