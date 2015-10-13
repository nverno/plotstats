### subsetTransect.R --- 
## Filename: subsetTransect.R
## Description: subset by transect, plot#, elev range, elev class, aspect
## Author: Noah Peart
## Created: Wed Oct  7 16:40:06 2015 (-0400)
## Last-Updated: Tue Oct 13 02:59:43 2015 (-0400)
##           By: Noah Peart
######################################################################
source("widgets.R")
tp <- tp

################################################################################
##
##                         Summaries for subsetting
##
################################################################################
## Use this to speed up the interactive interface so it doesn't need to work
## with the whole dataset.
##
## Info should include: transect, plot number, elevation (class/value),
## aspect (class/value), year
tpAgg <- aggregate(TPLOT ~ TRAN + ELEV + ELEVCL + ASP + ASPCL + YEAR, FUN=unique, data=tp)
tpAgg <- with(tpAgg, tpAgg[order(TRAN, TPLOT, YEAR), ])

## This data summary is what will be updated after subsetting options are selected
tpVals <- reactiveValues(agg = tpAgg, dat = tp)

################################################################################
##
##                            Transect Selections
##
################################################################################
## Plot selection: by elevation range, elevation class, or checkbox
tpERange <- range(tpAgg$ELEV, na.rm=TRUE)
tpSelElevRange <- sliderInput('tElevRange', 'Elevation Range:', min=tpERange[[1]], max=tpERange[[2]],
                            value=tpERange)
tpSelElevClass <- checkboxGroupInput("tElevClass", "Elevation Class:",
                                   choices=levels(tpAgg$ELEVCL), selected=levels(tpAgg$ELEVCL))
tpSelTPlotCheck <- checkboxGroupInput("tPlot", "Plot:", choices=sort(unique(tpAgg$TPLOT)),
                                    selected=unique(tpAgg$TPLOT), inline=TRUE)

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
                            actionButton("tpReset", "Reset", style="width:100px"),
                            buttonSeparator,
                            helpText('Aspect:'),
                            actionButton("eastTransects", "East", style="width:100px"),
                            buttonSeparator,
                            actionButton("westTransects", "West", style="width:100px")),

                     ## Select transects
                     column(width=2, class="tChooserRow1 colOdd",
                            checkboxGroupInput("transect", "Transects:", choices=levels(tpAgg$TRAN),
                                               selected=levels(tpAgg$TRAN))),

                     ## Select plots by elevation
                     column(width=2, class="tChooserRow1 colEven",
                            radioButtons('tElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
                            conditionalPanel(
                                condition = "input.tElevType == 'range'",
                                tpSelElevRange),
                            conditionalPanel(
                                condition = "input.tElevType == 'class'",
                                tpSelElevClass
                            )),

                     ## Select plots by checkbox
                     column(width=2, class="tChooserRow1 colOdd", tpSelTPlotCheck)
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
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tpAgg$TRAN),
                                          selected = levels(tpAgg$TRAN))
             )

observeEvent(input$noTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tpAgg$TRAN),
                                      selected = NULL)
             )

observeEvent(input$tpReset, {
    updateCheckboxGroupInput(session, inputId='transect',
                             choices = levels(tpAgg$TRAN),
                             selected = levels(tpAgg$TRAN))
    updateCheckboxGroupInput(session, inputId='tElevClass',
                             selected = levels(tpAgg$ELEVCL), inline=TRUE)
    updateSliderInput(session, inputId='tElevRange',
                      min=tpERange[1], max=tpERange[2], value = tpERange)
    ## updateCheckboxGroupInput(session, inputId='tPlot',
    ##                          choices = sort(unique(tpAgg$TPLOT)),
    ##                          selected=unique(tpAgg$TPLOT), inline=TRUE)
})

observeEvent(input$eastTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tpAgg$TRAN),
                                      selected = c(input$transect, grep("^E", levels(tpAgg$TRAN), value=TRUE)))
             )

observeEvent(input$westTransects,
             updateCheckboxGroupInput(session, inputId='transect', choices=levels(tpAgg$TRAN),
                                      selected = c(input$transect, grep("^W", levels(tpAgg$TRAN), value=TRUE)))
             )

## Plots (respond to changes in transect/elevation)
observe({
    if (!is.null(input$tElevType)) {
        elev <- if (input$tElevType == 'range') {
            tpAgg$ELEV >= input$tElevRange[1] & tpAgg$ELEV <= input$tElevRange[2]
        } else tpAgg$ELEVCL %in% input$tElevClass

        ps <- sort(unique(tpAgg$TPLOT[tpAgg$TRAN %in% input$transect & elev]))
        print(ps)
        isolate({
            if (length(ps) < 1)
                updateCheckboxGroupInput(session, inputId='tPlot',
                                         choices='None', selected='None', inline=TRUE)
            else
                updateCheckboxGroupInput(session, inputId='tPlot',
                                         choices=ps, selected=paste(ps), inline=TRUE)
        })
    }
})

################################################################################
##
##                           Create Main Subset
##
################################################################################
## Update tpVals with user choices
observeEvent(input$tSubset, {
    isolate({
        tpVals$agg <- with(tpVals$agg, tpVals$agg[TRAN %in% input$transect &
                                                    TPLOT %in% input$tPlot, ])
        tpVals$dat <- droplevels(with(tp, tp[TRAN %in% input$transect &
                                               TPLOT %in% input$tPlot, ]),
                                 except = 'SPEC')
    })
})

## This is temporary for backwards compatability
dat <- reactive(tpVals$dat)

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

################################################################################
##
##                    Create Transect subsetting options
##
################################################################################
## Creates an interface to subset the transect data
##
## Options: Transect, Elevation, Aspect, plot per Transect

## Initial Framework with Transect options
## Render this in a sidebar, for example, with `uiOutput('tpSubset')`
## Note: to switch labels to be inline with options, the css for shiny-options-group
## needs to be changed, ie. .shiny-options-group{display: inline;}, but that changes all
## them
output$tpSubset <- renderUI({
    list(
        inlineLabel(
            radioButtons('tpSideShow', label='Subset Data:',
                         choices=c('show', 'hide'), inline=TRUE), 5
        ),
        conditionalPanel(
            condition = "input.tpSideShow == 'show'",
            uiOutput('tpSubsetOptions')
        ),
        conditionalPanel(
            condition = "input.tpSideShow == 'hide'",
            uiOutput('tpSubsetSummary')
        ),
        hr(),
        div(align='center',
            actionButton('tpMake', 'Make Subset', width=100, style='font-size:90%'),
            actionButton('tpSideReset', 'Reset', width=100, style='font-size:90%')),
        hr()
    )
})

## Interface with subsetting options
output$tpSubsetOptions <- renderUI({
    ## Add dependency on reset button
    input$tpSideReset

    samp <- tpVals$dat
    eRange <- range(samp$ELEV, na.rm=TRUE)
    
    list(
        checkboxGroupInput('tpSideTran', 'Transect:', choices=levels(samp$TRAN),
                           selected=NULL, inline=TRUE),

        ## Aspect
        checkboxGroupInput('tpSideAsp', 'Aspect:',
                           choices = levels(samp$ASPCL), inline=TRUE),
        
        ## Elevation
        radioButtons('tpSideElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
        conditionalPanel(
            condition = "input.tpSideElevType == 'range'",
            sliderInput('tpSideElevRange', 'Elevation Range:',
                        min = eRange[1], max=eRange[2], value = eRange)
        ),
        conditionalPanel(
            condition = "input.tpSideElevType == 'class'",
            checkboxGroupInput('tpSideElevClass', 'Elevation Class:',
                               choices = levels(samp$ELEVCL), selected=levels(samp$ELEVCL), inline=TRUE)
        ),
        
        ## TPLOTs
        hr(),
        inlineLabel(
            radioButtons('tpSideShowTPlot', 'Transect Plots:',
                         choices=c('show', 'hide'), inline=TRUE), 5),
        conditionalPanel(
            condition = "input.tpSideShowTPlot == 'show'",
            uiOutput('tplotChecks')
        )
    )
})

## Create checkbox input for the TPLOT separately for each TRAN in dat()
## usage: uiOutput('tplotChecks')
## Note: would be nice to have these side by side vertically
output$tplotChecks <- renderUI({
    lapply(input$tpSideTran, function(x) {
        name <- sprintf('tpTran%sTPlot', paste(x))
        sel <- if (x %in% input$tpSideTran) input[[name]] else NULL
        checkboxGroupInput(sprintf('tpTran%sTPlot', paste(x)),
                           paste0(x,':'),
                           choices = tpVals$tplots[[x]], selected = input[[name]], inline=TRUE)
    })
})

## Display a summary of the chosen options when the subsetting interface is
## hidden
output$tpSubsetSummary <- renderUI({
    ## Add dependency on reset button
    input$tpSideReset

    elev <- if (input$tpSideElevType == 'range') {
        paste(input$tpSideElevRange, collapse="-")
    } else paste(input$tpSideElevClass, collapse=", ")

    ## Only summarize transects that have plots selected
    inds <- sapply(input$tpSideTran, function(x) length(input[[sprintf("tpTran%sTPlot", x)]])>0)
    trans <- input$tpSideTran[inds]
    if (length(trans) < 1) return(helpText('No plots selected.'))
    
    list(
        helpText('This is a summary of the selected options.'),
        HTML(c(
            '<p><span style="font-weight:bold;">Selected</span>:',
            '<ul>',
            paste0(
                '<li>',
                lapply(trans, function(x)
                    sprintf('<span style="font-weight:500;">%s</span> [ %s ]',
                            paste(x),
                            paste(input[[sprintf("tpTran%sTPlot", x)]], collapse=','))),
                '</li>'
            ),
            '</ul>',
            '<span style="font-weight:bold;">Elevation</span>: ', elev,        
            '</p>'
        ))
    )
})

################################################################################
##
##                           Observers for sidebar
##
################################################################################
## Helpers to check groups of transects by aspect
observeEvent(input$tpSideAsp,
             updateCheckboxGroupInput(
                 session,
                 inputId = 'tpSideTran',
                 selected=levels(droplevels(tpVals$agg$TRAN[tpVals$agg$ASPCL %in% input$tpSideAsp])),
                 inline=TRUE
             ), ignoreNULL = FALSE)

## 


## Only show plots available for each transect for elevation ranges/classes
## Creates a reactive value, 'tplots', that is used to make the interface
observe({
    ## The first null check ensures there is no initial error (before interface is rendered)
    if (!is.null(input$tpSideElevType)) {
        with(tpVals$agg, {
            elev <- if (input$tpSideElevType == 'range') {
                ELEV >= input$tpSideElevRange[1] & ELEV <= input$tpSideElevRange[2]
            } else ELEVCL %in% input$tpSideElevClass

            inds <- elev & TRAN %in% input$tpSideTran
            isolate(
                tpVals$tplots <- lapply(split(TPLOT[inds], TRAN[inds]), unique)
            )
        })
    }
})

################################################################################
##
##                          Data from Sidebar Input
##
################################################################################
## Update data in response to 'tpMake' button
tpDat <- reactive({
    input$tpMake
    isolate({
        inds <- with(tpVals$dat, {
            Reduce('|', lapply(input$tpSideTran, function(x)
                TRAN == x & TPLOT %in% input[[sprintf('tpTran%sTPlot', paste(x))]]))
        })
        tpVals$dat[inds,]
    })
})

