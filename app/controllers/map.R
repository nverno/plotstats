### map.R --- 
## Filename: map.R
## Description: Pull moose map of google maps
## Author: Noah Peart
## Created: Fri Oct 23 06:14:34 2015 (-0400)
## Last-Updated: Fri Oct 23 13:12:38 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'map'

output$map <- renderPlot({
    name <- input$map
    plot(gvisMap(data.frame(LatLong='44.0245:71.8309', tip="Mt Moosilauke")))
})
