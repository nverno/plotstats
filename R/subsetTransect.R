### subsetTransect.R --- 
## Filename: subsetTransect.R
## Description: subset by transect, plot#, elev range, elev class, aspect
## Author: Noah Peart
## Created: Wed Oct  7 16:40:06 2015 (-0400)
## Last-Updated: Thu Oct  8 15:49:02 2015 (-0400)
##           By: Noah Peart
######################################################################
buttonSeparator <- hr(style="margin-top: 0.2em; margin-bottom: 0.2em;")
tp <- tp

################################################################################
##
##                            Transect Selections
##
################################################################################
## Plot selection: by elevation range, elevation class, or checkbox
tpERange <- range(tp$ELEV, na.rm=TRUE)
tpSelElevRange <- sliderInput('tElevRange', 'Elevation Range:', min=tpERange[[1]], max=tpERange[[2]],
                            value=tpERange)
tpSelElevClass <- checkboxGroupInput("tElevClass", "Elevation Class:",
                                   choices=levels(tp$ELEVCL), selected=levels(tp$ELEVCL))
tpSelTPlotCheck <- checkboxGroupInput("tPlot", "Plot:", choices=sort(unique(tp$TPLOT)),
                                    selected=unique(tp$TPLOT), inline=TRUE)

output$transectChooser <- renderUI({
    div(id = "transectChooser",
        fluidPage(
            fluidRow(class="tChooserRow1",
                     ## Helper buttons
                     column(width=2, class="tChooserRow1 colEven",
                            helpText("Transect Selectors:", style="font-weight:bold; color: grey;"), 
                            actionButton("allTransects", "All", style="width:100px;"),
                            buttonSeparator,
                            actionButton("noTransects", "None", style="width:100px"),
                            buttonSeparator,
                            helpText('Aspect:'),
                            actionButton("eastTransects", "East", style="width:100px"),
                            buttonSeparator,
                            actionButton("westTransects", "West", style="width:100px")),

                     ## Select transects
                     column(width=2, class="tChooserRow1 colOdd",
                            checkboxGroupInput("transect", "Transects:", choices=levels(tp$TRAN),
                                               selected=levels(tp$TRAN))),

                     ## Select plots by elevation
                     column(width=2, class="tChooserRow1 colOdd",
                            radioButtons('tElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
                            conditionalPanel(
                                condition = "input.tElevType == 'range'",
                                tpSelElevRange),
                            conditionalPanel(
                                condition = "input.tElevType == 'class'",
                                tpSelElevClass
                            )),

                     ## Select plots by checkbox
                     column(width=2, class="tChooserRow1 colEven", tpSelTPlotCheck)
                     ),
            hr(),
            fluidRow(actionButton("tSubset", "Make Subset") ),
            tags$head(tags$style("
.tChooserRow1{height:400px;}
.colEven{background-color: rgba(0,20,0,0.1);}
.colOdd{background-color: rgba(0,0,0,0);}"
                                 ))
        )
        )
})

################################################################################
##
##                             Chooser Observers
##
################################################################################
## Buttons
observeEvent(input$allTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tp$TRAN),
                                          selected = levels(tp$TRAN))
             )

observeEvent(input$noTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tp$TRAN),
                                      selected = NULL)
             )

observeEvent(input$eastTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tp$TRAN),
                                      selected = c(input$transect, grep("^E", levels(tp$TRAN), value=TRUE)))
             )

observeEvent(input$westTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tp$TRAN),
                                      selected = c(input$transect, grep("^W", levels(tp$TRAN), value=TRUE)))
             )

## Plots (respond to changes in transect/elevation)
observe({
    if (!is.null(input$tElevType)) {
        elev <- if (input$tElevType == 'range') {
            tp$ELEV >= input$tElevRange[1] & tp$ELEV <= input$tElevRange[2]
        } else tp$ELEVCL %in% input$tElevClass

        ps <- sort(unique(tp$TPLOT[tp$TRAN %in% input$transect & elev]))
        isolate(
            updateCheckboxGroupInput(session, inputId='tPlot', choices=ps, selected=paste(ps), inline=TRUE)
        )
    }
})

################################################################################
##
##                               Create Subset
##
################################################################################
dat <- reactive({
    if (!is.null(input$tSubset) && input$tSubset > 0) {
        isolate(droplevels(with(tp, tp[TRAN %in% input$transect &
                                         TPLOT %in% input$tPlot, ])))
    } else tp
})

output$tSubText <- reactive({
    if (!is.null(input$tSubset) && input$tSubset > 0) {
        isolate({
            einfo <- if (input$tElevType == 'range') {
                sprintf("Elevation range: [%d, %d]", input$tElevRange[1], input$tElevRange[2])
            } else 
                sprintf("Elevation classes: %s", paste(input$tElevClass, collapse=', '))

            HTML(sprintf("Transects: %s\nPlots: %s\n%s",
                         paste(input$transect, collapse=", "),
                         paste(input$tPlot, collapse=", "),
                         einfo)
                 )
        })
    } else "Not Subsetted"
})
