### barplotSizeClass.R --- 
## Filename: barplotSizeClass.R
## Description: DBH classes barplots (stacked by species)
## Author: Noah Peart
## Created: Wed Oct  7 20:19:49 2015 (-0400)
## Last-Updated: Wed Oct 14 19:19:23 2015 (-0400)
##           By: Noah Peart
######################################################################
## variable prefix: 'bsc' ==> barSizeClass

output$barSizeClassUI <- renderUI({
    fluidPage(
        radioButtons('bscLayout', 'Layout:', choices=c('WellPanel', 'Sidebar'), inline=TRUE),
        conditionalPanel(
            condition = "input.bscLayout == 'WellPanel'",
            uiOutput('barSizeClassWellUI')
        ),
        conditionalPanel(
            condition = "input.bscLayout == 'Sidebar'",
            uiOutput('barSizeClassSideUI')
        )
    )
})

## Sidebar layout
output$barSizeClassSideUI <- renderUI({
    sidebarLayout(
        sidebarPanel(
            ## Data subsetting options
            ## uiOutput('tpSubset'),

            ## Graphing options
            uiOutput('barSizeOpts')
        ),
        mainPanel(
            plotOutput('barSizeClass')
        )
    )
})

## Wellpanel Layout
output$barSizeClassWellUI <- renderUI({
    fluidRow(
        column(12, 
               plotOutput('barSizeClass')
               )
    )
    ## wellPanel(uiOutput('barSizeOpts'))
})

## Graphing options
output$barSizeOpts <- renderUI({
    list(
        helpText('Graphing Options'),
        
        ## Splitting panels
        uiOutput('tpVisSplit'),
        
        ## DBH breaks
        numericInput('bscWidth', 'Width of DBH classes', value=5, min=0)
    )
})

################################################################################
##
##                                 Observers
##
################################################################################
             
################################################################################
##
##                                 Reactives
##
################################################################################
## Data
bscDat <- reactive({
    samp <- tpDat()
    if (nrow(samp) < 1) return()
    samp$breaks <- cut(samp$DBH,
                       breaks=seq(5, max(samp$DBH, na.rm=TRUE)+input$bscWidth, by=input$bscWidth),
                       include.lowest=TRUE)
    samp[samp$STAT == 'ALIVE', ]
})

################################################################################
##
##                                 Graphics
##
################################################################################
output$barSizeClass <- renderPlot({
    if (is.null(bscDat())) return()

    p <- ggplot(bscDat(), aes(breaks, fill=SPEC)) +
      geom_bar(color='black') +
      scale_x_discrete(drop=FALSE) + defaults +
      theme(axis.text.x = element_text(angle=60, hjust=1)) +
      ylab("Count") +
      xlab("DBH Size Classes")

    ## Deal with panel splitting
    p + splitForm()
})
