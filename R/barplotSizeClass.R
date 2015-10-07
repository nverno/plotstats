### barplotSizeClass.R --- 
## Filename: barplotSizeClass.R
## Description: DBH classes barplots (stacked by species)
## Author: Noah Peart
## Created: Wed Oct  7 20:19:49 2015 (-0400)
## Last-Updated: Wed Oct  7 21:02:17 2015 (-0400)
##           By: Noah Peart
######################################################################
## variable prefix: 'bsc' ==> barSizeClass

## dat <- with(tp, tp[TRAN == 'E320' & TPLOT == 1 & STAT == 'ALIVE',])
## dat$breaks <- cut(dat$DBH, breaks=seq(5, max(dat$DBH, na.rm=TRUE)+5, by=5), include.lowest=TRUE)
## ggplot(dat, aes(breaks, fill=SPEC)) + geom_bar() + facet_grid(~YEAR) +
##   scale_x_discrete(drop=FALSE) +
##   scale_fill_brewer(palette='Spectral') + defaults

output$barSizeClassUI <- renderUI({
    ps <- sort(unique(dat()$TPLOT))
    
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput('bscTransect', 'Transect:', choices=levels(dat()$TRAN),
                               selected=levels(dat()$TRAN)[1], inline=TRUE),
            checkboxGroupInput('bscTPlot', 'Plot:', choices=ps, selected=ps[[1]], inline=TRUE),
            numericInput('bscWidth', 'Width of DBH classes', value=5, min=0)
        ),
        mainPanel(
            barSizeClass
        )
    )
})

observeEvent(input$bscTransect, {
    ops <- sort(unique(dat()$TPLOT[dat()$TRAN %in% input$bscTransect]))
    updateCheckboxGroupInput(session, 'bscTPlot', choices=ops, selected=ops[[1]], inline=TRUE)
})

## Reactives
bscDat <- reactive({
    samp <- dat()
    samp$breaks <- cut(samp$DBH,
                       breaks=seq(5, max(samp$DBH, na.rm=TRUE)+input$bscWidth, by=input$bscWidth),
                       include.lowest=TRUE)
    samp[samp$STAT == 'ALIVE' & samp$TRAN %in% input$bscTransect & samp$TPLOT %in% input$bscTPlot, ]
})

## Graphics
barSizeClass <- renderPlot({
    ggplot(bscDat(), aes(breaks, fill=SPEC)) +
      geom_bar() +
      facet_grid(TPLOT~YEAR) +
      scale_x_discrete(drop=FALSE) + defaults +
      theme(axis.text.x = element_text(angle=60, hjust=1)) +
      ylab("Count") +
      xlab("DBH Size Classes")
})
