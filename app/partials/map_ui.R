### map_ui.R --- 
## Filename: map_ui.R
## Description: 
## Author: Noah Peart
## Created: Fri Oct 23 06:15:40 2015 (-0400)
## Last-Updated: Fri Oct 23 13:13:35 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'map'

mapOpts <- tagList(
    textInput('mapLocation', "Location Name:", value="Mt Moosilauke")
)

fluidPage(
    sidebarLayout(
        sidebarPanel(
            mapOpts 
        ),
        mainPanel(
            plot(1)
        )
    )
)
