### leaflet.R --- 
## Filename: leaflet.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 14:04:33 2015 (-0400)
## Last-Updated: Thu Oct 29 03:18:23 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

################################################################################
##
##                                 Reactives
##
################################################################################
leafVals <- reactiveValues(
    ## Various map layers
    leafTerrain=c(
        "Default"="",
        "Satellite1"="MapQuestOpen_Aerial",
        "Satellite2"="Esri.WorldImagery",
        "Topo1"="Esri.WorldTopoMap",
        "Topo2"="OpenTopoMap",
        "Terrain"="Esri.WorldTerrain",
        "Terrain2"="Acetate.terrain",
        "Physical"="Esri.WorldPhysical",
        "Shaded"="Esri.ShadedRelief",
        "Hill-shaded"="Acetate.hillshading",
        "Watercolor"="Stamen.Watercolor"
    ),
    leafWeather=c(
        "Precipitation"="OpenWeatherMap.Precipitation",
        "Pressure"="OpenWeatherMap.Pressure",
        "Pressure-Contour"="OpenWeatherMap.PressureContour",
        "Wind"="OpenWeatherMap.Wind",
        "Temperature"="OpenWeatherMap.Temperature",
        "Snow"="OpenWeatherMap.Snow"
    ),
    ## Map layers to add distinction to roads/trails
    leafToners=c(
        "Light"="Stamen.TonerLite",
        "Dark"="Stamen.Toner",
        "Toner-lines"="Stamen.TonerLines",
        "Toner-labels"="Stamen.TonerLabels"
    )
)


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
colorpal <- reactive({
    colorFn <- switch(class(input$leafAggVar),
                      "factor"=colorFactor,
                      "numeric"=colorNumeric,
                      function(...)warning("No color function implemented for that type."))
    colorFn(input$leafColors, input$leafAggVar)
})

################################################################################
##
##                                 Observers
##
################################################################################
## Add/remove markers
## observeEvent(input$leafMarkers, {
##     clust <- if (input$leafCluster) markerClusterOptions() else NA

##     leafletProxy("leafMap", data=leafDat()) %>%
##       clearMarkers() %>%
##       addMarkers(lat=~LAT, lng=~LONG, clusterOptions = clust,
##                  popup = ~popup, group="plotmarks")
## })

################################################################################
##
##                                    Map
##
################################################################################
## Initially render parts of map that change the least
output$leafMap <- renderLeaflet({
    ## Leaflet will guess the correct columns, but might as well be explicit
    ## print('rendered')
    leaflet(data=pploc) %>%
      addTiles() %>%
      fitBounds(~min(LONG), ~min(LAT), ~max(LONG), ~max(LAT))
})
