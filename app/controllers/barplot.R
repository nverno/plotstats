### barplot.R --- 
## Filename: barplot.R
## Description: 
## Author: Noah Peart
## Created: Thu Oct 22 20:40:52 2015 (-0400)
## Last-Updated: Thu Oct 22 23:29:23 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'bplt'

bpltDat <- reactive({
    samp <- dat()
    if (nrow(samp) < 1) return()
    if (.debug) print('Changed bpltDat()')
    samp$breaks <- cut(samp$DBH,
                       breaks=seq(5, max(samp$DBH, na.rm=TRUE)+input$bpltDBHWidth,
                           by=input$bpltDBHWidth),
                       include.lowest=TRUE)
    samp[samp$STAT == 'ALIVE', ]
})

output$bpltDBHSizeClass <- renderPlot({
    if (is.null(bpltDat())) return()
    
    p <- ggplot(bpltDat(), aes(breaks, fill=SPEC)) +
      geom_bar(color='black') +
      scale_x_discrete(drop=FALSE) + defaults +
      theme(axis.text.x = element_text(angle=60, hjust=1)) +
      ylab("Count") +
      xlab("DBH Size Classes")

    ## Deal with panel splitting
    p + splitForm()
})
