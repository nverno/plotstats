### code.R --- 
## Filename: code.R
## Description: 
## Author: Noah Peart
## Created: Sun Nov  1 00:18:47 2015 (-0400)
## Last-Updated: Sun Nov  1 01:52:58 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'code'

output$codeOutput <- renderPrint({
    input$codeEval
    input$runKey
    isolate(eval(parse(text=input$codeCode)))
})

observeEvent(input$codeMode, updateAceEditor(session, 'codeCode', mode=input$codeMode))
observeEvent(input$codeTheme, updateAceEditor(session, 'codeCode', theme=input$codeTheme))
