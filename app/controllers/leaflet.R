### leaflet.R --- 
## Filename: leaflet.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 14:04:33 2015 (-0400)
## Last-Updated: Sat Oct 31 06:13:54 2015 (-0400)
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
        "Topo1"="Esri.WorldTopoMap",
        "Basic"="Basic",
        "Satellite1"="MapQuestOpen.Aerial",
        "Satellite2"="Esri.WorldImagery",
        "Topo2"="OpenTopoMap",
        "Terrain"="Esri.WorldTerrain",
        "Terrain2"="Acetate.terrain",
        "Physical"="Esri.WorldPhysical",
        "Hill-shaded"="Acetate.hillshading",
        "Watercolor"="Stamen.Watercolor"
    ),
    leafWeather=c(
        "None"="None",
        "Precipitation"="OWM.Precipitation",
        "Pressure"="OpenWeatherMap.Pressure",
        "Pressure-Contour"="OpenWeatherMap.PressureContour",
        "Wind"="OpenWeatherMap.Wind",
        "Temperature"="OpenWeatherMap.Temperature",
        "Snow"="OpenWeatherMap.Snow"
    ),
    ## Map layers to add distinction to roads/trails
    leafToners=c(
        "None"="None",
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
##                       Observers for various layers
##
################################################################################
## Add/remove Base Layers: group 'provider'
observeEvent(input$leafTerrain, {
    inps <- nonEmpty(list(terrain=input$leafTerrain))
    if (.debug) print('Leaf Base Layers')
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1

    if (inps$terrain == 'Basic') {
        leafletProxy('leafMap', data=leafDat()) %>%
          addTiles(group='basic')
    } else if (!is.null(inps$terrain)) {
        if (.debug) print(sprintf('Adding %s', inps$terrain))
        leafletProxy("leafMap", data=leafDat()) %>%
          showGroup('provider') %>%
          addProviderTiles(inps$terrain, group='provider',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Toner layers: group 'toner'
observeEvent(input$leafToner, {
    inps <- nonEmpty(list(toner=input$leafToner))
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1
    if (.debug) print('Leaf Toner')
    
    if (inps$toner == 'None') {
        leafletProxy('leafMap', data=leafDat()) %>%
          hideGroup('toner')
    } else {
        leafletProxy("leafMap", data=leafDat()) %>%
          showGroup('toner') %>%
          addProviderTiles(inps$toner, group='toner',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Weather layers: group 'weather'
observeEvent(input$leafWeather, {
    inps <- nonEmpty(list(weather=input$leafWeather))
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1
    if (.debug) print(inps$weather)
    
    if (inps$weather == 'None') {
        leafletProxy('leafMap', data=leafDat()) %>%
          hideGroup('weather')
    } else {
        leafletProxy("leafMap", data=leafDat()) %>%
          showGroup('weather') %>%
          addProviderTiles(inps$weather, group='weather',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Reset layers
observeEvent(input$leafLayerReset, {
    leafletProxy('leafMap', data=leafDat()) %>%
      clearGroup('provider') %>%
      clearGroup('toner') %>%
      clearGroup('weather') %>%
      clearGroup('basic') %>%
      showGroup('default')
    updateSelectizeInput(session, 'leafTerrain', selected='Esri.WorldTopoMap')
    updateSelectizeInput(session, 'leafToner', selected='None')
    updateSelectizeInput(session, 'leafWeather', selected='None')
    updateCheckboxInput(session, 'leafBaseOverlay', value=FALSE)
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
      addProviderTiles('Esri.WorldTopoMap', group='default') %>%
      fitBounds(lng1=~min(lng),lat1= ~min(lat), lng2= ~max(lng), lat2= ~max(lat)) %>%

      ## Permanent plot markers (both clustered and not)
      addMarkers(lng=~lng, lat=~lat, clusterOptions = markerClusterOptions(),
                 popup = ~popup, group="pplotsClust") %>%
      addMarkers(lng=~lng, lat=~lat, popup=~popup, group="pplots") %>%
      hideGroup("pplots")
    
})
