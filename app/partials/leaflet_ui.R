### leaflet_ui.R --- 
## Filename: leaflet_ui.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 15:59:57 2015 (-0400)
## Last-Updated: Thu Oct 29 07:42:47 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

leafOpts <- tagList(
    fluidRow(
        id="leafRow",
        selectizeInput('leafTerrain', 'Terrain Layers', choices=isolate(leafVals$leafTerrain),
                       selected="", multiple = TRUE),
        selectizeInput('leafToners', 'Toner Layers',
                       choices=isolate(leafVals$leafToners), multiple=TRUE),
        selectizeInput('leafWeather', 'Weather Layers',
                       choices=isolate(leafVals$leafWeather), multiple=TRUE),    
        selectInput('leafAggVar', 'Summary Variable',
                    choices=names(isolate(leafDat()))[grepl("CL$", names(isolate(leafDat())))]),
        selectInput('leafColors', 'Color Scheme',
                    choices=rownames(brewer.pal.info[brewer.pal.info %in% c("seq", "div")])),
        checkboxInput('leafMarkers', 'Show Plot Markers', FALSE),
        checkboxInput('leafCluster', 'Cluster Makers', TRUE),
        checkboxInput('leafLegend', 'Legend', TRUE)
    )
)

## Main output: map covers entire page
bootstrapPage(
    leafletOutput('leafMap', width="100%", height=800),
    absolutePanel(
        id = 'leaf-control-panel',
        a(href="#", onclick="showLeafPanel();", class="controller", HTML("Show/Hide")),
        leafOpts
    )
)
