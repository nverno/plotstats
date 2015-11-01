### leaflet.R --- 
## Filename: leaflet.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 14:04:33 2015 (-0400)
## Last-Updated: Sat Oct 31 13:42:35 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

################################################################################
##
##                                 Reactives
##
################################################################################
## Create popup labels (wrap in HTML when used)
popFn <- function(dat) {
    sprintf("Plot: %s<br/>Slope: %.2f<br/>Soil: %s", as.character(dat$PPLOT),
            dat$DEMSLOPE, as.character(dat$SOILCL))
}

## Data
leafDat <- reactive({
    res <- if (is.null(input$data) || input$data == 'pp') pploc else pploc # dont have transect locations ready
    res[,popup := popFn(res)]
    res
})

## https://rstudio.github.io/leaflet/shiny.html
colorpal <- function(colors, variable) {
    colorFn <- switch(class(variable),
                      "factor"  = colorFactor,
                      "numeric" = colorNumeric,
                      function(...)warning("No color function implemented for that type."))
    colorFn(colors, variable)
}

################################################################################
##
##                           Observers for Markers
##
################################################################################
## Add/remove permanent plot markers
observe({
    inps <- nonEmpty(list(plotMarks = input$leafppPlotMarkers,
                          clust     = input$leafppCluster))
    isolate ({
        if (is.null(inps$plotMarks)) return()
        if (!inps$plotMarks) {
            leafletProxy("leafMap", data=leafDat()) %>%
              hideGroup('pplots') %>%
              hideGroup('pplotsClust')
        } else if (inps$clust) {
            leafletProxy("leafMap", data=leafDat()) %>%
              hideGroup('pplots') %>%
              showGroup('pplotsClust')
        } else if (inps$plotMarks) {
            leafletProxy("leafMap", data=leafDat()) %>%
              hideGroup('pplotsClust') %>%
              showGroup('pplots')
        }
    })
})

################################################################################
##
##                          Observers for Variables
##
################################################################################
## Change circle color in response to leafAggVar
observe({
    inps <- nonEmpty(list(agg   = input$leafAggVar,
                          color = input$leafColor))
    if (!length(inps)) return()

    isolate({
        if (.debug) print('Aggregation Variable')
        proxy <- leafletProxy('leafMap', data=leafDat())
        proxy %>% clearGroup('ppCircles') %>% removeControl('ppLegend')

        if (inps$agg != 'None') {
            agg <- leafDat()[[inps$agg]]
            pal <- colorpal(inps$color, agg)
            proxy %>%
              addCircles(lng=~lng, lat=~lat, radius=80,
                         color = '#777777', fillColor = ~pal(agg),
                         fillOpacity = 0.7, popup = ~paste(agg),
                         group='ppCircles')
        }
    })
})

observeEvent(input$leafLegend, {
    proxy <- leafletProxy('leafMap', data=leafDat())
    proxy %>% clearControls()
    if (input$leafLegend && input$leafAggVar != 'None') {
        agg <- leafDat()[[input$leafAggVar]]
        pal <- colorpal(input$leafColor, agg)
        proxy %>%
          addLegend(position="bottomright", pal=pal, values= ~agg,
                    title=input$leafAggVar, layerId = 'ppLegend')
    }
})

################################################################################
##
##                             Starter Map
##
################################################################################
## Initially render parts of map that change the least
output$leafMap <- renderLeaflet({
    ## Leaflet will guess the correct columns, but might as well be explicit
    if (.debug) print("Rendered leafMap")
    
    leaflet(data=leafDat()) %>%
      addProviderTiles(isolate(leafVals$leafLayerDefault), group='default') %>%
      fitBounds(lng1=~min(lng),lat1= ~min(lat), lng2= ~max(lng), lat2= ~max(lat)) %>%

      ## Permanent plot markers (both clustered and not)
      addMarkers(lng=~lng, lat=~lat, clusterOptions = markerClusterOptions(),
                 popup = ~popup, group="pplotsClust") %>%
      addMarkers(lng=~lng, lat=~lat, popup=~popup, group="pplots") %>%
      hideGroup("pplots")
    
})
