### ui.R --- 
## Filename: ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:10:44 2015 (-0400)
## Last-Updated: Wed Oct 21 03:14:45 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidPage(
    h2('Rendering Inerfaces at runtime'),

    ## Conditional panels to render partial interfaces
    tabsetPanel(
        id = 'level1', type='pills',
        tabPanel("ggvis", value="ggvis")
    ),

    conditionalPanel(
        condition = "input.level1 == 'ggvis'",
        tabsetPanel(
            id = 'level2', type='pills',
            tabPanel("Linked-Brush", value="brush-linked"),
            tabPanel("Bar", value="bar")
        ),
        
        conditionalPanel(
            condition = "input.level2 == 'brush-linked'",
            tabsetPanel(
                id = 'partial_1', type='pills',
                tabPanel("Brushes", value="brushes")
            )
        ),
        conditionalPanel(
            condition = "input.level2 == 'bar'",
            tabsetPanel(
                id = 'partial_2', type='pills',
                tabPanel("Bars", value="bar")
            )
        )
    ),
    
    uiOutput("container"),

    ## Debug info
    if (.debug) source("partials/debugUI.R", local=TRUE)$value
)
