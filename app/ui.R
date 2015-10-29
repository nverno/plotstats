### ui.R --- 
## Filename: ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:10:44 2015 (-0400)
## Last-Updated: Thu Oct 29 06:04:55 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidPage(
    theme=shinytheme("flatly"),
    tags$head(tags$link(
        rel="stylesheet", type="text/css", href="styles.css"
    ), tags$title("Moosilauke Data")),
    includeScript("www/scripts.js"),

    ## Conditional panels to render partial interfaces
    navbarPage(
        title="Moosilauke Data",
        id = 'partial',
        tabPanel('Leaflet', value='leaflet'),
        tabPanel('Map', value='map'),
        navbarMenu(
            title="Data",
            tabPanel('Selection', value="subset"),
            tabPanel('Table', value = 'dataTable'),
            tabPanel('Aggregate', value='aggregate')
        ),
        navbarMenu(
            title = 'Static Charts',
            tabPanel('Barplot', value="barplot"),
            tabPanel('Scatterplot', value='scatter')
        ),
        navbarMenu(
            title = 'Interactive Charts',
            tabPanel('Motion', value='motion'),
            tabPanel('GGvis', value="ggvis")
        ),
        navbarMenu(
            title="Info",
            tabPanel('Data Info', value='info')
        )
    ),
    
    uiOutput("container"),

    ## Debug info
    lapply(1:4, function(i) br()),
    if (.debug) source("partials/debug_ui.R", local=TRUE)$value
)
