### subsetPermanent.R --- 
## Filename: subsetPermanent.R
## Description: subset permanent plots by plot, elev range, elev class, aspect
## Author: Noah Peart
## Created: Thu Oct  8 15:25:43 2015 (-0400)
## Last-Updated: Thu Oct  8 16:32:52 2015 (-0400)
##           By: Noah Peart
######################################################################
buttonSeparator <- hr(style="margin-top: 0.2em; margin-bottom: 0.2em;")
pp <- pp

################################################################################
##
##                            Subset Options
##
################################################################################
## Plot selection: by elevation range, elevation class, or checkbox
ppERange <- range(pp$ELEV, na.rm=TRUE)
selElevRange <- sliderInput('ppElevRange', 'Elevation Range:', min=ppERange[[1]], max=ppERange[[2]],
                            value=ppERange)
selElevClass <- checkboxGroupInput("ppElevClass", "Elevation Class:",
                                   choices=levels(pp$ELEVCL),
                                   selected=levels(pp$ELEVCL))
selPPlotCheck <- checkboxGroupInput("pplot", "Plot:",
                                    choices=levels(pp$PPLOT),
                                    selected=levels(pp$PPLOT), inline=TRUE)

## Select by aspect: range or class
ppARange <- range(pp$ASP, na.rm=TRUE)
ppSelAspClass <- checkboxGroupInput('ppAspClass', 'Aspect Class:',
                                    choices = levels(pp$ASPCL),
                                    selected = levels(pp$ASPCL))
ppSelAspRange <- sliderInput('ppAspRange', 'Aspect Range:',
                             min = ppARange[1], max = ppARange[2], value=ppARange)

pplotPage <- fluidPage(
    fluidRow(class="chooserRow1",
             ## Helper buttons
             column(width=2, class="chooserRow1 colEven",
                    helpText("Plot Selectors:", style="font-weight:bold; color: grey;"), 
                    actionButton("allPlots", "All", style="width:100px;"),
                    buttonSeparator,
                    actionButton("noPlots", "None", style="width:100px"),
                    buttonSeparator,
                    actionButton("ppReset", "Reset", style="width:100px")),

             ## Select plots by elevation
             column(width=2, class="chooserRow1 colOdd",
                    radioButtons('ppElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
                    conditionalPanel(
                        condition = "input.ppElevType == 'range'",
                        selElevRange),
                    conditionalPanel(
                        condition = "input.ppElevType == 'class'",
                        selElevClass
                    )),

             ## Select plots by aspect
             column(width=2, class='chooserRow1 colEven',
                    radioButtons('ppAspType', 'Aspect:', choices = c('range', 'class'), inline=TRUE),
                    conditionalPanel(
                        condition = "input.ppAspType == 'range'",
                        ppSelAspRange),
                    conditionalPanel(
                        condition = "input.ppAspType == 'class'",
                        ppSelAspClass
                    )),
             
             ## Select plots by checkbox
             column(width=2, class="chooserRow1 colOdd", selPPlotCheck)
             ),
    hr(),
    fluidRow(actionButton("pSubset", "Make Subset") ),
    tags$head(tags$style("
.chooserRow1{height:400px;}
.colEven{background-color: rgba(0,20,0,0.1);}
.colOdd{background-color: rgba(0,0,0,0);}"
                         ))
)

################################################################################
##
##                             Chooser Observers
##
################################################################################
observeEvent(input$ppReset, {
             updateCheckboxGroupInput(session, inputId='pplot',
                                      choices = levels(pp$PPLOT),
                                      selected = levels(pp$PPLOT), inline=TRUE)
             updateCheckboxGroupInput(session, inputId='ppAspClass',
                                      selected = levels(pp$ASPCL), inline=TRUE)
             updateCheckboxGroupInput(session, inputId='ppElevClass',
                                      selected = levels(pp$ELEVCL), inline=TRUE)
             updateSliderInput(session, inputId='ppAspRange', value = ppARange)
             updateSliderInput(session, inputId='ppElevRange', value = ppERange)
         })

observeEvent(input$allPlots, {
    ps <- input$pplot
    print(ps)
    updateCheckboxGroupInput(session, inputId = 'pplot',
                             choices = ps,
                             selected = paste(ps), inline=TRUE)
})

observeEvent(input$noPlots,
             updateCheckboxGroupInput(session, inputId='pplot',
                                      choices = input$pplot,
                                      selected = NULL, inline=TRUE)
             )

## Elevation/Aspect
observe({
    if (!is.null(input$ppAspType)) {
        elev <- if (input$ppElevType == 'range') {
            pp$ELEV >= input$ppElevRange[1] & pp$ELEV <= input$ppElevRange[2]
        } else pp$ELEVCL %in% input$ppElevClass
        asp <- if (input$ppAspType == 'range') {
            pp$ASP >= input$ppAspRange[1] & pp$ASP <= input$ppAspRange[2]
        } else pp$ASPCL %in% input$ppAspClass
        
        ps <- droplevels(sort(unique(pp$PPLOT[elev & asp])))
        isolate(
            updateCheckboxGroupInput(session, inputId='pplot', choices=levels(ps),
                                     selected=paste(ps), inline=TRUE)
        )
    }
})


